import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:trys_1/auth/login_screen.dart';



class Splash extends StatefulWidget {

  const Splash({super.key});

  @override

  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override

  void initState()
  {
    super.initState();
    _navigatetohome();
  }
  _navigatetohome()async{
    await Future.delayed(const Duration(seconds: 4),() {}   );
    Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>const loginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,

      body:


      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SpinKitDoubleBounce(
              color: Colors.white,
              size: 80.0,
            ),
            SizedBox(height: 20.0),
            Image(
              image: AssetImage('assets/images/logo.png'),
              width: 200.0, // Set width in pixels
              height: 250.0, /// Replace with your image path
            ),

          ],
        ),
      ),








    );
  }
}
