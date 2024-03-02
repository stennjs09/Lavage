import 'package:flutter/material.dart';
import 'package:galana_apk/main.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:galana_apk/Services/delayed_animation.dart';
import 'package:galana_apk/Lavage/dropdown.dart';
// import 'package:galana_apk/PneumatiqueVl/dropdown.dart';
// import 'package:galana_apk/PneumatiquePl/dropdown.dart';


class PersistentTabScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    List<Widget> _buildScreens() {
      // Ajoutez ici les écrans que vous souhaitez afficher
      return [
        Screen1(),
        Screen2(),
        Screen3(),
      ];
    }

    List<PersistentBottomNavBarItem> _navBarsItems() {
      // Ajoutez ici les éléments de la barre de navigation
      return [
        PersistentBottomNavBarItem(
          icon: Icon(Icons.warehouse_sharp),
          title: "Lavage",
          activeColorPrimary: Colors.green,
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Icons.car_repair_outlined),
          title: "Pneu VL",
          activeColorPrimary: Colors.blue,
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Icons.car_repair),
          title: "Pneu PL",
          activeColorPrimary: Colors.blue,
          inactiveColorPrimary: Colors.grey,
        ),
      ];
    }

    return PersistentTabView(
        context,
        controller: PersistentTabController(),
        screens: _buildScreens(),
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: Colors.white,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        hideNavigationBarWhenKeyboardShows: true,
        decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        ),
        popAllScreensOnTapOfSelectedTab: true,
        navBarStyle: NavBarStyle.style9,
  );
}
}


class Logo extends StatefulWidget {
  @override
  _LogoState createState() => _LogoState();
}

class _LogoState extends State<Logo> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DelayedAnimation(
        delay: 1000,
        child: Stack(
          children: [
            Image.asset(
              'assets/logoGalana.png',
              width: 50,
              height: 50,
            ),
            Positioned(
              right: 2,
              bottom: 4,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: statusColor, // statusColor is not defined here
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class dotsMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
        icon: Icon(Icons.more_vert, color: Colors.white),
      onSelected: (value) {
        // Action à effectuer en fonction de la sélection du menu
        if (value == 'about') {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  'À propos',
                  style: TextStyle(
                    color: Colors.black45,
                  ),
                ),
                content: Text(
                  'Notre déploiement d\'application pour les stations-service marque une avancée significative dans la gestion à distance des appareils.\n\n En permettant aux utilisateurs de contrôler directement leurs équipements depuis leurs smartphones, nous éliminons les contraintes liées à la présence physique, garantissant ainsi un contrôle efficace et fluide à distance.',
                  style: TextStyle(
                    color: Colors.black45,
                  ),
                ),
                backgroundColor:
                Colors.white, // Couleur de fond blanche
                actions: <Widget>[],
              );
            },
          );
        }
        if (value == 'public') {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Confirmation'),
                content: Text('Activer le mode public?'),
                actions: <Widget>[
                  TextButton(
                    child: Text('Non'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text('Oui, activer'),
                    onPressed: () {
                      wsServer = wsServerPublic;
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
        if (value == 'local') {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Confirmation'),
                content: Text('Activer le mode local?'),
                actions: <Widget>[
                  TextButton(
                    child: Text('Non'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text('Oui, activer'),
                    onPressed: () {
                      wsServer = wsServerLocal;
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          if(wsServer == wsServerLocal)
            PopupMenuItem(
              value: 'public',
              child: ListTile(
                leading: Icon(Icons.cell_wifi), // Utilisation de Icons.warehouse_sharp
                title: Text(
                  'Mode public',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          if(wsServer == wsServerPublic)
            PopupMenuItem(
              value: 'local',
              child: ListTile(
                leading: Icon(Icons.wifi_lock), // Utilisation de Icons.warehouse_sharp
                title: Text(
                  'Mode local',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),

          PopupMenuItem(
            value: 'about',
            child: ListTile(
              leading: Icon(Icons.android),
              title: Text(
                'À propos',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ];
      },
      color: Colors.white, // Couleur du popup menu
    );
  }
}

// Créez vos écrans individuels ici en remplaçant Screen1 et Screen2 par vos propres widgets
class Screen1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Logo(),
            DelayedAnimation(
              delay: 1000,
              child: Text(
                '  LAVAGE',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        actions: <Widget>[
          DelayedAnimation(
            delay: 0,
            child: dotsMenu()
          ),
        ],
      ),
      body: DelayedAnimation(
        delay: 1000,
        child: Container(
          child: MyListView(),
        ),
      ),
    );
  }
}

class Screen2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Logo(),
            DelayedAnimation(
              delay: 500,
              child: Text(
                '  PNEUMATIQUE VL',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        actions: <Widget>[
          DelayedAnimation(
              delay: 0,
              child: dotsMenu()
          ),
        ],
      ),
      body: Center(
        // child: MyListViewVl(),
      ),
    );
  }
}

class Screen3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Logo(),
            DelayedAnimation(
              delay: 500,
              child: Text(
                '  PNEUMATIQUE PL',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        actions: <Widget>[
          DelayedAnimation(
              delay: 0,
              child: dotsMenu()
          ),
        ],
      ),
      body: Center(
        // child: MyListViewPl(),
      ),
    );
  }
}