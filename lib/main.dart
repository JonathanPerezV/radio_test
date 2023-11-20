import 'package:flutter/material.dart';
import 'package:radio_test_player/src/pages/radio_test.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
     routes: {
      "radio_player": (_) => RadioPage()
     },
     initialRoute: "radio_player",
    );
  }
}