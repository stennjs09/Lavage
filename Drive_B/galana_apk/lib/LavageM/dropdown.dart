import 'package:flutter/material.dart';
import 'package:galana_apk/LavageM/circle.dart';
import 'package:galana_apk/Services/delayed_animation.dart';

class MyListViewLM extends StatefulWidget {
  @override
  _MyListViewLMState createState() => _MyListViewLMState();
}

String selectedCategoryLM = 'Scooter';
String selectedTypeLM = 'Exterieur';
int priceLM = 4000;
int tempLavageM = 20;

void sendDataToServer(selectedCategory, selectedType, price, temp ) async {

}

class _MyListViewLMState extends State<MyListViewLM> {
  void setPrice() {
    if (selectedCategoryLM == 'Scooter') {
      setState(() {
        priceLM = 4000;
        tempLavageM = 20;
      });
    } else if (selectedCategoryLM == 'Cross') {
      setState(() {
        priceLM = 5000;
        tempLavageM = 20;
      });
    }
    if (selectedCategoryLM == 'Radiateur PM') {
      setState(() {
        priceLM = 5000;
        tempLavageM = 15;
      });
    } else if (selectedCategoryLM == 'Radiateur GM') {
      setState(() {
        priceLM = 10000;
        tempLavageM = 15;
      });
    } else if (selectedCategoryLM == 'Légère' && selectedTypeLM == 'Interieur') {
      setState(() {
        priceLM = 5000;
        tempLavageM = 1;
      });
    } else if (selectedCategoryLM == 'Légère' && selectedTypeLM == 'Exterieur') {
      setState(() {
        priceLM = 8000;
        tempLavageM = 30;
      });
    } else if (selectedCategoryLM == 'Légère' &&
        selectedTypeLM == 'Interieur et exterieur') {
      setState(() {
        priceLM = 13000;
        tempLavageM = 30;
      });
    } else if (selectedCategoryLM == '4x4' && selectedTypeLM == 'Interieur') {
      setState(() {
        priceLM = 6000;
        tempLavageM = 1;
      });
    } else if (selectedCategoryLM == '4x4' && selectedTypeLM == 'Exterieur') {
      setState(() {
        priceLM = 10000;
        tempLavageM = 60;
      });
    } else if (selectedCategoryLM == '4x4' &&
        selectedTypeLM == 'Interieur et exterieur') {
      setState(() {
        priceLM = 16000;
        tempLavageM = 60;
      });
    } else if (selectedCategoryLM == 'Minibus et Sprinter' &&
        selectedTypeLM == 'Interieur') {
      setState(() {
        priceLM = 7000;
        tempLavageM = 1;
      });
    } else if (selectedCategoryLM == 'Minibus et Sprinter' &&
        selectedTypeLM == 'Exterieur') {
      setState(() {
        priceLM = 13000;
        tempLavageM = 90;
      });
    } else if (selectedCategoryLM == 'Minibus et Sprinter' &&
        selectedTypeLM == 'Interieur et exterieur') {
      setState(() {
        priceLM = 20000;
        tempLavageM = 90;
      });
    } else if (selectedCategoryLM == 'Camionnette') {
      setState(() {
        priceLM = 40000;
        tempLavageM = 120;
      });
    } else if (selectedCategoryLM == 'Camion -5T') {
      setState(() {
        priceLM = 45000;
        tempLavageM = 150;
      });
    } else if (selectedCategoryLM == 'Camion +5T') {
      setState(() {
        priceLM = 85000;
        tempLavageM = 150;
      });
    } else if (selectedCategoryLM == 'Moteur 4C') {
      setState(() {
        priceLM = 10000;
        tempLavageM = 20;
      });
    } else if (selectedCategoryLM == 'Moteur 5C') {
      setState(() {
        priceLM = 15000;
        tempLavageM = 20;
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
                    Text(selectedCategoryLM),
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
                                      color: selectedCategoryLM == category
                                          ? Colors.blue
                                          : Colors.black,
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      selectedCategoryLM = category;
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
              if (selectedCategoryLM == 'Légère' ||
                  selectedCategoryLM == '4x4' ||
                  selectedCategoryLM == 'Minibus et Sprinter')
                ListTile(
                  title: Row(
                    children: [
                      Icon(Icons.type_specimen),
                      SizedBox(width: 10),
                      Text('Type'),
                      Spacer(),
                      Text(selectedTypeLM),
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
                                        color: selectedTypeLM == type
                                            ? Colors.blue
                                            : Colors.black,
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        selectedTypeLM = type;
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
              delay: 500,
              child: BlinkingCircleLM(),
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
                      text: '$tempLavageM min',
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
                      text: '$priceLM AR',
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