import 'package:flutter/material.dart';
import 'package:hebit_tracker_app/Provider/provider.dart';
import 'package:hebit_tracker_app/View/Splash.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=>ThemeProvider()),
      ],
          builder:(context,child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/':(context)=>SplashScreen(),
        },
      ),
    );
  }
}
