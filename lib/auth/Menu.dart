import 'package:flutter/material.dart';
import 'package:trys_1/auth/Activity.dart';
import 'package:trys_1/auth/list_Park.dart';
import 'package:trys_1/auth/osm.dart';
import 'package:trys_1/auth/resrvation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
 // Make sure to import ParkingPage

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  List<QueryDocumentSnapshot> data = [];

  getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("_parkingsCollection").get();
    data.addAll(querySnapshot.docs);
    setState(() {});
  }

  int currentIndex = 3;

  @override
  void initState() {
    getData();
    super.initState();
  }

  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OSM()),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Activity()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Reservation()),
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Menu()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text('Menu', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black)),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        elevation: 9,
        currentIndex: currentIndex,
        onTap: onTabTapped,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: 'Parking',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Activity',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_available),
            label: 'Reservation',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Menu',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'List of Parkings',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                itemCount: data.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 160,
                ),
                itemBuilder: (context, i) {
                  return Card(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ParkingPage(
                                        name: data[i]['name'],
                                        distance: data[i]['distance'],
                                        emptySpaces: data[i]['emptySpaces'],
                                        locationUrl: data[i]['locationUrl'],
                                      ),
                                    ),
                                  );
                                },
                                child: Text(data[i]['name']),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Text('Distance: '),
                              Text(data[i]['distance'].toString()),
                              Text(' km'),
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Text('Number of empty Spaces: '),
                              Text(data[i]['emptySpaces'].toString()),
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Text('Location: '),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => OSM(
                                        locationUrl: data[i]['locationUrl'],
                                      ),
                                    ),
                                  );
                                },
                                child: Text(
                                  data[i]['locationUrl'],
                                  style: TextStyle(
                                    color: Colors.lightBlue,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Clipboard.setData(ClipboardData(text: data[i]['locationUrl']));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Location copied to clipboard')),
                                  );
                                },
                                child: Row(
                                  children: [
                                    Text('copy ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                                    Icon(Icons.content_copy),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
