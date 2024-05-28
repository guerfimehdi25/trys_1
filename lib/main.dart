// main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:trys_1/auth/Menu.dart';
import 'package:trys_1/auth/Splash.dart';
import 'package:trys_1/auth/osm.dart';
import 'package:trys_1/auth/resrvation.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class ParkingModel {
  final String name;
  final double distance;
  final int emptySpaces;
  final String locationUrl;
  final String imageUrl;

  ParkingModel({
    required this.name,
    required this.distance,
    required this.emptySpaces,
    required this.locationUrl,
    required this.imageUrl,
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<ParkingModel> data = [];

  Future<void> getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("_parkingsCollection").get();
    data = querySnapshot.docs.map((doc) {
      return ParkingModel(
        name: doc['name'],
        distance: doc['distance'],
        emptySpaces: doc['emptySpaces'],
        imageUrl: doc['imageUrl'],
        locationUrl: doc['locationUrl'],
      );
    }).toList();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    ParkingModel parking = data[0];

    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      /*home: ParkingPage(
        name: parking.name,
        distance: parking.distance,
        emptySpaces: parking.emptySpaces,
        locationUrl: parking.locationUrl,
        imageUrl: parking.imageUrl,
      ),

       */
      home:Reservation(),
    );
  }
}
