import 'package:flutter/material.dart';
import 'package:total_apk/main.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:total_apk/Services/delayed_animation.dart';
import 'package:total_apk/Lavage/dropdown.dart';
import 'package:total_apk/PneumatiqueVl/dropdown.dart';

class PersistentTabScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    List<Widget> _buildScreens() {
      // Ajoutez ici les écrans que vous souhaitez afficher
      return [
        Screen1(),
        Screen2(),
      ];
    }

    List<PersistentBottomNavBarItem> _navBarsItems() {
      // Ajoutez ici les éléments de la barre de navigation
      return [
        PersistentBottomNavBarItem(
          icon: Icon(Icons.warehouse_sharp),
          title: "Lavage",
          activeColorPrimary: Colors.red,
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(Icons.car_repair_outlined),
          title: "Pneumatique",
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
              'assets/logoTotal.png',
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
        backgroundColor: Colors.red,
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
                '  PNEUMATIQUE',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: MyListViewVl(),
      ),
    );
  }
}
