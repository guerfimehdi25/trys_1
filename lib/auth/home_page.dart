import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';
import 'package:trys_1/auth/Activity.dart';
import 'package:trys_1/auth/Menu.dart';
import 'package:trys_1/auth/resrvation.dart';




class Parkings extends StatefulWidget {
  const Parkings({super.key});

  @override
  State<Parkings> createState() => _ParkingState();
}

class _ParkingState extends State<Parkings> {
  int currentIndex = 0;




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: const Text('Where are you?'),
        // App bar title (replace with the actual title)
        backgroundColor: Colors.yellow, // Set the app bar color
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        elevation: 9,
        currentIndex: currentIndex,
        onTap: (currentIndex) {
          if (currentIndex == 0) {
            // Navigate to Parking page (replace Registre() with your actual page)
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Parkings()),
            );
          } else if (currentIndex == 1) {
            // Handle navigation for other items based on their index
            // ...
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Activity()),
            );
          } else if (currentIndex == 2) {
            // ... handle navigation for other items
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Reservation()),
            );
          } else if (currentIndex == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Menu()),
            );
          }
        },


        items: const [

          BottomNavigationBarItem(

            icon: Icon(
                Icons.directions_car),
            label: 'Parking',


          ),

          BottomNavigationBarItem(

            icon: Icon(
                Icons.home_filled),
            label: 'Activity',


          ),
          BottomNavigationBarItem(
            icon: Icon(
                Icons.event_available),
            label: 'Reservation',

          ),
          BottomNavigationBarItem(
            icon: Icon(
                Icons.menu),
            label: 'Menu',

          ),
        ],
      ),

      body:Column(
        children: [
          content() ,
          FlutterLocationPicker(
              initZoom: 11,
              minZoomLevel: 5,
              maxZoomLevel: 16,
              trackMyPosition: true,
              onPicked: (pickedData) {
              })],
      )








    );

    /* GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center ,
          zoom:11.0,
        ),

        )

      */


  }

  Widget content() {
    return FlutterMap(options: const MapOptions(
      initialCenter: LatLng(45.763689, 4.840364),
      initialZoom: 11,
      interactionOptions: InteractionOptions(
          flags: InteractiveFlag.doubleTapZoom),


    ),
      children: [
        openStreetMapTileLayer,
        const MarkerLayer(markers: [
          Marker(point: LatLng(45.763689, 4.840364),
              width: 60,
              height: 60,
              alignment: Alignment.centerLeft,
              child: Icon(Icons.location_pin, size: 30, color: Colors.red,))
        ])
      ],

    );

  }

  TileLayer get openStreetMapTileLayer =>
      TileLayer(
        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        userAgentPackageName: 'dev.fleatlet.flutter_map.example',
      );
}
