import 'dart:convert';
import 'dart:ffi';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:radio_test_player/controller/preferences/user_preferences.dart';

class FireBaseDB {
  final fireBaseApp = Firebase.app();
  final String _url = 'https://radio-db-2c0ea-default-rtdb.firebaseio.com/';

  Future<int> getLastUser() async {
    int value = 1;
    final rtdb =
        FirebaseDatabase.instanceFor(app: fireBaseApp, databaseURL: _url);

    final ref = await rtdb.ref("usuario").get();

    if (ref.exists) {
      final list = ref.children.last;

      value = int.parse(list.child("id_usuario").value!.toString());
    } else {
      print("No data");
    }

    return value;
  }

  Future<void> insertUser(
      {required String nombre,
      required String apellido,
      required String contrasena,
      required String telefono,
      required String correo}) async {
    final rtdb =
        FirebaseDatabase.instanceFor(app: fireBaseApp, databaseURL: _url);

    final ref = rtdb.ref("usuario/$telefono");

    final user = {
      "id_usuario": correo,
      "nombre": nombre,
      "apellido": apellido,
      "telefono": telefono,
      "contrasena": contrasena,
      "correo": correo
    };

    await ref.set(user);
  }

  Future<String> authUser(
      {required String password, required String phone}) async {
    final rtdb =
        FirebaseDatabase.instanceFor(app: fireBaseApp, databaseURL: _url);

    final ref = await rtdb.ref("usuario").child(phone).get();

    if (ref.exists) {
      final data = await rtdb.ref("usuario/$phone").child("contrasena").get();

      if (data.exists) {
        if (data.child("contrasena").value.toString() == password) {
          final dataName =
              await rtdb.ref("usuario/$phone").child("nombre").get();
          final dataPhone =
              await rtdb.ref("usuario/$phone").child("telefono").get();

          await UserPreferences()
              .saveUserName(dataName.child("nombre").value.toString());
          await UserPreferences()
              .saveCelular(dataPhone.child("telefono").value.toString());

          return "ok";
        } else {
          return "Contraseña incorrecta";
        }
      } else {
        return "Contraseña incorrecta";
      }
    } else {
      return "Celular incorrecto";
    }
  }

  //TODO CHAT

  Future<int> getLastChat() async {
    int value = 1;
    final rtdb =
        FirebaseDatabase.instanceFor(app: fireBaseApp, databaseURL: _url);

    final ref = await rtdb.ref("chat").get();

    if (ref.exists) {
      final list = ref.children.last;

      value = int.parse(list.child("id_chat").value!.toString());
    } else {
      print("No data");
    }

    return value;
  }

  Future<void> insertChat(
      {required String nombre,
      required String message,
      required String celular}) async {
    final rtdb =
        FirebaseDatabase.instanceFor(app: fireBaseApp, databaseURL: _url);

    final id = (await getLastChat()) + 1;

    final ref = rtdb.ref("chat/$id");

    final user = {
      "id_chat": id,
      "id_usuario": celular,
      "date": DateFormat("yyyy-MM-dd").format(DateTime.now()),
      "time": DateFormat("HH:mm").format(DateTime.now()),
      "nombre_usuario": nombre,
      "message": message
    };

    await ref.set(user);
  }

  Future<String> deleteMessageAdmin(String idMessage, context) async {
    final rtdb =
        FirebaseDatabase.instanceFor(app: fireBaseApp, databaseURL: _url);

    final phone = await UserPreferences().getCelular();

    final userRef = rtdb.ref("usuario");

    final phoneRef = await userRef.child("$phone").get();

    if (phoneRef.exists) {
      final chatRef = rtdb.ref("chat");

      final adminRef = await userRef.child("$phone/admin").get();

      if (adminRef.exists) {
        final messageRef = await chatRef.child(idMessage.toString()).get();

        if (messageRef.exists) {
          String eliminado = "no";
          await showDialog(
              context: context,
              builder: (builder) {
                return AlertDialog(
                  title: Text("Eliminar mensaje"),
                  content: Text("¿Desea eliminar este mensaje?"),
                  actions: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text("Cancelar")),
                        TextButton(
                            onPressed: () async {
                              await chatRef
                                  .child(idMessage.toString())
                                  .remove();
                              eliminado = "si";
                              Navigator.pop(context, eliminado);
                            },
                            child: Text("Eliminar"))
                      ],
                    )
                  ],
                );
              });

          return eliminado;
        } else {
          return "Error, intentelo más tarde";
        }
      } else {
        return "no";
      }
    } else {
      return "error";
    }
  }
}
