// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:radio_player/radio_player.dart';
import 'package:radio_test_player/controller/database.dart';
import 'package:radio_test_player/controller/preferences/user_preferences.dart';
import 'package:radio_test_player/src/pages/login/login_page.dart';

//todo REPRODUCTOR DE RADIO E INTERACCIÓN CON EL CHAT
class PlayRadio extends StatefulWidget {
  String name;
  PlayRadio({super.key, required this.name});

  @override
  State<PlayRadio> createState() => _PlayRadioState();
}

class _PlayRadioState extends State<PlayRadio> {
  final RadioPlayer _radioPlayer = RadioPlayer();
  bool isPlaying = false;

  late Timer timer;
  final db = FireBaseDB();

  ScrollController controller = ScrollController();
  double lastScrollPosition = 0;

  final txtMessage = TextEditingController();
  String nombreUser = '';
  String numeroCelular = '';
  String apellidoUser = '';

  final auth = FirebaseDatabase.instance;
  final ref = FirebaseDatabase.instance.ref('chat');
  bool visibility = true;

  bool downPage = false;
  bool loading = true;

  List<dynamic> listDataChat = [];

  //todo ASIGNA LOS COMPONENTES Y LA CONEXIÓN A LA EMISORA
  void initRadioPlayer() async {
    _radioPlayer.setChannel(
      title: 'Radio Player',
      url: 'http://stream-153.zeno.fm/rxce5k6u5i5vv?zs=bHmqfjptRNyQtI4GdZOO7w',
      imagePath: null,
    );

    _radioPlayer.stateStream.listen((value) {
      setState(() {
        isPlaying = value;
      });
    });
  }

  //todo INICIALIZAR EL ESTADO DE LA APLICACIÓN
  @override
  void initState() {
    super.initState();

    //todo Llamamos al método para que se pueda inicializar la libreria
    initRadioPlayer();

    //todo tiempo en milisegundos para darle tiempo a la inicialización
    Future.delayed(const Duration(milliseconds: 500)).then((_) {
      //todo Automáticamente le damos "reproducción" a la emisora
      _radioPlayer.play();

      setState(() => isPlaying = true);

      //todo OBTENEMOS LOS DATOS DEL USUARIO(EN CASO DE QUE ESTE LOGEADO)
      initPhoneNumber();

      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        //todo ACTUALIZACIÓN DEL SCROLL CADA SEGUNDO
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

  //todo ACTUALIZACIÓN DEL SCROLL CADA SEGUNDO
  void jumtoMaxScroll() {
    setState(() => downPage = false);
    controller.animateTo(controller.position.maxScrollExtent,
        duration: const Duration(seconds: 1), curve: Curves.fastOutSlowIn);
  }

  //todo OBTENEMOS LOS DATOS DEL USUARIO(EN CASO DE QUE ESTE LOGEADO)
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

  //todo ELIMINAMOS RECURSOS DE LA PÁGINA AL SALIR
  @override
  void dispose() {
    super.dispose();
    _radioPlayer.stop();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        setState(() => visibility = true);
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
                    width: MediaQuery.of(context).size.width * 1,
                    height: MediaQuery.of(context).size.height * 0.4,
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
                              height: MediaQuery.of(context).size.height * 0.09,
                              child: IconButton(
                                  onPressed: () {
                                    isPlaying
                                        ? _radioPlayer.pause()
                                        : _radioPlayer.play();
                                  },
                                  icon: Icon(
                                    isPlaying
                                        ? Icons.pause_circle_outline_outlined
                                        : Icons.play_circle_outline_outlined,
                                    size: 55,
                                    color: Colors.white,
                                  ))),
                        ),
                        Positioned(
                          top: 30,
                          left: 5,
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _radioPlayer.stop();
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
                              //todo FIREBASE ANIMATEDLIST
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
                                        //todo obtenemos el valor del login(true or false)
                                        await UserPreferences()
                                            .getLogin()
                                            .then((value) async {
                                          if (value!) {
                                            //todo eliminar mensaje seleccionado
                                            final result =
                                                await db.deleteMessageAdmin(
                                                    snapshot.key!, context);

                                            if (result == "si") {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      content: Text(
                                                          "Menesaje eliminado")));
                                            } else if (result == "no") {
                                              debugPrint("no es admin");
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
                                                  child: RichText(
                                                    text: TextSpan(
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 13),
                                                        children: [
                                                          TextSpan(
                                                              text:
                                                                  "${snapshot.child("nombre_usuario").value} ${snapshot.child("apellido_usuario").value ?? ""}: ",
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                          TextSpan(
                                                              text:
                                                                  "${snapshot.child("message").value}")
                                                        ]),
                                                  )),
                                              Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: SizedBox(
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
                                            color: const Color.fromRGBO(
                                                255, 255, 255, 70),
                                            borderRadius:
                                                BorderRadius.circular(100)),
                                        child: const Icon(Icons
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
                                  bool? enableLogin = snapshot.hasData;
                                  return GestureDetector(
                                    onTap: () async {
                                      if (!enableLogin!) {
                                        await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (builder) =>
                                                        const LoginPage()))
                                            .then((value) async {
                                          final data = await UserPreferences()
                                              .getLogin();

                                          if (data != null && data) {
                                            setState(() => enableLogin = true);
                                            final name = await UserPreferences()
                                                .getUsername();
                                            final phone =
                                                await UserPreferences()
                                                    .getCelular();

                                            final lastname =
                                                await UserPreferences()
                                                    .getUserLastname();

                                            setState(() {
                                              nombreUser = name!;
                                              numeroCelular = phone!;
                                              apellidoUser = lastname!;
                                            });
                                          }
                                        });
                                      }
                                    },
                                    child: TextField(
                                      textAlign: enableLogin
                                          ? TextAlign.start
                                          : TextAlign.center,
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      style:
                                          const TextStyle(color: Colors.white),
                                      controller: txtMessage,
                                      scrollPadding: EdgeInsets.zero,
                                      enabled: enableLogin,
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
                                              borderSide: const BorderSide(
                                                  color: Colors.grey)),
                                          contentPadding:
                                              const EdgeInsets.only(left: 15),
                                          suffixIcon: enableLogin
                                              ? IconButton(
                                                  onPressed: () async {
                                                    //todo INSERTAR MENSAJE
                                                    await db.insertMessage(
                                                        apellido: apellidoUser,
                                                        nombre: nombreUser,
                                                        celular: numeroCelular,
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
                                                                  duration:
                                                                      const Duration(
                                                                          seconds:
                                                                              1),
                                                                  curve: Curves
                                                                      .fastOutSlowIn,
                                                                )));
                                                  },
                                                  icon: Icon(
                                                    Icons.send,
                                                    color: enableLogin
                                                        ? Colors.white
                                                        : Colors.grey,
                                                    size: 25,
                                                  ),
                                                )
                                              : const SizedBox(
                                                  width: 0.0,
                                                  height: 0.0,
                                                ),
                                          hintStyle: TextStyle(
                                              color: enableLogin
                                                  ? Colors.white
                                                  : Colors.grey,
                                              fontSize: 13),
                                          hintText: enableLogin
                                              ? "Escriba su mensaje..."
                                              : "¿Quieres chatear? Inicia sesión aquí.",
                                          border: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.white),
                                              borderRadius:
                                                  BorderRadius.circular(100))),
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
    );
  }
}
