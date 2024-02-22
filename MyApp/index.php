<?php
require __DIR__ . '/vendor/autoload.php';

use Ratchet\MessageComponentInterface;
use Ratchet\ConnectionInterface;
use Ratchet\Server\IoServer;
use Ratchet\Http\HttpServer;
use Ratchet\WebSocket\WsServer;

class WebSocketApplication implements MessageComponentInterface {
   public function onOpen(ConnectionInterface $conn) {
       echo "Nouvelle connexion établie : {$conn->resourceId}\n";

       // Envoyer un message de bienvenue à l'utilisateur
       $conn->send("Bienvenue ! Vous êtes connecté.");
   }

   public function onMessage(ConnectionInterface $from, $msg) {
       // Logique pour gérer les messages reçus
   }

   public function onClose(ConnectionInterface $conn) {
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
   8096 // Vous pouvez choisir le port ici
);

echo "Serveur WebSocket démarré sur le port 8080...\n";

$server->run();
