import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
class google_Map extends StatefulWidget {
  const google_Map({super.key});

  @override
  State createState() => _google_MapState();
}

class _google_MapState extends State {
  late GoogleMapController mapController ;
  final LatLng _center = const LatLng(45.759467, 4.836350) ;

  void _onMapCreated(GoogleMapController controller)
  {
    mapController = controller ;
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
        backgroundColor: Colors.yellow,
      ),
      body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition:  CameraPosition(target: _center ,
          zoom: 11.0)),
    );
  }
}
