import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:trys_1/auth/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

  class Registre extends StatefulWidget {
  const Registre({super.key});


  @override
  State<Registre> createState() => _RegistreState();
}

class _RegistreState extends State<Registre> {
  final  _password = TextEditingController();
  final  _email = TextEditingController();
  final FirstName=TextEditingController();
  final LastName=TextEditingController();
  final PhoneNumber=TextEditingController();

  final VehiculeRegistractionNumber=TextEditingController();
  final TypeOfVehicule =TextEditingController();
  final VehiculeBrand =TextEditingController();









  bool _obscureText = true;

  late Database database ;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

     // Credentials are valid


      Future<void> addUser() {
    // Call the user's CollectionReference to add a new user
    return users
        .add({
      'FirstName': FirstName.text, // John Doe
      'LastName':LastName.text, // Stokes and Sons
      'Email':_email.text ,
      'Phone Number':PhoneNumber.text ,
      'Vehicule registration number':VehiculeRegistractionNumber.text ,
      'Type of vehicule':TypeOfVehicule.text ,
      'Brand':VehiculeBrand.text ,
      'password':_password.text ,
      //
    })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  @override
  void initState()
  {

    super.initState();
    createDatabase();
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

      return value!.isNotEmpty && !regex.hasMatch(value)
          ? 'Enter a valid email address'
          : null;
    }

    String? validatepassword(String? value) {


      if (value == null || value.isEmpty ||value.length<7) {


        return '8Characters,1Upper Letter,1Lower Let,1Digit,1SpecialCharacter.';

      }

      return null;

    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor:Colors.amber,
        title: const Text('Register',style:TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color:Colors.black)),
       /* actions: [
        CloseButton(
          color: Colors.black,
          onPressed: () {

            Navigator.pop(context);

          },
        )
        ],

        */

      ),


