import 'dart:convert';
import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import 'package:trys_1/auth/Activity.dart';
import 'package:trys_1/auth/Menu.dart';
import 'package:trys_1/auth/osm.dart';

class Payment {
  final int id;
  final bool check;

  Payment({required this.id, required this.check});

  // Convert a Payment object into a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'check': check,
    };
  }

  // Convert a map into a Payment object
  factory Payment.fromMap(Map<String, dynamic> map) {
    return Payment(
      id: map['id'],
      check: map['check'],
    );
  }
}

class Reservation extends StatefulWidget {
  final String name;

  const Reservation({
    super.key,
    required this.name,
  });

  @override
  State<Reservation> createState() => _ReservationState();
}

class _ReservationState extends State<Reservation> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscureText = true;
  int currentIndex = 2;
  late String documentId;
  bool isLoggedIn = false;

  void updateId(BuildContext context) async {
    // Generate a random number
    int randomId = Random().nextInt(1000000); // Generates a random number between 0 and 999999

    try {
      // Update Firestore document
      await FirebaseFirestore.instance
          .collection('users')
          .doc(documentId)
          .update({'id': randomId});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Updated document with ID: $randomId')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating document: $e')),
      );
    }
  }

  Future<Payment> getPaymentData() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(documentId)
        .get();

    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    return Payment.fromMap(data);
  }

  Future<void> checkAndAddHourIfNotExists() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('users').doc(documentId).get();

    if (!snapshot.exists) {
      throw Exception('Document does not exist');
    }

    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    if (!data.containsKey('hour')) {
      await FirebaseFirestore.instance.collection('users').doc(documentId).update({'hour': 0});
    }
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
        MaterialPageRoute(builder: (context) => const Activity(name: '', hour: 0)),
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

  Future<void> login(BuildContext context) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('Email', isEqualTo: _email.text)
          .where('password', isEqualTo: _password.text)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        documentId = querySnapshot.docs.first.id;
        setState(() {
          isLoggedIn = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login successful!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email or password is incorrect')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error logging in: $e')),
      );
    }
  }

  void sendTokenToServer(String token) async {
    var response = await http.post(
      Uri.parse('https://book.stripe.com/test_fZe9EEa0n2fo9AAcMN'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'token': token}),
    );

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response,
      // then parse the JSON.
      print('Payment successful');
    } else {
      // If the server returns an unsuccessful response code,
      // then throw an exception.
      throw Exception('Failed to make payment');
    }
  }

  @override
  Widget build(BuildContext context) {
    String? validateEmail(String? value) {
      const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
          r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
          r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
          r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
          r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
          r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
          r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
      final regex = RegExp(pattern);


      return value!.isNotEmpty && !regex.hasMatch(value) ? 'Enter a valid email address' : null;
    }

    String? validatePassword(String? value) {
      const patternn = r"(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}";
      final regex = RegExp(patternn);

      if (value == null || value.isEmpty || !regex.hasMatch(value) || value.length < 7) {
        return '8Characters,1Upper Letter,1Lower Letter,1Digit';
      }

      return null;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text('Reservation', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black)),
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
            const SizedBox(
              height: 5,
            ),
            const Text(
              'First to Reserve go to Page Menu and choose your Parking !!',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 5,
            ),
            Form(
              autovalidateMode: AutovalidateMode.always,
              child: TextFormField(
                validator: validateEmail,
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                inputFormatters: [LengthLimitingTextInputFormatter(50)],
                onFieldSubmitted: (String value) {
                  print(value);
                },
                onChanged: (String value) {
                  print(value);
                },
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Form(
              autovalidateMode: AutovalidateMode.always,
              child: TextFormField(
                validator: validatePassword,
                controller: _password,
                obscureText: _obscureText,
                keyboardType: TextInputType.visiblePassword,
                inputFormatters: const [],
                onFieldSubmitted: (String value) {
                  print(value);
                },
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                      color: Theme.of(context).primaryColorDark,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                login(context);

                if (widget.name == "enter name of parking!") {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.error,
                    animType: AnimType.rightSlide,
                    title: 'choose your Parking',
                    desc: 'First you must choose your parking from Menu',
                    btnOkOnPress: () {},
                  ).show();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Text('Login', style: TextStyle(fontSize: 20)),
            ),
            if (isLoggedIn && widget.name != "enter name of parking!")
              FutureBuilder<Payment>(
                future: getPaymentData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData) {
                    return const Center(child: Text('No data found'));
                  }

                  Payment payment = snapshot.data!;

                  return Center(
                    child: Column(
                      children: [
                        Text('Current ID: ${payment.id}'),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            updateId(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: const Text(
                            'update',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () async {
                            try {
                              await checkAndAddHourIfNotExists();

                              const String url = 'https://book.stripe.com/test_fZe9EEa0n2fo9AAcMN';
                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                throw 'Could not launch $url';
                              }

                              DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(documentId)
                                  .get();
                              int hour = documentSnapshot.get('hour');

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Activity(name: widget.name, hour: hour),
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error: $e')),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: const Text(
                            'Reserve',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
