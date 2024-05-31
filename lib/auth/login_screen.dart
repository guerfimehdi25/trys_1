import 'package:flutter/services.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:trys_1/auth/osm.dart';
import 'package:trys_1/auth/registre_Screen.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({super.key});

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final String _message = '';
  bool _obscureText = true;
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  final _formKey = GlobalKey<FormState>();
  late Database database;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isLoggedIn = prefs.getBool('isLoggedIn');
    if (isLoggedIn == true) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const OSM(),
        ),
      );
    }
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _email.text.trim(),
          password: _password.text.trim(),
        );

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const OSM(),
          ),
        );
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        if (e.code == 'user-not-found') {
          errorMessage = 'No user found for that email.';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'Wrong password provided for that user.';
        } else {
          errorMessage = 'An error occurred. Please try again.';
        }

        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.rightSlide,
          title: 'Error',
          desc: errorMessage,
          btnOkOnPress: () {},
        ).show();
      } catch (e) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.rightSlide,
          title: 'Error',
          desc: 'An unexpected error occurred. Please try again.',
          btnOkOnPress: () {},
        ).show();
      }
    } else {
      String errorMessage;
      if (_email.text.isEmpty) {
        errorMessage = 'Please enter your email.';
      } else if (_password.text.isEmpty) {
        errorMessage = 'Please enter your password.';
      } else {
        errorMessage = 'Please fill in all fields.';
      }

      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'Error',
        desc: errorMessage,
        btnOkOnPress: () {},
      ).show();
    }
  }

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
    const pattern = r"(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}";
    final regex = RegExp(pattern);

    if (value == null || value.isEmpty || !regex.hasMatch(value) || value.length < 7) {
      return '8 Characters, 1 Upper Letter, 1 Lower Letter, 1 Digit';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [],
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Center(
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 40.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(80.0),
                        child: const Image(
                          image: AssetImage('assets/images/logo.png'),
                          width: 100.0,
                          height: 150.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    TextFormField(
                      validator: validateEmail,
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(50),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Email Address',
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      validator: validatePassword,
                      controller: _password,
                      obscureText: _obscureText,
                      keyboardType: TextInputType.visiblePassword,
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
                    InkWell(
                      onTap: () async {
                        if (_email.text.isEmpty) {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            animType: AnimType.rightSlide,
                            title: 'Error',
                            desc: 'First enter your email!',
                            btnOkOnPress: () {},
                          ).show();
                          return;
                        }
                        await FirebaseAuth.instance.sendPasswordResetEmail(email: _email.text);
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.success,
                          animType: AnimType.rightSlide,
                          title: 'Email Sent Successfully',
                          desc: 'Check your email. We have sent a link to reset your password.',
                          btnOkOnPress: () {},
                        ).show();
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 10, bottom: 20),
                        alignment: Alignment.topRight,
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 60.0,
                      child: InkWell(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          onPressed: _login,
                          child: const Text(
                            'Login',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Don\'t have an account?'),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Registre(),
                              ),
                            );
                          },
                          child: const Text(
                            'Register Now',
                            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
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
}
