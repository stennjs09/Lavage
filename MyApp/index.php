<?php
error_reporting(E_ALL & ~E_DEPRECATED & ~E_NOTICE);
require __DIR__ . '/vendor/autoload.php';
include 'connexion.php';

use Ratchet\MessageComponentInterface;
use Ratchet\ConnectionInterface;
use Ratchet\Server\IoServer;
use Ratchet\Http\HttpServer;
use Ratchet\WebSocket\WsServer;

class WebSocketApplication implements MessageComponentInterface {
    protected $clients;

    public function __construct() {
        $this->clients = new \SplObjectStorage;
    }

    public function onOpen(ConnectionInterface $conn) {
        global $connexion;
        $this->clients->attach($conn);
        echo "Nouvelle connexion établie : {$conn->resourceId}\n";
        
        $requete = "(SELECT nom_esp, temps, 'total' AS table_name FROM total) 
                    UNION 
                    (SELECT nom_esp, temps, 'galana' AS table_name FROM galana)";
        $resultat = $connexion->query($requete); 
    
        if ($resultat->num_rows > 0) {
            while ($row = $resultat->fetch_assoc()) {
                $conn->send($row["table_name"].":".$row["nom_esp"].":".$row["temps"]);
            }
        }
    }
    

    public function onMessage(ConnectionInterface $from, $msg) {
        global $connexion;

        if (strpos($msg, ':') !== false) {
            $parts = explode(':', $msg, 4);

        $sql = "UPDATE $parts[0] SET temps = ? WHERE nom_esp = ?";
        $stmt = $connexion->prepare($sql);
        $stmt->bind_param("ss", $parts[2], $parts[1]);
        $stmt->execute();
        
        }
        
        foreach ($this->clients as $client) {
            if ($from !== $client) {
                $client->send($msg);
            }
        }
        
    }

    public function onClose(ConnectionInterface $conn) {
        $this->clients->detach($conn);
        echo "La connexion {$conn->resourceId} est déconnectée\n";
    }

    public function onError(ConnectionInterface $conn, \Exception $e) {
        echo "Une erreur est survenue : {$e->getMessage()}\n";
        $conn->close();
    }
}

$server = IoServer::factory(
    new HttpServer(
        new WsServer(
            new WebSocketApplication()
        )
    ),
    8096
);

echo "Serveur WebSocket démarré sur le port 8096...\n";

$server->run();



/*********************************************************************************************************************************************************************************/
