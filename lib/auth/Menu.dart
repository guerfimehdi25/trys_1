import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trys_1/auth/login_screen.dart';

import 'Activity.dart';
import 'list_Park.dart';
import 'osm.dart';
import 'resrvation.dart'; // Import the ParkingPage

class Menu extends StatefulWidget {
  const Menu({super.key});

  get name => "enter name of parking!";

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
  void logout() async {
    // Clear the user's login status
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');

    // Perform the logout action, for example, if you're using Firebase Authentication:
    FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => loginScreen()));



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
        MaterialPageRoute(builder: (context) => const OSM()),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Activity(name: '', hour: 0,)),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Reservation(name: widget.name)),
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
        actions: [
          IconButton(
            onPressed:()
            {

              logout();

            },
            icon: Icon(Icons.logout),
          ),
        ],
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
            icon: Icon(Icons.location_on),
            label: 'Map',
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
          const Padding(
            padding: EdgeInsets.all(8.0),
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

                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  mainAxisExtent: 160,
                ),
                itemBuilder: (context, i) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0), // Add rounded corners
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(10),
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
                                        distance: data[i]['distance'].toDouble(),
                                        emptySpaces: data[i]['emptySpaces'],
                                        locationUrl: data[i]['locationUrl'],
                                        imageUrl: data[i]['imageUrl'],
                                      ),
                                    ),
                                  );
                                },
                                child: Text(data[i]['name']),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const Text('Distance: '),
                              Text(data[i]['distance'].toString()),
                              const Text(' km'),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const Text('Number of empty Spaces: '),
                              Text(data[i]['emptySpaces'].toString()),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const Text('Location: '),
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
                                  style: const TextStyle(
                                    color: Colors.lightBlue,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Clipboard.setData(ClipboardData(text: data[i]['locationUrl']));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Location copied to clipboard')),
                                  );
                                },
                                child: const Row(
                                  children: [
                                    Text('copy ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                                    Icon(Icons.content_copy),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
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