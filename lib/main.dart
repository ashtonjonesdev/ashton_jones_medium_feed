import 'package:ashton_jones_medium_feed/styles/theme.dart';
import 'package:ashton_jones_medium_feed/ui/screens/Home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ashton Jones Medium Feed',
      theme: AppTheme.appThemeDataLight,
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}


