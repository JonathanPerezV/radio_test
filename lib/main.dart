import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:radio_test_player/firebase_options.dart';
import 'package:radio_test_player/src/pages/radio/radio_test.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', 'ES'),
        Locale('en', 'EN'),
      ],
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      routes: {"radio_player": (_) => const RadioPage()},
      initialRoute: "radio_player",
    );
  }
}


//todo DEVELOPER APP:
//todo Tec. Jonathan Pérez
//todo 0994911674
//todo jonathan.perez1999@hotmail.com