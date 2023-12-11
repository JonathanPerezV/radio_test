import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:radio_test_player/controller/preferences/user_preferences.dart';

class FireBaseDB {
  final fireBaseApp = Firebase.app();
  final String _url = 'https://radio-db-2c0ea-default-rtdb.firebaseio.com/';

  //todo deshuso
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

  //todo Registrar un nuevo usuario a la base de datos
  Future<void> insertUser(
      {required String nombre,
      required String apellido,
      required String contrasena,
      required String telefono,
      required String correo}) async {

    //todo INSTANCIA A LA BD   
    final rtdb =
        FirebaseDatabase.instanceFor(app: fireBaseApp, databaseURL: _url);
      
    //todo SE CREA LA REFERENCIA CON EL NUEVO NÚMERO DE TELÉFONOS
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

  //todo Autenticar al usuario para poder tener acceso al chat y configuración
  Future<String> authUser(
      {required String password, required String phone}) async {

    //todo INSTANCIA A LA BD
    final rtdb =
        FirebaseDatabase.instanceFor(app: fireBaseApp, databaseURL: _url);

    //todo OBTENER LOS DATOS POR MEDIO DE ESE NUMERO
    final ref = await rtdb.ref("usuario").child(phone).get();

    //todo VALIDAR QUE ESTE REGISTRO EXISTA
    if (ref.exists) {

      //todo de este nodo que si existe obtenemos la contraseña
      final data = await rtdb.ref("usuario/$phone").child("contrasena").get();

      if (data.exists) {

        //todo COMPARAMOS CONTRASEÑAS
        if (data.child("contrasena").value.toString() == password) {
          //todo OBTENER DATOS DE USUARIO
          final dataName =
              await rtdb.ref("usuario/$phone").child("nombre").get();

          final dataLastName =
              await rtdb.ref("usuario/$phone").child("apellido").get();

          final dataPhone =
              await rtdb.ref("usuario/$phone").child("telefono").get();

          //todo GUARDAR DATOS DE USUARIO EN LAS PREFERENCIAS
          await UserPreferences()
              .saveUserName(dataName.child("nombre").value.toString());
          await UserPreferences()
              .saveCelular(dataPhone.child("telefono").value.toString());
          await UserPreferences().saveUserLastName(
              dataLastName.child("apellido").value.toString());

          debugPrint(
              "Apellido: ${dataLastName.child("apellido").value.toString()}");

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

  //todo Obtener último mensaje para poder asignar un id al siguiente
  Future<int> getLastChat() async {
    int value = 0;
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

  //todo Ingresar un nuevo mensaje a la base de datos
  Future<void> insertMessage(
      {required String nombre,
      required String message,
      required String celular,
      required String apellido}) async {
    
    //todo Instancia a la bd
    final rtdb =
        FirebaseDatabase.instanceFor(app: fireBaseApp, databaseURL: _url);

    //todo obtencion y asignación del id del chat
    final id = (await getLastChat()) + 1;

    //todo crear referecia al chat
    final ref = rtdb.ref("chat/$id");

    final chat = {
      "id_chat": id,
      "id_usuario": celular,
      "date": DateFormat("yyyy-MM-dd").format(DateTime.now()),
      "time": DateFormat("HH:mm").format(DateTime.now()),
      "nombre_usuario": nombre,
      "apellido_usuario": apellido,
      "message": message
    };

    await ref.set(chat);
  }

  //todo Eliminar mensaje de la base de datos, solo administradores
  Future<String> deleteMessageAdmin(String idMessage, context) async {
    final rtdb =
        FirebaseDatabase.instanceFor(app: fireBaseApp, databaseURL: _url);

    //todo obtener el celular del usuario
    final phone = await UserPreferences().getCelular();

    //todo asigno la referencia del nodo usuario
    final userRef = rtdb.ref("usuario");

    //todo obtener la data por medio de la clave primaria(celular) del usuario.
    final phoneRef = await userRef.child("$phone").get();

    //todo valido si el usuario existe
    if (phoneRef.exists) {

      //todo realizo una referencia al nodo chat
      final chatRef = rtdb.ref("chat");

      //todo ver si este usuario tiene la bandera de Administrador(t o f)
      final adminRef = await userRef.child("$phone/admin").get();

      //todo valido que este usuario tenga la bandera
      if (adminRef.exists) {

        //todo obtengo el mensaje a eliminar 
        final messageRef = await chatRef.child(idMessage.toString()).get();

        //todo valido que este mensaje exista
        if (messageRef.exists) {
          String eliminado = "no";
          await showDialog(
              context: context,
              builder: (builder) {
                return AlertDialog(
                  title: const Text("Eliminar mensaje"),
                  content: const Text("¿Desea eliminar este mensaje?"),
                  actions: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Cancelar")),
                        TextButton(
                            onPressed: () async {
                              await chatRef
                                  .child(idMessage.toString())
                                  .remove();
                              eliminado = "si";
                              Navigator.pop(context, eliminado);
                            },
                            child: const Text("Eliminar"))
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
