import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trys_1/auth/Menu.dart';
import 'package:trys_1/auth/osm.dart';
import 'package:trys_1/auth/reservation.dart';
import 'package:trys_1/auth/resrvation.dart';

class Activity extends StatefulWidget {
  final String name;

  const Activity({
    super.key,
    required this.name,
  });

  @override
  State<Activity> createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
  DocumentSnapshot? userData; // Store user data

  @override
  void initState() {
    super.initState();
  }

  int currentIndex = 1;

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
        MaterialPageRoute(builder: (context) => Activity(name: widget.name)),
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
        title: const Text(
          'Activity',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black),
        ),
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Reservation for Parking: '),
                Text(
                  widget.name,
                  style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
