// ignore_for_file: non_constant_identifier_names

import 'package:bataao/theme/style.dart';
import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({super.key, required this.Title, required this.pages});

  final String Title;
  final Widget pages;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * .8,
      height: 50,
      child: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => pages));
          },
          style: ElevatedButton.styleFrom(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
                side: const BorderSide(color: Body),
              ),
              backgroundColor: Body),
          child: Text(
            Title,
          )),
    );
  }
}
