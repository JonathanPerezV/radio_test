// En tu código Flutter (Dart)
// ignore_for_file: avoid_print, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:radio_test_player/controller/preferences/user_preferences.dart';
import 'package:radio_test_player/src/pages/config/change_password.dart';
import 'package:radio_test_player/src/pages/contact_us/contact_us.dart';
import 'package:radio_test_player/src/pages/prog/programming.dart';
import 'package:radio_test_player/src/pages/quienes_somos/quienes_somos.dart';
import 'package:radio_test_player/src/pages/radio/radio_play.dart';
import 'package:shared_preferences/shared_preferences.dart';

//todo PÁGINA CONTENEDORA DE LOS BOTONES
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
        onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (builder) => const Programming())),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          shadowColor: Colors.grey,
          //color: Color.fromRGBO(33, 29, 82, 1),
          elevation: 3,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.red),
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
        onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (builder) => const QuienesSomos())),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          shadowColor: Colors.grey,
          //color: Color.fromRGBO(33, 29, 82, 1),
          elevation: 3,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.green),
            child: const Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Quiénes somos",
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
        onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (builder) => const ContactUs())),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          shadowColor: Colors.grey,
          elevation: 3,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.blue.shade900),
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
                  return IconButton(
                      onPressed: () => showModal(),
                      icon: const Icon(
                        Icons.settings,
                        color: Colors.white,
                      ));
                } else {
                  return Container();
                }
              })
        ],
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () async => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) =>
                            PlayRadio(name: "Radio Horizontes")))
                .then((value) => setState(() {})),
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
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  showModal() {
    showModalBottomSheet(
        elevation: 10,
        barrierColor: const Color.fromRGBO(0, 0, 0, 50),
        backgroundColor: const Color.fromRGBO(33, 29, 82, 1),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25))),
        context: context,
        builder: (builder) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: 30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.settings, color: Colors.white),
                    const SizedBox(width: 10),
                    Text(
                      "Configuraciones".toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Divider(
                  color: Colors.white,
                  thickness: 0.5,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => const ChangePassword()));
                },
                child: const ListTile(
                  title: Row(
                    children: [
                      Icon(Icons.password, color: Colors.white),
                      SizedBox(width: 10),
                      Text(
                        "Cambiar contraseña",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Divider(
                  color: Colors.white,
                  thickness: 0.5,
                ),
              ),
              GestureDetector(
                onTap: () => showModalLogOut(),
                child: const ListTile(
                  title: Row(
                    children: [
                      Icon(Icons.logout, color: Colors.white),
                      SizedBox(width: 10),
                      Text(
                        "Cerrar sesión",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          );
        });
  }

  void showModalLogOut() {
    Navigator.pop(context);
    showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            title: const Text("Cerrar sesión"),
            content: const Text("¿Desea cerrar su sesión?"),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancelar")),
                  TextButton(
                      onPressed: () async {
                        final pfrc = await SharedPreferences.getInstance();
                        await pfrc.clear();
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Sesión terminada")));
                        setState(() {});
                      },
                      child: const Text("Cerrar sesión")),
                ],
              )
            ],
          );
        });
  }
}

/*
  const SizedBox(height: 5),
              )*/
