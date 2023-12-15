import 'package:flutter/material.dart';

class CoberturaPage extends StatefulWidget {
  const CoberturaPage({super.key});

  @override
  State<CoberturaPage> createState() => _CoberturaPageState();
}

class _CoberturaPageState extends State<CoberturaPage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(33, 29, 82, 1),
          title: const Text(
            "Cobertura",
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.white)),
        ),
        backgroundColor: const Color.fromRGBO(33, 29, 82, 1),
        body: Image.asset("assets/cobertura_radio.png"));
  }
}