// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_radio_player/flutter_radio_player.dart';
import 'package:flutter_radio_player/models/frp_source_modal.dart';
import 'package:radio_test_player/controller/database.dart';
import 'package:radio_test_player/controller/preferences/user_preferences.dart';
import 'package:radio_test_player/src/pages/login/login_page.dart';
import 'package:radio_test_player/src/pages/radio/test.dart';
import 'package:radio_test_player/src/pages/radio_package/frp_player.dart';

class PlayRadio extends StatefulWidget {
  String name;
  PlayRadio({super.key, required this.name});

  @override
  State<PlayRadio> createState() => _PlayRadioState();
}

class _PlayRadioState extends State<PlayRadio> {
  late Timer timer;
  final db = FireBaseDB();

  ScrollController controller = ScrollController();
  double lastScrollPosition = 0;

  final txtMessage = TextEditingController();
  String nombreUser = '';
  String numeroCelular = '';

  final auth = FirebaseDatabase.instance;
  final ref = FirebaseDatabase.instance.ref('chat');
  bool visibility = true;

  bool downPage = false;
  bool loading = true;

  int chatLeng = 0;

  List<dynamic> listDataChat = [];

  final DatabaseReference _chatRef = FirebaseDatabase.instance.ref("chat");

  Future<void> _getChatDataCount() async {
    DataSnapshot snapshot = await _chatRef.get();

    setState(() => chatLeng = snapshot.children.length);
  }

  final FlutterRadioPlayer _flutterRadioPlayer = FlutterRadioPlayer();

  late FRPSource frpSource;

