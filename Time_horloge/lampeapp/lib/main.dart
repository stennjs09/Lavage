import 'package:flutter/material.dart';
import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:android_flutter_wifi/android_flutter_wifi.dart';

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
  String formattedTime = '';

  @override
  void initState() {
    super.initState();
    init();
    timenow();
  }

  void timenow() {
    DateTime now = DateTime.now();
    formattedTime =
        '${_twoDigits(now.hour)}:${_twoDigits(now.minute)}:${_twoDigits(now.second)}';
  }

  String _twoDigits(int n) {
    if (n >= 10) {
      return '$n';
    }
    return '0$n';
  }

  void _checkWifiStatus() async {
    var isConnectedToWifi = await AndroidFlutterWifi.isConnected();
    if (!isConnectedToWifi) {
      await _showWifiConnectionDialog();
    } else {
      _connectToWebSocket();
    }
  }

  void init() async {
    // Initialize AndroidFlutterWifi
    await AndroidFlutterWifi.init();

    // Check if device is connected to Wi-Fi
    var isConnectedToWifi = await AndroidFlutterWifi.isConnected();
    if (!isConnectedToWifi) {
      // If not connected to Wi-Fi, show Wi-Fi connection dialog
      await _showWifiConnectionDialog();
    } else {
      // If connected to Wi-Fi, establish WebSocket connection
      _connectToWebSocket();
    }
  }

  // Function to show Wi-Fi connection dialog
  Future<void> _showWifiConnectionDialog() async {
    String ssid = '*'; // Replace 'YourSSID' with your Wi-Fi SSID
    String password =
        '12345678'; // Replace 'YourPassword' with your Wi-Fi password

    // Show Wi-Fi connection dialog
    await AndroidFlutterWifi.connectToNetwork(ssid, password);

    // Once Wi-Fi connection is established, connect to WebSocket
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
        // Retry connecting to WebSocket after a delay
        _checkWifiStatus();
      },
      onError: (error) {
        print('WebSocket error: $error');
        setState(() {
          isConnected = false;
        });
        // Retry connecting to WebSocket after a delay
        _checkWifiStatus();
      },
      cancelOnError: true,
    );

    // Update isConnected state upon successful connection
    setState(() {
      isConnected = true;
    });
    _channel.sink.add(formattedTime);
  }

  @override
  void dispose() {
    _channel.sink.close();
    // Cancel reconnection timer if active
    _reconnectTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Transform.scale(
          scale: 2.0,
          child: !isConnected
              ? SpinKitThreeBounce(
                  color: Colors.green,
                  size: 30.0,
                )
              : Transform.rotate(
                  angle: -90 * (3.14 / 180),
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
                    activeColor: Colors.grey,
                  ),
                ),
        ),
      ),
    );
  }
}
