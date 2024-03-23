import 'package:flutter/material.dart';
import 'dart:async';
import 'package:galana_apk/PneumatiquePl/dropdown.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:galana_apk/main.dart';
import 'package:galana_apk/Services/web_socket_manager.dart';

class BlinkingCirclePl extends StatefulWidget {
  @override
  _BlinkingCirclePlState createState() => _BlinkingCirclePlState();
}

bool plLibre = true;
String plMessage = 'PL libre';
late AnimationController _controllerPL;

class _BlinkingCirclePlState extends State<BlinkingCirclePl>
    with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _controllerPL = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _animation = Tween<double>(begin: 10.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controllerPL,
        curve: Curves.easeInOut,
      ),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controllerPL.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _controllerPL.forward();
        }
      });

    if(plMessage == 'PL libre'){
      _controllerPL.stop();
      plLibre = true;
    }else{
      _controllerPL.forward();
      plLibre = false;
    }
  }

  Future<void> confirmEspOn() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Ajouter ce temps au pl?'),
          actions: <Widget>[
            TextButton(
              child: Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                _espOn(tempPl);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> confirmEspOff() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Arrêter l\'appareil maintenant ?'),
          actions: <Widget>[
            TextButton(
              child: Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                _espOff();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _controllerPL.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            Color damnColor = Colors.blue; // Default color
            if (!plLibre) {
              damnColor = Colors.red;
            }
            return Container(
              margin: EdgeInsets.only(top: 80),
              width: 230.0,
              height: 230.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: damnColor,
                  width: _animation.value,
                ),
              ),
              child: Center(
                child: !isConnected
                    ? SpinKitThreeBounce(
                        color: Colors.blue,
                        size: 40.0,
                      )
                    : Text(
                        '$plMessage',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: damnColor,
                        ),
                      ),
              ),
            );
          },
        ),
        if (isConnected)
          Positioned(
            bottom: 20.0,
            right: 0,
            child: GestureDetector(
              onLongPress: () {
                confirmEspOff();
              },
              child: FloatingActionButton(
                onPressed: () {
                  confirmEspOn();
                },
                backgroundColor: Colors.white,
                child:
                    Icon(Icons.send, color: plLibre ? Colors.blue : Colors.red),
              ),
            ),
          ),
      ],
    );
  }

  void _espOn(time) {
    WebSocketManager.send("galana:pneumatique_pl:" + time.toString());
  }

  void _espOff() {
    WebSocketManager.send("galana:pneumatique_pl:off");
  }
}

void CheckPlMessage(mess) {
  String message = '';
  try {
    message = String.fromCharCodes(mess);
  } catch (e) {
    message = mess;
  }
  List<String> messSplit = message.split(":");

  if (messSplit[0] == 'galana' &&
      messSplit[1] == 'pneumatique_pl' &&
      messSplit[2] == '0') {
    plMessage = 'PL libre';
    _controllerPL.stop();
    plLibre = true;
  } else if (messSplit[0] == 'galana' &&
      messSplit[1] == 'pneumatique_pl' &&
      messSplit[2] != '0') {
    plMessage = messSplit[2] + ' min';
    _controllerPL.forward();
    plLibre = false;
  }
}
