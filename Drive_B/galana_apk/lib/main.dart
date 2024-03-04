import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:galana_apk/BottomNavbar.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:connectivity/connectivity.dart';

void main() {
  runApp(MyApp());
}

String wsServerPublic  = 'ws://102.16.44.51:8087';
String wsServerLocal  = 'ws://192.168.88.18:8087';
String wsServer = wsServerLocal;
late WebSocketChannel channel;
Color statusColor = Colors.red;
bool isConnected = false;


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
    connectToWebSocket();
    Connectivity().onConnectivityChanged.listen((result) {
      if (result == ConnectivityResult.none) {
        setState(() {
          isConnected = false;
          statusColor = Colors.red;
        });
      }else {
        connectToWebSocket();
      }
    });
  }
  void connectToWebSocket() {
    if(!isConnected) {
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
      body: PersistentTabScreen(),
    );
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }
}
