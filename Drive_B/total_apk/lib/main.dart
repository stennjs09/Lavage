import 'package:flutter/material.dart';
import 'dart:async';
import 'package:total_apk/BottomNavbar.dart';
import 'package:total_apk/Services/web_socket_manager.dart';
import 'package:total_apk/Lavage/circle.dart';
import 'package:total_apk/PneumatiqueVl/circle.dart';

void main() {
  runApp(MyApp());
}

String wsServerPublic = 'ws://102.16.44.51:8087';
String wsServerLocal = 'ws://192.168.88.18:8087';
String wsServer = '';
bool isConnected = false;
bool start = false;


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
  @override
  void initState() {
    super.initState();
    connexionDialog();
  }

  void _listenToWebSocket() {
    WebSocketManager.listen((message) {
      CheckLavageMessage(message);
      CheckVlMessage(message);
      setState(() {
        isConnected = true;
      });
    }, () {
      setState(() {
        isConnected = false;
      });

      Future.delayed(Duration(seconds: 5), () {
        WebSocketManager.connect(wsServer);
        _listenToWebSocket();
      });
    });
  }

  void connexionDialog() async {
    await Future.delayed(Duration.zero);
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('BIENVENUE'),
          content: Text('Choisir le mode de connexion :'),
          actions: <Widget>[
            Container(
              width: double.infinity,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextButton(
                      child: Text('Public'),
                      onPressed: () {
                        setState(() {
                          ;
                          start = true;
                        });
                        wsServer = wsServerPublic;
                        WebSocketManager.connect(wsServer);
                        _listenToWebSocket();
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      child: Text('Local'),
                      onPressed: () {
                        setState(() {
                          start = true;
                        });
                        wsServer = wsServerLocal;
                        WebSocketManager.connect(wsServer);
                        _listenToWebSocket();
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: start ? PersistentTabScreen() : null,
    );
  }

  @override
  void dispose() {
    WebSocketManager.close();
    super.dispose();
  }
}
