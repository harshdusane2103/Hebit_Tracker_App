import 'dart:async';

import 'package:flutter/material.dart';
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 3),(){
      Navigator.of(context).pushReplacementNamed('/home');
    });
    double h=MediaQuery.of(context).size.height;
    double w=MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Container(
          height: h*0.30,
          width: w*0.50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            
            image: DecorationImage
              (
              fit: BoxFit.cover,
              image: AssetImage('assets/image/logo.png'),
            )
          ),
        ),
      ),
    );
  }
}
