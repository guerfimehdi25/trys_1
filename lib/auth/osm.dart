import 'package:flutter/material.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';
import 'package:trys_1/auth/Activity.dart';
import 'package:trys_1/auth/Menu.dart';
import 'package:trys_1/auth/resrvation.dart';
import 'package:location/location.dart';

class OSM extends StatefulWidget {


  final String locationUrl;

  const OSM({super.key,  this.locationUrl =""});

  @override
  State<OSM> createState() => _OSMState();
}

class _OSMState extends State<OSM> {
  String locationaddress ='Pick location';

  Location location = Location();



  int currentIndex = 0;
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
        MaterialPageRoute(builder: (context) => const Activity()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Reservation()),
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
    return  Scaffold(
      appBar: AppBar(

        title: const Text('Maps',style:TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color:Colors.black)),
        // App bar title (replace with the actual title)
        backgroundColor: Colors.amber, // Set the app bar color
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

      body:Center(
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: OpenStreetMapSearchAndPick(

            buttonTextStyle: const TextStyle(fontSize: 18, fontStyle: FontStyle.normal),
            buttonColor: Colors.blue,
            buttonText: 'Set Current Location',
            onPicked: (pickedData) {
              print(pickedData.latLong.latitude);
              print(pickedData.latLong.longitude);
              print(pickedData.address);
              print(pickedData.addressName);
            },
          ),
        ),
      ) ,


    );




  }
}


