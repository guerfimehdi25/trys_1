import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trys_1/auth/Activity.dart';
import 'package:url_launcher/url_launcher.dart';

class ParkingListPage extends StatefulWidget {
  const ParkingListPage({super.key});

  @override
  _ParkingListPageState createState() => _ParkingListPageState();
}
class Parking {

  final String id;

  final String name;

  final double distance;

  final int emptySpaces;

  final String locationUrl;




  Parking({

    required this.id,

    required this.name,

    required this.distance,

    required this.emptySpaces,

    required this.locationUrl,



  });

}
class _ParkingListPageState extends State<ParkingListPage> {

  final CollectionReference _parkingsCollection =
  FirebaseFirestore.instance.collection('parkings');
  Future<void> _launchUrl(String url) async {

    if (await canLaunchUrl(Uri.parse(url))) {

      await launchUrl(Uri.parse(url));

    } else {

      throw 'Could not launch $url';

    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parkings à proximité'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _parkingsCollection.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return const CircularProgressIndicator();
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              final parking = Parking(
                id: document.id,
                name: document['name'],
                distance: document['distance'],
                emptySpaces: document['emptySpaces'],
                locationUrl: document['locationUrl'],

              );
              return ListTile(
                title: Text(parking.name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Distance: ${parking.distance} km'),
                    Text('Empty spaces: ${parking.emptySpaces}'),
                    TextButton(
                      onPressed: () {
                        _launchUrl(parking.locationUrl);
                      },
                      child: const Text('Location'),
                    ),
                  ],
                ),

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Activity(name: '',),
                    ),
                  );
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}