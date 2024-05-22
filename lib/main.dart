
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:trys_1/auth/Menu.dart';
import 'package:trys_1/auth/list_Park.dart';
import 'package:trys_1/auth/login_screen.dart';
import 'package:trys_1/auth/osm.dart';
import 'package:trys_1/auth/park.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';



void main() async{

// ...

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

  ParkingModel({
    required this.name,
    required this.distance,
    required this.emptySpaces,
  });
}
//class MyApp
//Stateless
//Stateful

class MyApp extends StatefulWidget {



  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  List <QueryDocumentSnapshot>  data=[] ;
  getData() async
  {
    QuerySnapshot querySnapshot=  await FirebaseFirestore.instance.collection("_parkingsCollection").get();
    data.addAll(querySnapshot.docs);
    setState(() {

    });
  }
  @override
  void initState() {
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    final String parkingName = 'Tony Garnier'; // Example parking name
    final double parkingDistance = 2.5; // Example distance
    final int parkingEmptySpaces = 10; // Example empty spaces
    final String parkingLocationUrl = 'https://example.com';
    return   MaterialApp(
      debugShowCheckedModeBanner: false,
      home:Menu(),


      //Text
    );
  }
}


