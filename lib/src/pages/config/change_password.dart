// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:radio_test_player/controller/database.dart';
import 'package:radio_test_player/controller/preferences/user_preferences.dart';
import 'package:radio_test_player/src/pages/login/register_page.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final txtCurrentPass = TextEditingController();
  final txtNewPass = TextEditingController();
  final txtRepPass = TextEditingController();

  final formKey = GlobalKey<FormState>();
  bool obscure = true;

  bool loading = false;

  final pfrc = UserPreferences();

  final db = FireBaseDB();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(33, 29, 82, 1),
        appBar: AppBar(
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.white)),
          backgroundColor: const Color.fromRGBO(33, 29, 82, 1),
          title: const Text(
            "Cambiar contraseña",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: options(),
      ),
    );
  }

  Widget options() => Stack(
        children: [
          SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(children: [
                Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      width: 315,
                      child: Image.asset("assets/horizontes.png"),
                    ),
                    Positioned(
                        bottom: -15,
                        right: MediaQuery.of(context).size.width * 0.37,
                        child: IconButton(
                          color: Colors.white,
                          icon: Icon(!obscure
                              ? Icons.visibility_off_rounded
                              : Icons.remove_red_eye),
                          onPressed: () {
                            setState(() {
                              obscure = !obscure;
                            });
                          },
                        )),
                  ],
                ),
                const SizedBox(height: 25),
                Container(
                  margin: const EdgeInsets.only(left: 25, right: 25),
                  child: TextFormField(
                    controller: txtCurrentPass,
                    obscureText: obscure,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Campo obligatorio *";
                      } else {
                        return null;
                      }
                    },
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                        labelStyle:
                            TextStyle(color: Colors.white, fontSize: 12),
                        labelText: "Contraseña actual",
                        hintText: "Escriba su contraseña...",
                        hintStyle: TextStyle(color: Colors.white, fontSize: 12),
                        contentPadding: EdgeInsets.only(left: 10),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white))),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.only(left: 25, right: 25),
                  child: TextFormField(
                    textAlignVertical: TextAlignVertical.top,
                    obscureText: obscure,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                    textInputAction: TextInputAction.done,
                    controller: txtNewPass,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Campo obligatorio *";
                      } else {
                        return null;
                      }
                    },
                    decoration: const InputDecoration(
                        labelStyle:
                            TextStyle(color: Colors.white, fontSize: 12),
                        labelText: "Contraseña nueva",
                        hintText: "Escriba su contraseña nueva",
                        hintStyle: TextStyle(color: Colors.white, fontSize: 12),
                        contentPadding: EdgeInsets.only(
                          left: 10,
                        ),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white))),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.only(left: 25, right: 25),
                  child: TextFormField(
                    textAlignVertical: TextAlignVertical.top,
                    obscureText: obscure,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                    textInputAction: TextInputAction.done,
                    controller: txtRepPass,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Campo obligatorio *";
                      } else {
                        if (value == txtNewPass.text) {
                          return null;
                        } else {
                          return "La contraseña no coincide";
                        }
                      }
                    },
                    decoration: const InputDecoration(
                        labelStyle:
                            TextStyle(color: Colors.white, fontSize: 12),
                        labelText: "Repetir contraseña",
                        hintText: "Escriba su contraseña nueva",
                        hintStyle: TextStyle(color: Colors.white, fontSize: 12),
                        contentPadding: EdgeInsets.only(
                          left: 10,
                        ),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white))),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                    style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.yellow)),
                    onPressed: () async => validarAct(),
                    child: const Text(
                      "Cambiar contraseña",
                      style: TextStyle(color: Colors.black),
                    ))
              ]),
            ),
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
      );

  Future<void> validarAct() async {
    if (formKey.currentState!.validate()) {
      setState(() => loading = true);
      final data = await db.validateUserPass(txtCurrentPass.text);

      if (data == "ok") {
        await db.updateUserPass(txtRepPass.text);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Contraseña actualizada correctamente"),
          duration: Duration(seconds: 2),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(data),
          duration: const Duration(seconds: 1),
        ));
      }
      setState(() => loading = false);
    } else {
      return;
    }
  }
}
