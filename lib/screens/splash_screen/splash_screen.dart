import 'package:bataao/api/apis.dart';
import 'package:bataao/screens/welcome_screen/welcome_screen.dart';
import 'package:bataao/theme/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../main_screen/main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 350), () {
      // exit Full screen
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.white,
          statusBarColor: Colors.transparent));
      // Checking if User in Already Loged In
      if (APIs.auth.currentUser != null) {
        // Get Current User Data from google ...
        debugPrint('\nUser : ${APIs.auth.currentUser}');
        // Redirect Home page if user in Current user ...
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const MainScreen()));
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const WelcomeScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Expanded(
          child: Container(
            decoration: const BoxDecoration(gradient: BG_Gradient),
            child: const Center(
                child: SizedBox(
              width: 150,
              height: 150,
              child: Image(image: AssetImage("assets/logos/logo.png")),
            )),
          ),
        ),
      ),
    );
  }
}
