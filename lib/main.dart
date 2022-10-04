import 'package:flutter/material.dart';
import 'package:passport_university_for_unsa/screens/main_screen.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<InitializationStatus> _initGoogleMobileAds() {
    // TODO: Initialize Google Mobile Ads SDK
    return MobileAds.instance.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: MainScreen(),
    );
  }
}
