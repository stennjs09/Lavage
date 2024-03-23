import 'package:flutter/material.dart';
import 'dart:async';
import 'package:galana_apk/LavageM/dropdown.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:galana_apk/main.dart';
import 'package:galana_apk/Services/web_socket_manager.dart';

class BlinkingCircleLM extends StatefulWidget {
  @override
  _BlinkingCircleLMState createState() => _BlinkingCircleLMState();
}

bool lavageMLibre = true;
String lavageMMessage = 'L.Moteur libre';
late AnimationController _controllerLM;

class _BlinkingCircleLMState extends State<BlinkingCircleLM>
    with SingleTickerProviderStateMixin {

  late Animation<double> _animation;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _controllerLM = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _animation = Tween<double>(begin: 10.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controllerLM,
        curve: Curves.easeInOut,
      ),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controllerLM.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _controllerLM.forward();
        }
      });

    if(lavageMMessage == 'L.Moteur libre'){
      _controllerLM.stop();
      lavageMLibre = true;
    }else{
      _controllerLM.forward();
      lavageMLibre = false;
    }
  }
  Future<void> confirmEspOn() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Ajouter ce temps au lavage?'),
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
                _espOn(tempLavageM);
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
    _controllerLM.dispose();
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
            Color damnColor = Colors.green; // Default color
            if (!lavageMLibre) {
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
                        color: Colors.green,
                        size: 40.0,
                      )
                    : Text(
                        '$lavageMMessage',
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
        if(isConnected)
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
                child: Icon(Icons.send, color: lavageMLibre ? Colors.green : Colors.red),
              ),
            ),
          ),

      ],
    );
  }

  void _espOn(time) {
    WebSocketManager.send("galana:lavage_moteur:"+time.toString());
  }
  void _espOff() {
    WebSocketManager.send("galana:lavage_moteur:off");
  }
}


void CheckLavageMMessage(mess){
  String message = '';
  try {
    message = String.fromCharCodes(mess);
  } catch (e) {
    message = mess;
  }
  List<String> messSplit = message.split(":");


  if (messSplit[0] == 'galana' && messSplit[1] == 'lavage_moteur' && messSplit[2] == '0') {
      lavageMMessage = 'L.Moteur libre';
      _controllerLM.stop();
    lavageMLibre = true;
  }else if(messSplit[0]=='galana' && messSplit[1] =='lavage_moteur' && messSplit[2] != '0'){
      lavageMMessage = messSplit[2] + ' min';
      _controllerLM.forward();
    lavageMLibre = false;
  }
}