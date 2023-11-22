// En tu código Flutter (Dart)
// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:radio_test_player/controller/preferences/user_preferences.dart';
import 'package:radio_test_player/src/pages/radio/radio_play.dart';

class RadioPage extends StatefulWidget {
  const RadioPage({super.key});

  @override
  State<RadioPage> createState() => _RadioPageState();
}

class _RadioPageState extends State<RadioPage> {
  late List<GestureDetector> cards;

  @override
  void initState() {
    super.initState();
    cards = [
      GestureDetector(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (builder) => PlayRadio(name: "Radio Horizontes"))),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          shadowColor: Colors.grey,
          //color: Color.fromRGBO(33, 29, 82, 1),
          elevation: 3,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.red
                /*gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.blueAccent,
                      Color.fromRGBO(33, 29, 82, 1)
                    ])*/
                ),
            child: const Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Programación",
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(width: 5),
                  Icon(
                    Icons.tv_rounded,
                    color: Colors.white,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      GestureDetector(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (builder) => PlayRadio(name: "Radio Horizontes"))),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          shadowColor: Colors.grey,
          //color: Color.fromRGBO(33, 29, 82, 1),
          elevation: 3,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.green
                /*gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.blueAccent,
                      Color.fromRGBO(33, 29, 82, 1)
                    ])*/
                ),
            child: const Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Quienes somos",
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(width: 5),
                  Icon(
                    Icons.group,
                    color: Colors.white,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      GestureDetector(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (builder) => PlayRadio(name: "Radio Horizontes"))),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          shadowColor: Colors.grey,
          //color: Color.fromRGBO(33, 29, 82, 1),
          elevation: 3,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.white
                /*gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.blueAccent,
                      Color.fromRGBO(33, 29, 82, 1)
                    ])*/
                ),
            child: const Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Cobertura",
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(width: 5),
                  Icon(
                    Icons.map,
                    color: Colors.black,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      GestureDetector(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (builder) => PlayRadio(name: "Radio Horizontes"))),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          shadowColor: Colors.grey,
          //color: Color.fromRGBO(33, 29, 82, 1),
          elevation: 3,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.blue.shade900
                /*gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.blueAccent,
                      Color.fromRGBO(33, 29, 82, 1)
                    ])*/
                ),
            child: const Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Contáctanos",
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(width: 5),
                  Icon(
                    Icons.phone,
                    color: Colors.white,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(33, 29, 82, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(33, 29, 82, 1),
        centerTitle: true,
        title: const Text(
          'Radio Horizontes',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          FutureBuilder<bool?>(
              future: UserPreferences().getLogin(),
              builder: (builder, snapshot) {
                if (snapshot.data != null && snapshot.data!) {
                  return const Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Icon(
                      Icons.settings,
                      color: Colors.white,
                    ),
                  );
                } else {
                  return Container();
                }
              })
        ],
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (builder) => PlayRadio(name: "Radio Horizontes"))),
            child: SizedBox(
              height: 150,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                shadowColor: Colors.grey,
                //color: Color.fromRGBO(33, 29, 82, 1),
                elevation: 5,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.yellow
                      /*gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.blueAccent,
                            Color.fromRGBO(33, 29, 82, 1)
                          ])*/
                      ),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    //tileColor: const Color.fromRGBO(33, 29, 82, 1),
                    title: const Center(
                        child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Escucha aquí",
                            style:
                                TextStyle(color: Colors.black, fontSize: 30)),
                        SizedBox(width: 10),
                        Icon(
                          Icons.headphones,
                          color: Colors.black,
                          size: 35,
                        )
                      ],
                    )),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              scrollDirection: Axis.vertical,
              itemCount: cards.length,
              itemBuilder: (context, index) {
                return SizedBox(
                    width: MediaQuery.of(context).size.width * 45,
                    child: cards[index]);
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/*
  const SizedBox(height: 5),
              )*/
