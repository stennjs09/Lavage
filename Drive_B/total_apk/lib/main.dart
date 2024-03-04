import 'package:flutter/material.dart';
import 'package:total_apk/BottomNavbar.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:connectivity/connectivity.dart';
import 'dart:developer' as developer;

void main() {
  runApp(MyApp());
}

String wsServerPublic = 'ws://102.16.44.51:8087';
String wsServerLocal = 'ws://192.168.88.18:8087';
String wsServer = wsServerLocal;
late WebSocketChannel channel;
Color statusColor = Colors.red;
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
    showDialogIfNeeded();
  }

  void showDialogIfNeeded() async {
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
                          wsServer = wsServerPublic;
                          start = true;
                          Connectivity().onConnectivityChanged.listen((result) {
                            if (result == ConnectivityResult.none) {
                              setState(() {
                                isConnected = false;
                                statusColor = Colors.red;
                              });
                            } else {
                              connectToWebSocket();
                            }
                          });
                        });
                        Navigator.of(context).pop();
                        connectToWebSocket();
                      },
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      child: Text('Local'),
                      onPressed: () {
                        setState(() {
                          wsServer = wsServerLocal;
                          start = true;
                          Connectivity().onConnectivityChanged.listen((result) {
                            if (result == ConnectivityResult.none) {
                              setState(() {
                                isConnected = false;
                                statusColor = Colors.red;
                              });
                            } else {
                              connectToWebSocket();
                            }
                          });
                        });
                        Navigator.of(context).pop();
                        connectToWebSocket();
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


  void connectToWebSocket() {
    if (!isConnected) {
      channel = IOWebSocketChannel.connect(wsServer);
      channel.stream.listen(
            (message) {
          setState(() {
            isConnected = true;
            statusColor = Colors.lightGreenAccent;
          });
        },
        onError: (error) {
          setState(() {
            isConnected = false;
            statusColor = Colors.red;
          });
          // Attempt reconnection after a delay
          Future.delayed(Duration(seconds: 5), () {
            connectToWebSocket();
          });
        },
        onDone: () {
          setState(() {
            isConnected = false;
            statusColor = Colors.red;
          });
          // Attempt reconnection after a delay
          Future.delayed(Duration(seconds: 5), () {
            connectToWebSocket();
          });
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: start ? PersistentTabScreen():null,
    );
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }
}
