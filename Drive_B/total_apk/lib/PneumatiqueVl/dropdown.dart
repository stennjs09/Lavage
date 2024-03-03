import 'package:flutter/material.dart';
import 'package:total_apk/PneumatiqueVl/circle.dart';
import 'package:total_apk/Services/delayed_animation.dart';

class MyListViewVl extends StatefulWidget {
  @override
  _MyListViewStateVl createState() => _MyListViewStateVl();
}

String selectedCategoryVl = 'Moto';
String selectedTypeVl = 'Reparation';
int priceVl = 2000;
int tempVl = 15;

void sendDataToServer(BuildContext context) async {

}

class _MyListViewStateVl extends State<MyListViewVl> {
  void setPrice() {
    if (selectedCategoryVl == 'Moto') {
      setState(() {
        selectedTypeVl == 'Reparation' ? priceVl = 2000 : priceVl = 1000;
      });
    } else if (selectedCategoryVl == '13/14') {
      setState(() {
        selectedTypeVl == 'Reparation' ? priceVl = 3000 : priceVl = 1000;
      });
    } else if (selectedCategoryVl == '15/16') {
      setState(() {
        selectedTypeVl == 'Reparation' ? priceVl = 6000 : priceVl = 3000;
      });
    } else if (selectedCategoryVl == '17/18') {
      setState(() {
        selectedTypeVl == 'Reparation' ? priceVl = 8000 : priceVl = 4000;
      });
    } else if (selectedCategoryVl == '20') {
      setState(() {
        selectedTypeVl == 'Reparation' ? priceVl = 10000 : priceVl = 5000;
      });
    }

    selectedTypeVl == 'Reparation' ? tempVl = 15 : tempVl = 7;
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
                    Text(selectedCategoryVl),
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
                                'Moto',
                                '13/14',
                                '15/16',
                                '17/18',
                                '20',
                              ])
                                ListTile(
                                  title: Text(
                                    category,
                                    style: TextStyle(
                                      color: selectedCategoryVl == category
                                          ? Colors.blue
                                          : Colors.black,
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      selectedCategoryVl = category;
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
              ListTile(
                title: Row(
                  children: [
                    Icon(Icons.type_specimen),
                    SizedBox(width: 10),
                    Text('Type'),
                    Spacer(),
                    Text(selectedTypeVl),
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
                          height: 120,
                          width: double.maxFinite,
                          child: ListView(
                            children: [
                              for (var type in [
                                'Reparation',
                                'Permutation',
                              ])
                                ListTile(
                                  title: Text(
                                    type,
                                    style: TextStyle(
                                      color: selectedTypeVl == type
                                          ? Colors.blue
                                          : Colors.black,
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      selectedTypeVl = type;
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
              delay: 10,
              child: BlinkingCircleVl(),
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
                      text: '$tempVl min',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.red),
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
                      text: '$priceVl AR',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.red),
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
