import 'dart:convert';
import 'dart:ffi';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:radio_test_player/src/pages/radio/radio_play.dart';

class Programming extends StatefulWidget {
  const Programming({super.key});

  @override
  State<Programming> createState() => _ProgrammingState();
}

class _ProgrammingState extends State<Programming> {
  final ref = FirebaseDatabase.instance.ref('programacion');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(33, 29, 82, 1),
          title: const Text(
            "Programación",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.white)),
        ),
        backgroundColor: const Color.fromRGBO(33, 29, 82, 1),
        body: options());
  }

  Widget options() => FirebaseAnimatedList(
      query: ref,
      itemBuilder: (itemBuilder, snapshot, animation, index) {
        return Card(
          color: Colors.grey,
          child: Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(left: 15, right: 15),
              width: double.infinity,
              height: 65,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            snapshot.child("nombre").value.toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            "${snapshot.child("emision_corta").value.toString()} ${snapshot.child("hora_inicio").value.toString().replaceAll(":", "h")} - ${snapshot.child("hora_fin").value.toString().replaceAll(":", "h")}",
                            style: const TextStyle(fontSize: 10),
                          ),
                        )
                      ],
                    ),
                  ),
                  icon(snapshot)
                ],
              )),
        );
      });

  Widget icon(DataSnapshot snapshot) {
    final time = DateFormat("HH:mm").format(DateTime.now());
    List<dynamic> listMapDays = [];
    List<String> listDays = [];
    final nameDay = DateFormat("EEEE", "es").format(DateTime.now());

    debugPrint("nombre del día: $nameDay");

    final days = snapshot.child("emision");

    final ref = jsonEncode(days.value);

    listMapDays = jsonDecode(ref);

    for (var i = 0; i < listMapDays.length; i++) {
      listDays.add(listMapDays[i]);
    }

    int minutosInicio = convertirAHorasEnMinutos(
        snapshot.child("hora_inicio").value.toString());
    debugPrint("minutos inicio: $minutosInicio");

    int minutosFin =
        convertirAHorasEnMinutos(snapshot.child("hora_fin").value.toString());
    debugPrint("minutos fin: $minutosFin");

    int minutosSystem = convertirAHorasEnMinutos(time);
    debugPrint("minutos system: $minutosSystem");

    if (listDays.contains(nameDay)) {
      if (minutosSystem >= minutosInicio && minutosSystem <= minutosFin) {
        return IconButton(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (builder) => PlayRadio(name: "Radio Horizontes"))),
            icon: const Icon(
              Icons.play_arrow,
              color: Colors.black,
            ));
      } else {
        return const Icon(
          Icons.play_disabled,
          color: Colors.grey,
        );
      }
    } else {
      return const Icon(
        Icons.play_disabled,
        color: Colors.grey,
      );
    }
  }

  int convertirAHorasEnMinutos(String hora) {
    List<String> partes = hora.split(":");
    int horas = int.parse(partes[0]);
    int minutos = int.parse(partes[1]);
    return horas * 60 + minutos;
  }
}
