


import 'package:flutter/services.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:trys_1/auth/osm.dart';
import 'package:trys_1/auth/registre_Screen.dart';

//import 'package:awesome_dialog/awesome_dialog.dart';



 class   loginScreen extends StatefulWidget {
// 1.create Database
// 2.create tables
// 3.open database
// 4.insert to database
// 5. get from database
 // 6.update in database
// 7.delete from database


   const loginScreen({super.key});

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  final  _email = TextEditingController();

   final _password = TextEditingController();
  final String _message = '';
  bool _obscureText = true;
  GlobalKey<FormState> formState =GlobalKey<FormState>();
  final _formKey = GlobalKey<FormState>();



  late Database database ;

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

       const patternn = r"(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\><*~]).{8,}";

       final regex = RegExp(patternn);

       if (value == null || value.isEmpty || !regex.hasMatch(value)||value.length<7) {


         return '8Characters,1Upper Letter,1Lower Let,1Digit,1SpecialCharacter.';

       }

       return null;

     }
     return Scaffold(

       appBar: AppBar(
         actions: [
          CloseButton(
color: Colors.black,
            onPressed: () {

              Navigator.pop(context);

            },
          )
         ],
       ),
       /*floatingActionButton: FloatingActionButton(
         onPressed: ()
         {
         },
         child: Icon(Icons.directions_car),
       ), */

       body:

      // Image.asset("C:\Users\benz\Pictures\FB_IMG_1659222947976.jpg")



          Container(

           child:

               Padding(
                 padding: const EdgeInsets.all(20),
child:
                     Center(
                     child: SingleChildScrollView(
                       child: Form(
                         key: _formKey,
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           mainAxisAlignment:MainAxisAlignment.center,
                           children: [
                             const Center(
                               child: Text('Login', style: TextStyle(color:Colors.black,
                                   fontSize: 40.0, fontWeight: FontWeight.bold),
                               ),

                             ),
                             const SizedBox(
                               height: 10,
                             ),
                             Center(
                               child: ClipRRect(
                                 borderRadius: BorderRadius.circular(80.0),


                                 child: const Image(

                                   image: AssetImage('assets/images/logo.png'),
                                   width: 100.0, // Set width in pixels
                                   height: 150.0,
                                   /// Replace with your image path
                                 ),
                               ),
                             ),
                             const SizedBox(
                               height: 40,
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
                                     labelText: 'Email Address',
                                     prefixIcon: Icon(Icons.email),
                                     border: OutlineInputBorder(),
                                   )
                               ),
                             ),
                             const SizedBox(
                               height: 20,
                             ),
                             Form(
                               autovalidateMode: AutovalidateMode.always,
                               child: TextFormField(
                                   validator: validatepassword,
                                   controller: _password,
                                   obscureText: _obscureText,
                                   keyboardType: TextInputType.visiblePassword,

                                   inputFormatters: const [

                                    // FilteringTextInputFormatter.deny(RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\><*~]).{8,}/pre>')),

                                     //LengthLimitingTextInputFormatter(8),


                                   ],

                                   onFieldSubmitted: (String value) {
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
                                   )
                               ),
                             ),

                             InkWell(
                               onTap: ()async
                               {
                                 if(_email.text=="")
                                   {
                                     AwesomeDialog(
                                       context: context,
                                       dialogType: DialogType.error,
                                       animType: AnimType.rightSlide,
                                       title: 'Error ',
                                       desc: 'First enter your email ?!',
                                       btnOkOnPress: () {},
                                     ).show();
                                     return ;
                                   }

                                 await FirebaseAuth.instance.sendPasswordResetEmail(email:_email.text);
                                 AwesomeDialog(
                                   context: context,
                                   dialogType: DialogType.error,
                                   animType: AnimType.rightSlide,
                                   title: 'Error ',
                                   desc: 'check your email we have been sent link to reset your password',
                                   btnOkOnPress: () {},
                                 ).show();
                               },
                               child: Container(
                                 margin:const EdgeInsets.only(top:10,bottom: 20),
                                 alignment: Alignment.topRight,

                                   child:const Text(
                                     'Forgot Password? ',style:TextStyle(color:Colors.grey),
                                   ),

                               ),
                             ),


                             const SizedBox(
                               height: 20,
                             ),
                             Container(
                               width: double.infinity,

                               height: 60.0,
                               decoration: BoxDecoration(
                                 color: Colors.blue,
                                 borderRadius: BorderRadius.circular(10.0),


                               ),

                               child: InkWell(
                                 child: ElevatedButton(

                                   style: ElevatedButton.styleFrom(

                                     backgroundColor: Colors.amber, // Set the background color of the button

                                     foregroundColor: Colors.black, // Set the text color of the button

                                     shape: RoundedRectangleBorder(

                                       borderRadius: BorderRadius.circular(10.0), // Set the border radius of the button

                                     ),

                                   ),


                                   onPressed: () async
                                   {



                                     if (_formKey.currentState!.validate()) {
                                       try {
                                         final credential = await FirebaseAuth
                                             .instance
                                             .signInWithEmailAndPassword(
                                           email: _email.text.trim(),
                                           password: _password.text.trim(),
                                         );


                                         /*
                                       void _showMessage() {

                                         Timer(Duration(seconds: 5), () {

                                           setState(() {

                                             _message = '';

                                           });

                                         });

                                       }

                                        */
                                         /*  void _validateInputs() {
                                         if (_email.text == 'hh' && _password.text == 'password') {
                                           setState(() {
                                             _message = 'Login correct';
                                           });
                                           _showMessage();
                                         } else {
                                           setState(() {
                                             _message = 'Incorrect login';
                                           });
                                           _showMessage();
                                         }
                                       } */

                                         Navigator.push(context,
                                           MaterialPageRoute(
                                             builder: (context) =>  OSM(),
                                           ),
                                         );
                                       } on FirebaseAuthException {
                                         if (_email.text == "") {


                                           AwesomeDialog(
                                             context: context,
                                             dialogType: DialogType.error,
                                             animType: AnimType.rightSlide,
                                             title: 'Error ',
                                             desc: 'Please enter your email ',
                                             btnOkOnPress: () {},
                                           ).show();
                                         } else
                                         if (_password.text =='') {

                                           AwesomeDialog(
                                             context: context,
                                             dialogType: DialogType.error,
                                             animType: AnimType.rightSlide,
                                             title: 'Error',
                                             desc: 'please enter your password',
                                             btnOkOnPress: () {},
                                           ).show();
                                         }
                                       }
                                     }
                                     },






                                   child:  const Text(

                                     'Login',

                                     style: TextStyle(fontSize: 20),


                                   ),

                                 ),
                               ),

                             ),

                         const SizedBox(

                           height: 20,

                         ),
                             Row(
                               mainAxisAlignment:MainAxisAlignment.center,
                               children: [
                                 const Text('Don\'t have an account?'),

                                 TextButton(
                                   onPressed: () {
                                     Navigator.push(context,
                                       MaterialPageRoute(
                                         builder: (context) => const Registre(),
                                       ),
                                     );
                                   },


                                   child:const Text(
                                       'Register Now ',style:TextStyle(color:Colors.blue,fontWeight: FontWeight.bold),
                                   ),
                                 ),
                               ],
                             ),
                             const SizedBox(
                               height: 20,
                             ),

                             Center(child: Text(_message)),

                           ],
                         ),
                       ),





                       ),
                     ),

                 ),
                 ),


     );



   }

   void createDatabase()async
   {
     database =await openDatabase(
       'todo.db',
       version:1,
       onCreate: (database,version) 
       {
         print('database created');
         database.execute('CREATE TABLE Login (id INTEGER PRIMARY KEY,email TEXT NOT NULL,password TEXT NOT NULL ) ').then((value)
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
      await txn.rawInsert('INSERT INTO Login (email, password) VALUES (?,?)', [_email.text,_password.text])
          .then((value) {
        print('iserted successfully');
      }).catchError((error){
        print('Error when Inserting New Record ${error.toString()}');
      });

     });
   }
}


