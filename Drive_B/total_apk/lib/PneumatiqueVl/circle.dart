import 'package:flutter/material.dart';
import 'dart:async';
import 'package:total_apk/PneumatiqueVl/dropdown.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:total_apk/main.dart';
import 'package:total_apk/Services/web_socket_manager.dart';

class BlinkingCircleVl extends StatefulWidget {
  @override
  _BlinkingCircleVlState createState() => _BlinkingCircleVlState();
}

bool vlLibre = true;
String vlMessage = 'Pneumatique libre';
late AnimationController _controllervl;

class _BlinkingCircleVlState extends State<BlinkingCircleVl>
    with SingleTickerProviderStateMixin {

  late Animation<double> _animation;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _controllervl = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _animation = Tween<double>(begin: 10.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controllervl,
        curve: Curves.easeInOut,
      ),
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controllervl.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _controllervl.forward();
      }
    });

    if(vlMessage == 'Peumatique libre'){
      _controllervl.stop();
      vlLibre = true;
    }else{
      _controllervl.forward();
      vlLibre = false;
    }

  }

  Future<void> confirmEspOn() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Ajouter ce temps au pneumatique?'),
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
                _espOn(tempVl);
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
    _controllervl.dispose();
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
            if (!vlLibre) {
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
                  color: Colors.red,
                  size: 40.0,
                )
                    : Text(
                  '$vlMessage',
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
                Icon(Icons.send, color: vlLibre ? Colors.blue : Colors.red),
              ),
            ),
          ),
      ],
    );
  }

  void _espOn(time) {
    WebSocketManager.send("total:pneumatique:" + time.toString());
  }

  void _espOff() {
    WebSocketManager.send("total.pneumatique.off");
  }
}


void CheckVlMessage(mess) {
  String message = '';
  try {
    message = String.fromCharCodes(mess);
  } catch (e) {
    message = mess;
  }
  List<String> messSplit = message.split(":");

  if (messSplit[0] == 'total' &&
      messSplit[1] == 'pneumatique' &&
      messSplit[2] == '0') {

    vlMessage = 'Peumatique libre';
    _controllervl.stop();
    vlLibre = true;
  } else if (messSplit[0] == 'total' &&
      messSplit[1] == 'pneumatique' &&
      messSplit[2] != '0') {

      vlMessage = messSplit[2] + ' min';
    _controllervl.forward();
    vlLibre = false;

  }
}