  @override
  void initState() {
    super.initState();

    frpSource = FRPSource(
      mediaSources: <MediaSources>[
        MediaSources(
          url:
              "http://stream-153.zeno.fm/rxce5k6u5i5vv?zs=bHmqfjptRNyQtI4GdZOO7w", // dummy url
          description: "Horizonte",
          isPrimary: true,
          title: "Tu radio favorita",
          isAac: true,
        ),
      ],
    );

    inicializarRadio();

    //todo tiempo en milisegundos para darle tiempo a la inicialización
    Future.delayed(const Duration(milliseconds: 500)).then((_) {
      initPhoneNumber();
      _getChatDataCount();
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        debugPrint("contador: reproduciendose");
        jumtoMaxScroll();
      });

      controller.addListener(() {
        double currentPosition = controller.position.pixels;

        if (currentPosition < lastScrollPosition) {
          setState(() => downPage = true);
          if (timer.isActive) {
            timer.cancel();
          }
        } else {
          if (!timer.isActive) {
            timer = Timer.periodic(const Duration(seconds: 1), (timer) {
              debugPrint("contador: reproduciendose");
              jumtoMaxScroll();
            });
          }
        }

        lastScrollPosition = currentPosition;
      });
      setState(() => loading = false);
    });
  }

  void inicializarRadio() async {
    //todo inicializar radio
    await _flutterRadioPlayer.initPlayer();

    Future.delayed(const Duration(milliseconds: 500));

    //todo asignar recursos a la radio
    await _flutterRadioPlayer.addMediaSources(frpSource);
  }

  void jumtoMaxScroll() {
    setState(() => downPage = false);
    controller.animateTo(controller.position.maxScrollExtent,
        duration: const Duration(seconds: 1), curve: Curves.fastOutSlowIn);
  }

  void initPhoneNumber() async {
    final data = await UserPreferences().getCelular();
    final data2 = await UserPreferences().getUsername();

    if (data != null) {
      setState(() => numeroCelular = data);
    }
    if (data2 != null) {
      setState(() => nombreUser = data2);
    }
  }

  @override
  void dispose() {
    super.dispose();
    detenerRadio();
    timer.cancel();
  }

  void detenerRadio() async {
    await _flutterRadioPlayer.stop();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          setState(() => visibility = true);
          if (!visibility) _flutterRadioPlayer.addMediaSources(frpSource);
        },
        child: Scaffold(
          backgroundColor: const Color.fromRGBO(33, 29, 82, 1),
          body: Stack(
            children: [
              Column(
                children: [
                  Visibility(
                    visible: visibility,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 100,
                      height: 340,
                      child: Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 10, right: 10),
                            width: MediaQuery.of(context).size.width * 1,
                            child: Image.asset("assets/horizontes.png"),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              margin:
                                  const EdgeInsets.only(left: 10, right: 10),
                              width: MediaQuery.of(context).size.width * 1,
                              height: 120,
                              child: FRPlayer(
                                flutterRadioPlayer: _flutterRadioPlayer,
                                frpSource: frpSource,
                                useIcyData: true,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 30,
                            left: 5,
                            child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                                _flutterRadioPlayer.stop();
                              },
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 0.5),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 5, right: 5),
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.white,
                      child: Column(
                        children: [
                          if (!visibility)
                            Container(
                              height: 40,
                              color: const Color.fromRGBO(33, 29, 82, 1),
                            ),
                          if (!visibility)
                            Container(
                              color: const Color.fromRGBO(33, 29, 82, 1),
                              padding: const EdgeInsets.only(right: 10),
                              width: double.infinity,
                              alignment: Alignment.centerRight,
                              child: const Icon(
                                Icons.close_fullscreen_sharp,
                                color: Colors.white,
                              ),
                            ),
                          Expanded(
                              child: Container(
                            color: const Color.fromRGBO(33, 29, 82, 1),
                            child: Stack(
                              children: [
                                FirebaseAnimatedList(
                                    defaultChild: const Center(
                                        child: CircularProgressIndicator()),
                                    shrinkWrap: true,
                                    controller: controller,
                                    query: ref,
                                    itemBuilder: (itemBuilder, snapshot,
                                        animation, index) {
                                      return GestureDetector(
                                        onTap: () async {
                                          await UserPreferences()
                                              .getLogin()
                                              .then((value) async {
                                            if (value!) {
                                              final result =
                                                  await db.deleteMessageAdmin(
                                                      snapshot.key!, context);

                                              if (result == "si") {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(const SnackBar(
                                                        content: Text(
                                                            "Menesaje eliminado")));
                                              } else if (result == "no") {
                                                print("no es admin");
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content: Text(result)));
                                              }
                                            }
                                          });
                                        },
                                        child: ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          title: Container(
                                            width: double.infinity,
                                            alignment: Alignment.centerLeft,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    "${snapshot.child("nombre_usuario").value}: ${snapshot.child("message").value}",
                                                    style: TextStyle(
                                                        color: snapshot
                                                                    .child(
                                                                        "id_usuario")
                                                                    .value
                                                                    .toString() ==
                                                                numeroCelular
                                                            ? Colors.white
                                                            : Colors.grey,
                                                        fontSize: 13),
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Container(
                                                    width: 63,
                                                    child: Text(
                                                      "${snapshot.child("time").value.toString()} | ${snapshot.child("date").value.toString().split("-")[1]}/${snapshot.child("date").value.toString().split("-")[2]}",
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 7),
                                                    ),
                                                  ),
                                                ),
                                                Divider(
                                                  height: 10,
                                                  thickness: 0.5,
                                                  color: Colors.grey.shade700,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                if (downPage)
                                  Positioned(
                                      right: 5,
                                      bottom: 10,
                                      child: GestureDetector(
                                        onTap: () => jumtoMaxScroll(),
                                        child: Container(
                                          width: 30,
                                          height: 30,
                                          decoration: BoxDecoration(
                                              color: Color.fromRGBO(
                                                  255, 255, 255, 70),
                                              borderRadius:
                                                  BorderRadius.circular(100)),
                                          child: Icon(Icons
                                              .keyboard_double_arrow_down_rounded),
                                        ),
                                      ))
                              ],
                            ),
                          )),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              color: const Color.fromRGBO(33, 29, 82, 1),
                              padding: const EdgeInsets.only(left: 5, right: 5),
                              child: FutureBuilder(
                                  future: UserPreferences().getLogin(),
                                  builder:
                                      (context, AsyncSnapshot<bool?> snapshot) {
                                    bool? enable = snapshot.hasData;
                                    return GestureDetector(
                                      onTap: () async {
                                        if (!enable!) {
                                          await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (builder) =>
                                                          const LoginPage()))
                                              .then((value) async {
                                            _flutterRadioPlayer
                                                .addMediaSources(frpSource);
                                            final data = await UserPreferences()
                                                .getLogin();

                                            if (data != null && data) {
                                              setState(() => enable = true);
                                              final name =
                                                  await UserPreferences()
                                                      .getUsername();
                                              final phone =
                                                  await UserPreferences()
                                                      .getCelular();

                                              setState(() {
                                                nombreUser = name!;
                                                numeroCelular = phone!;
                                              });
                                            }
                                          });
                                        }
                                      },
                                      child: TextField(
                                        textAlign: enable
                                            ? TextAlign.start
                                            : TextAlign.center,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        style: const TextStyle(
                                            color: Colors.white),
                                        controller: txtMessage,
                                        scrollPadding: EdgeInsets.zero,
                                        enabled: enable,
                                        onTap: () {
                                          setState(() => visibility = false);
                                          setState(() => controller.animateTo(
                                                controller
                                                    .position.maxScrollExtent,
                                                duration:
                                                    const Duration(seconds: 1),
                                                curve: Curves.fastOutSlowIn,
                                              ));
                                        },
                                        decoration: InputDecoration(
                                            disabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                borderSide: BorderSide(
                                                    color: Colors.grey)),
                                            contentPadding:
                                                const EdgeInsets.only(left: 15),
                                            suffixIcon: enable
                                                ? IconButton(
                                                    onPressed: () async {
                                                      await db.insertMessage(
                                                          nombre: nombreUser,
                                                          celular:
                                                              numeroCelular,
                                                          message:
                                                              txtMessage.text);

                                                      setState(() =>
                                                          txtMessage.clear());

                                                      Future.delayed(
                                                              const Duration(
                                                                  milliseconds:
                                                                      200))
                                                          .then((value) =>
                                                              setState(() =>
                                                                  controller
                                                                      .animateTo(
                                                                    controller
                                                                        .position
                                                                        .maxScrollExtent,
                                                                    duration: const Duration(
                                                                        seconds:
                                                                            1),
                                                                    curve: Curves
                                                                        .fastOutSlowIn,
                                                                  )));
                                                    },
                                                    icon: Icon(
                                                      Icons.send,
                                                      color: enable
                                                          ? Colors.white
                                                          : Colors.grey,
                                                      size: 25,
                                                    ),
                                                  )
                                                : Container(
                                                    width: 0.0,
                                                    height: 0.0,
                                                  ),
                                            hintStyle: TextStyle(
                                                color: enable
                                                    ? Colors.white
                                                    : Colors.grey,
                                                fontSize: 13),
                                            hintText: enable
                                                ? "Escriba su mensaje..."
                                                : "¿Quieres chatear? Inicia sesión aquí.",
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.white),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        100))),
                                      ),
                                    );
                                  }),
                            ),
                          ),
                          Container(
                              color: const Color.fromRGBO(33, 29, 82, 1),
                              height: 5)
                        ],
                      ),
                    ),
                  )
                ],
              ),
              if (loading)
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: const Color.fromRGBO(0, 0, 0, 80),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                      backgroundColor: Colors.grey,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
