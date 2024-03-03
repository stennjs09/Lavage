import 'package:flutter/material.dart';
import 'dart:async';
import 'package:galana_apk/PneumatiquePl/dropdown.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:galana_apk/main.dart';
import 'package:web_socket_channel/io.dart';

class BlinkingCirclePl extends StatefulWidget {
  @override
  _BlinkingCirclePlState createState() => _BlinkingCirclePlState();
}

class _BlinkingCirclePlState extends State<BlinkingCirclePl>
    with SingleTickerProviderStateMixin {

  bool plLibre = true;
  String plMessage = 'Appareil HS';
  late AnimationController _controller;
  late Animation<double> _animation;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    channel.sink.add("galana.pneumatique_pl.temps");

    channel = IOWebSocketChannel.connect(wsServer);
    channel.stream.listen(
      (message) {
        CheckPlMessage(message);
      },
    );

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _animation = Tween<double>(begin: 10.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      });
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
    _controller.dispose();
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

  void CheckPlMessage(message) {
    List<String> messSplit = message.split("/");

    if (messSplit[0] == 'galana' &&
        messSplit[1] == 'pneumatique_pl' &&
        messSplit[2] == '0') {
      plMessage = 'PL libre';
      _controller.stop();
      plLibre = true;
    } else if (messSplit[0] == 'galana' &&
        messSplit[1] == 'pneumatique_pl' &&
        messSplit[2] != '0') {

      setState(() {
        plMessage = messSplit[2] + ' min';
      });
      _controller.forward();
      plLibre = false;

    }
  }

  void _espOn(time) {
    channel.sink.add("galana/pneumatique_pl/" + time.toString());
  }

  void _espOff() {
    channel.sink.add("galana.pneumatique_pl.off");
  }
}
