import 'package:flutter/material.dart';
import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

void main() {
  runApp(MyApp());
}

String wsServer = 'ws://192.168.4.1:81';
bool isConnected = false;
bool lampOn = false;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  late WebSocketChannel _channel;
  late Timer _reconnectTimer;

  @override
  void initState() {
    super.initState();
    _connectToWebSocket();
  }

  void _connectToWebSocket() {
    _channel = WebSocketChannel.connect(Uri.parse(wsServer));
    _listenToWebSocket();
  }

  void _listenToWebSocket() {
    _channel.stream.listen(
          (message) {
        if (message == 'lamp on') {
          setState(() {
            lampOn = true;
          });
        } else if (message == 'lamp off') {
          setState(() {
            lampOn = false;
          });
        }
      },
      onDone: () {
        print('WebSocket connection closed');
        setState(() {
          isConnected = false;
        });
        // Lancer un Timer pour tenter de se reconnecter après un certain délai
        _reconnectTimer = Timer(Duration(seconds: 5), _connectToWebSocket);
      },
      onError: (error) {
        print('WebSocket error: $error');
        setState(() {
          isConnected = false;
        });
        // Lancer un Timer pour tenter de se reconnecter après un certain délai
        _reconnectTimer = Timer(Duration(seconds: 5), _connectToWebSocket);
      },
      cancelOnError: true, // Arrête d'écouter les événements après une erreur
    );

    // Mettre à jour isConnected lors de la connexion réussie
    setState(() {
      isConnected = true;
    });
  }

  @override
  void dispose() {
    _channel.sink.close();
    // Annuler le timer de reconnexion s'il est en cours
    _reconnectTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Transform.scale(
          scale: 2.0, // Facteur d'échelle pour agrandir le bouton Switch
          child: !isConnected
              ? SpinKitThreeBounce(
            color: Colors.green,
            size: 30.0,
          )
              : Transform.rotate(
            angle: -90 * (3.14 / 180), // -90 degrés en radians
            child: Switch(
              value: lampOn,
              onChanged: (value) {
                setState(() {
                  if (lampOn == false) {
                    _channel.sink.add('on');
                  } else if (lampOn == true) {
                    _channel.sink.add('off');
                  }
                });
              },
              activeColor: Colors.grey, // Couleur lorsque le switch est activé
            ),
          ),

        ),
      ),
    );
  }
}
