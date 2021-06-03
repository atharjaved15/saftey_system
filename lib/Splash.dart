import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';

import 'getStarted.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(
        duration: 3000,
        splash: Image.asset('images/logo.png', fit: BoxFit.cover, height: 200,),
        nextScreen: getStarted() ,
        splashTransition: SplashTransition.slideTransition,
      ),
    );
  }
}
