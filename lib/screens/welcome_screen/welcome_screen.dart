import 'package:bataao/screens/auth/login_screen.dart';
import 'package:bataao/widgets/button/auth_button.dart';
import 'package:flutter/material.dart';

import '../../theme/style.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: BG_Gradient,
          ),
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(top: 200),
                  child: SizedBox(
                      width: 200,
                      height: 200,
                      child:
                          Image.asset("assets/logos/logo_transparent.png")),
                ),
              ),
              Expanded(
                flex: 1,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        Text(
                          "We welcome you to Bataao",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: cTitle,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                        Column(
                          children: [
                            AuthButton(
                              Title: "Login / Ragister",
                              pages: LoginScreen(),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                        Text(
                          "By continuing, you agree to the Terms of Service and confirm that you have read our Privacy Policy.",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Sky_Blue, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
