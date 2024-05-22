import 'package:flutter/material.dart';
import 'package:trys_1/auth/Activity.dart';
import 'package:trys_1/auth/Menu.dart';
import 'package:trys_1/auth/osm.dart';
import 'package:trys_1/auth/resrvation.dart';

class ParkingPage extends StatefulWidget {
  final String name;
  final double distance;
  final int emptySpaces;
  final String locationUrl;

  const ParkingPage({
    required this.name,
    required this.distance,
    required this.emptySpaces,
    required this.locationUrl,
  });

  @override
  _ParkingPageState createState() => _ParkingPageState();
}

class _ParkingPageState extends State<ParkingPage> {
  @override
  void initState() {
    super.initState();
  }

  int currentIndex = 3;
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
        title: Text('Parking Details'),
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 430,
                child: Image(
                  image: AssetImage('assets/images/park.jpg'),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Text('Failed to load image');
                  },
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Reserve'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber, // Set the background color of the button
                      foregroundColor: Colors.black, // Set the text color of the button
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0), // Set the border radius of the button
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Column(
                    children: [
                      Text('${widget.name}',style: TextStyle(fontWeight: FontWeight.bold,fontSize:20),),
                      Text('Distance: ${widget.distance.toStringAsFixed(2)} km'),
                      Text('Empty Spaces: ${widget.emptySpaces}'),
                    ],
                  )

                ],
              )

            ],
          ),
        ),
      ),
    );
  }
}
