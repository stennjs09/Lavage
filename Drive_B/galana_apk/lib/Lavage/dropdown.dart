import 'package:flutter/material.dart';
import 'package:galana_apk/Lavage/circle.dart';
import 'package:galana_apk/Services/delayed_animation.dart';
import 'package:galana_apk/main.dart';

class MyListView extends StatefulWidget {
  @override
  _MyListViewState createState() => _MyListViewState();
}

String selectedCategory = 'Scooter';
String selectedType = 'Exterieur';
int price = 4000;
int temp = 20;

void sendDataToServer(selectedCategory, selectedType, price, temp ) async {

}

class _MyListViewState extends State<MyListView> {
  void setPrice() {
    if (selectedCategory == 'Scooter') {
      setState(() {
        price = 4000;
        temp = 20;
      });
    } else if (selectedCategory == 'Cross') {
      setState(() {
        price = 5000;
        temp = 20;
      });
    }
    if (selectedCategory == 'Radiateur PM') {
      setState(() {
        price = 5000;
        temp = 15;
      });
    } else if (selectedCategory == 'Radiateur GM') {
      setState(() {
        price = 10000;
        temp = 15;
      });
    } else if (selectedCategory == 'Légère' && selectedType == 'Interieur') {
      setState(() {
        price = 5000;
        temp = 1;
      });
    } else if (selectedCategory == 'Légère' && selectedType == 'Exterieur') {
      setState(() {
        price = 8000;
        temp = 30;
      });
    } else if (selectedCategory == 'Légère' &&
        selectedType == 'Interieur et exterieur') {
      setState(() {
        price = 13000;
        temp = 30;
      });
    } else if (selectedCategory == '4x4' && selectedType == 'Interieur') {
      setState(() {
        price = 6000;
        temp = 1;
      });
    } else if (selectedCategory == '4x4' && selectedType == 'Exterieur') {
      setState(() {
        price = 10000;
        temp = 60;
      });
    } else if (selectedCategory == '4x4' &&
        selectedType == 'Interieur et exterieur') {
      setState(() {
        price = 16000;
        temp = 60;
      });
    } else if (selectedCategory == 'Minibus et Sprinter' &&
        selectedType == 'Interieur') {
      setState(() {
        price = 7000;
        temp = 1;
      });
    } else if (selectedCategory == 'Minibus et Sprinter' &&
        selectedType == 'Exterieur') {
      setState(() {
        price = 13000;
        temp = 90;
      });
    } else if (selectedCategory == 'Minibus et Sprinter' &&
        selectedType == 'Interieur et exterieur') {
      setState(() {
        price = 20000;
        temp = 90;
      });
    } else if (selectedCategory == 'Camionnette') {
      setState(() {
        price = 40000;
        temp = 120;
      });
    } else if (selectedCategory == 'Camion -5T') {
      setState(() {
        price = 45000;
        temp = 150;
      });
    } else if (selectedCategory == 'Camion +5T') {
      setState(() {
        price = 85000;
        temp = 150;
      });
    } else if (selectedCategory == 'Moteur 4C') {
      setState(() {
        price = 10000;
        temp = 20;
      });
    } else if (selectedCategory == 'Moteur 5C') {
      setState(() {
        price = 15000;
        temp = 20;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            children: [
              SizedBox(height: 20),
              ListTile(
                tileColor: Color(0xE4EFEFEF),
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(40), // Ajout d'un BorderRadius
                ),
                title: Row(
                  children: [
                    Icon(Icons.control_point_duplicate),
                    SizedBox(width: 10),
                    Text('Catégorie: '),
                    Spacer(),
                    Text(selectedCategory),
                  ],
                ),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Catégories'),
                        content: Container(
                          height: 200,
                          width: double.maxFinite,
                          child: ListView(
                            children: [
                              for (var category in [
                                'Scooter',
                                'Cross',
                                'Radiateur PM',
                                'Radiateur GM',
                                'Légère',
                                '4x4',
                                'Minibus et Sprinter',
                                'Camionnette',
                                'Camion -5T',
                                'Camion +5T',
                                'Moteur 4C',
                                'Moteur 5C',
                              ])
                                ListTile(
                                  title: Text(
                                    category,
                                    style: TextStyle(
                                      color: selectedCategory == category
                                          ? Colors.blue
                                          : Colors.black,
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      selectedCategory = category;
                                      setPrice(); // Appel de la fonction pour définir le prix
                                    });
                                    Navigator.of(context).pop();
                                  },
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              if (selectedCategory == 'Légère' ||
                  selectedCategory == '4x4' ||
                  selectedCategory == 'Minibus et Sprinter')
                ListTile(
                  title: Row(
                    children: [
                      Icon(Icons.type_specimen),
                      SizedBox(width: 10),
                      Text('Type'),
                      Spacer(),
                      Text(selectedType),
                    ],
                  ),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Types'),
                          content: Container(
                            height: 170,
                            width: double.maxFinite,
                            child: ListView(
                              children: [
                                for (var type in [
                                  'Interieur',
                                  'Exterieur',
                                  'Interieur et exterieur',
                                ])
                                  ListTile(
                                    title: Text(
                                      type,
                                      style: TextStyle(
                                        color: selectedType == type
                                            ? Colors.blue
                                            : Colors.black,
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        selectedType = type;
                                        setPrice(); // Appel de la fonction pour définir le prix
                                      });
                                      Navigator.of(context).pop();
                                    },
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
            ],
          ),
          Center(
            child: DelayedAnimation(
              delay: 5000,
              child: BlinkingCircle(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(bottom: 15),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          child: Container(
            height: 80,
            color: Color(0xE4EFEFEF), // Couleur rouge
            child: Center(
              child: Text.rich(
                TextSpan(
                  text: 'Temps : ',
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                      color: Colors.black54),
                  children: <TextSpan>[
                    TextSpan(
                      text: '$temp min',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.green),
                    ),
                    TextSpan(text: ' , '),
                    TextSpan(
                      text: 'Prix : ',
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                          color: Colors.black54),
                    ),
                    TextSpan(
                      text: '$price AR',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.green),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}