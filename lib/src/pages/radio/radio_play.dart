import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_radio_player/flutter_radio_player.dart';
import 'package:flutter_radio_player/models/frp_source_modal.dart';
import 'package:radio_test_player/controller/database.dart';
import 'package:radio_test_player/controller/preferences/user_preferences.dart';
import 'package:radio_test_player/src/pages/login/login_page.dart';
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

  final txtMessage = TextEditingController();

  final auth = FirebaseDatabase.instance;
  final ref = FirebaseDatabase.instance.ref('chat');
  bool visibility = true;

  final FlutterRadioPlayer _flutterRadioPlayer = FlutterRadioPlayer();

  final FRPSource frpSource = FRPSource(
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

  @override
  void initState() {
    super.initState();
    _flutterRadioPlayer.initPlayer();
    _flutterRadioPlayer.addMediaSources(frpSource);
    _flutterRadioPlayer.play();

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() => controller.animateTo(
            controller.position.maxScrollExtent,
            duration: const Duration(seconds: 1),
            curve: Curves.fastOutSlowIn,
          ));
    });
  }

  @override
  void dispose() {
    super.dispose();
    _flutterRadioPlayer.stop();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          setState(() => visibility = true);
          _flutterRadioPlayer.addMediaSources(frpSource);
        },
        child: Scaffold(
          backgroundColor: const Color.fromRGBO(33, 29, 82, 1),
          body: Column(
            children: [
              Visibility(
                visible: visibility,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 100,
                  height: 340,
                  child: Stack(
                    children: [
                      Image.asset("assets/horizontes.png"),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                          height: 120,
                          child: FRPlayer(
                            flutterRadioPlayer: _flutterRadioPlayer,
                            frpSource: frpSource,
                            useIcyData: false,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 30,
                        left: 5,
                        child: IconButton(
                          onPressed: () => Navigator.pop(context),
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
                        child: FirebaseAnimatedList(
                            defaultChild: const Center(
                                child: CircularProgressIndicator()),
                            shrinkWrap: true,
                            controller: controller,
                            query: ref,
                            itemBuilder:
                                (itemBuilderm, snapshot, animation, index) {
                              return GestureDetector(
                                onLongPress: () async {},
                                child: ListTile(
                                  title: Container(
                                    width: double.infinity,
                                    alignment: Alignment.centerLeft,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "${snapshot.child("nombre_usuario").value}: ${snapshot.child("message").value}",
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 13),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Container(
                                            width: 25,
                                            child: Text(
                                              snapshot
                                                  .child("time")
                                                  .value
                                                  .toString(),
                                              style: TextStyle(
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
                                bool enable = snapshot.hasData;

                                return GestureDetector(
                                  onTap: () async {
                                    if (!enable) {
                                      await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (builder) =>
                                                  LoginPage())).then((value) =>
                                          _flutterRadioPlayer
                                              .addMediaSources(frpSource));
                                    }
                                  },
                                  child: TextField(
                                    style: TextStyle(color: Colors.white),
                                    controller: txtMessage,
                                    scrollPadding: EdgeInsets.zero,
                                    enabled: enable,
                                    onTap: () {
                                      setState(() => visibility = false);
                                      setState(() => controller.animateTo(
                                            controller.position.maxScrollExtent,
                                            duration:
                                                const Duration(seconds: 1),
                                            curve: Curves.fastOutSlowIn,
                                          ));
                                    },
                                    decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.only(left: 15),
                                        suffixIcon: IconButton(
                                          onPressed: () async {
                                            if (txtMessage.text.isEmpty) {
                                              showDialog(
                                                  context: context,
                                                  builder: (builder) {
                                                    return AlertDialog(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          25)),
                                                      title:
                                                          Text("Campo vacío"),
                                                      content: Text(
                                                          "El campo no puede enviarse vacío."),
                                                      actions: [
                                                        TextButton(
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                    context),
                                                            child: Text("Ok"))
                                                      ],
                                                    );
                                                  });
                                            } else {
                                              await db.insertChat(
                                                  nombre: "Jonathan",
                                                  idUsuario: 1,
                                                  message: txtMessage.text);

                                              setState(
                                                  () => txtMessage.clear());

                                              Future.delayed(const Duration(
                                                      milliseconds: 200))
                                                  .then((value) => setState(
                                                      () =>
                                                          controller.animateTo(
                                                            controller.position
                                                                .maxScrollExtent,
                                                            duration:
                                                                const Duration(
                                                                    seconds: 1),
                                                            curve: Curves
                                                                .fastOutSlowIn,
                                                          )));
                                            }
                                          },
                                          icon: Icon(
                                            Icons.send,
                                            color: enable
                                                ? Colors.white
                                                : Colors.grey,
                                            size: 25,
                                          ),
                                        ),
                                        hintStyle: TextStyle(
                                            color: enable
                                                ? Colors.white
                                                : Colors.grey,
                                            fontSize: 13),
                                        hintText: "Escriba su mensaje...",
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(100))),
                                  ),
                                );
                              }),
                        ),
                      ),
                      Container(
                          color: const Color.fromRGBO(33, 29, 82, 1), height: 5)
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