        body: SingleChildScrollView(

            child: Container(

                padding: const EdgeInsets.all(16),

                child: Column(

                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [

                      const Text(

                        'First Name ',

                        style: TextStyle(

                          fontWeight: FontWeight.bold,

                          fontSize: 16,

                        ),

                      ),

                      TextField(
                        keyboardType: TextInputType.text,
                        controller: FirstName,

                        decoration: const InputDecoration(

                          hintText: 'Your First Name',
                          prefixIcon: Icon(Icons.person),

                        ),

                      ),


                      const SizedBox(height: 16),

                      const Text(

                        'Last Name ',

                        style: TextStyle(

                          fontWeight: FontWeight.bold,

                          fontSize: 16,

                        ),

                      ),

                      TextField(
                        keyboardType: TextInputType.text,
                        controller: LastName,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          hintText: 'Your Last Name',

                        ),

                      ),

                      const SizedBox(height: 16),

                      const Text(

                        'EMAIL ',

                        style: TextStyle(


                          fontWeight: FontWeight.bold,

                          fontSize: 16,

                        ),

                      ),

                      Form(
                        autovalidateMode: AutovalidateMode.always,

                        child: TextFormField(
                            validator: validateEmail,
                            controller: _email,
                            keyboardType: TextInputType.emailAddress,
                            inputFormatters: [

                              LengthLimitingTextInputFormatter(50),



                            ],



                            onFieldSubmitted: (String value) {
                              print(value);
                            },
                            onChanged: (String value) {
                              print(value);
                            },
                            decoration: const InputDecoration(
                              hintText: 'Email Address',
                              prefixIcon: Icon(Icons.email),

                            )
                        ),
                      ),
                      const SizedBox(height: 16),




                      const Text(

                        'PHONE Number',

                        style: TextStyle(

                          fontWeight: FontWeight.bold,

                          fontSize: 16,

                        ),

                      ),

                      TextField(
                        keyboardType: TextInputType.phone ,
                        controller: PhoneNumber,
                        inputFormatters: [

                          LengthLimitingTextInputFormatter(10),



                        ],

                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.phone),
                          hintText: 'Your Phone Number',

                        ),

                      ),

                      const SizedBox(height: 16),


                      const Text(

                        'Vehicule Registration Number ',

                        style: TextStyle(

                          fontWeight: FontWeight.bold,

                          fontSize: 16,

                        ),

                      ),

                      Form(
                        child: TextField(

                          keyboardType: TextInputType.number,

                          controller: VehiculeRegistractionNumber,
                          inputFormatters: [

                            LengthLimitingTextInputFormatter(10),



                          ],
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.directions_car),
                            hintText: 'Your Vehicle registration number ',

                          ),



                        ),
                      ),
                      const SizedBox(height: 16),


                      const Text(

                        ' Type of Your Vehicle ',

                        style: TextStyle(

                          fontWeight: FontWeight.bold,

                          fontSize: 16,

                        ),

                      ),

                      TextField(
                        keyboardType: TextInputType.text,
                        controller: TypeOfVehicule,
                        inputFormatters: [

                          LengthLimitingTextInputFormatter(15),



                        ],
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.directions_car),
                          hintText: 'Your type of vehicule : Car or Bus or ...',

                        ),

                      ),




                      const SizedBox(height: 20), const Text(

                        'Vehicle brand ',

                        style: TextStyle(

                          fontWeight: FontWeight.bold,

                          fontSize: 16,

                        ),

                      ),

                      TextField(
                        keyboardType: TextInputType.text,
                        controller: VehiculeBrand,
                        inputFormatters: [

                          LengthLimitingTextInputFormatter(25),



                        ],

                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.directions_car),
                          hintText: ' Your vehicle brand',

                        ),

                      ),
               const SizedBox(
                 height: 16,
               ) ,
                const Text(

                    'Password ',

                    style: TextStyle(

                      fontWeight: FontWeight.bold,

                      fontSize: 16,

                    ),
                ),

                       const SizedBox(height:15),
                      Form(
                        autovalidateMode: AutovalidateMode.always,
                        child: TextFormField(
                        validator: validatepassword,
                          controller: _password,
                            obscureText: _obscureText,
                            keyboardType: TextInputType.visiblePassword,

                            onFieldSubmitted: (String value) {
                              print(value);
                            },
                            onChanged: (String value) {
                              print(value);
                            },
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureText? Icons.visibility : Icons.visibility_off,
                                  color: Theme.of(context).primaryColorDark,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureText =!_obscureText;
                                  });
                                },
                              ),
                              border: const OutlineInputBorder(),
                            ),



                        ),
                      ),

                      const SizedBox( height: 20),



                 const SizedBox(height: 5),
                        Center(
                        child: TextButton(
                          onPressed: () async  {


                          if(_email.text == ''||_password==''||FirstName==''||LastName==''||PhoneNumber==''
                          ||VehiculeRegistractionNumber==''||VehiculeBrand==''||TypeOfVehicule=='') {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.error,
                              animType: AnimType.rightSlide,
                              title: 'Error ',
                              desc: 'there is an Empty field , please fill it out ',
                              btnOkOnPress: () {},
                            ).show();
                          }






                            else {
                            addUser() ;
                            Navigator.push(context,
                                MaterialPageRoute(
                                  builder: (context) => const Parkings(),
                                )
                            );
                          }

                          } ,






                          child:const Text(
                            'Create Account',style:TextStyle(color:Colors.blue,fontSize: 18,fontWeight: FontWeight.bold)
                          ),
                        ),

                        )

                    ]
                )

            )
        )

    );
  }
  void createDatabase()async
  {
    database =await openDatabase(
        'todom.db',
        version:1,
        onCreate: (database,version)
        {
          print('database created');
          database.execute('CREATE TABLE User (id INTEGER PRIMARY KEY,email TEXT NOT NULL,password TEXT NOT NULL,FirstName TEXT NOT NULL,LastName TEXT NOT NULL,PhoneNumber TEXT NOT NULL,Adress TEXT NOT NULL,VehiculeRegistractionNumber TEXT NOT NULL,PostalCode TEXT NOT NULL ) ').then((value)
          {
            print('table created');
          }).catchError((error){
            print('Error when Creating Table ${error.toString()}');
          });
        },
        onOpen: (database)
        {
          print('database opened');
        }
    );
  }
  void insertToDatabase()async
  {
    await database.transaction((txn) async
    {
      await txn.rawInsert('INSERT INTO User (email, password,FirstName,LastName,PhoneNumber,Adress,VehiculeRegistractionNumber,PostalCode) VALUES (?,?,?,?,?,?,?,?)',
          [_email.text, _password.text,FirstName.text,LastName.text,
            PhoneNumber.text,
            VehiculeRegistractionNumber.text])
          .then((value) {
        print('iserted successfully');
      }).catchError((error){
        print('Error when Inserting New Record ${error.toString()}');
      });

    });
  }
}



