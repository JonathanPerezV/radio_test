// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:radio_test_player/controller/database.dart';
import 'package:radio_test_player/controller/preferences/user_preferences.dart';
import 'package:radio_test_player/src/pages/login/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final txtPhone = TextEditingController();
  final txtPass = TextEditingController();

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
            "Inicio de sesión",
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
              child: Column(
                children: [
                  Center(
                    child: Container(
                      width: 315,
                      child: Image.asset("assets/horizontes.png"),
                    ),
                  ),
                  const SizedBox(height: 50),
                  Container(
                    margin: const EdgeInsets.only(left: 25, right: 25),
                    child: TextFormField(
                      controller: txtPhone,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Campo obligatorio *";
                        } else {
                          return null;
                        }
                      },
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.number,
                      inputFormatters: [LengthLimitingTextInputFormatter(10)],
                      decoration: const InputDecoration(
                          labelStyle:
                              TextStyle(color: Colors.white, fontSize: 12),
                          labelText: "Teléfono celular",
                          hintText: "Escriba número de teléfono...",
                          hintStyle:
                              TextStyle(color: Colors.white, fontSize: 12),
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
                      controller: txtPass,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Campo obligatorio *";
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                          suffix: IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                setState(() => obscure = !obscure);
                              },
                              icon: Icon(
                                !obscure
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: Colors.white,
                              )),
                          labelStyle: const TextStyle(
                              color: Colors.white, fontSize: 12),
                          labelText: "Contraseña",
                          hintText: "************",
                          hintStyle: const TextStyle(
                              color: Colors.white, fontSize: 12),
                          contentPadding: const EdgeInsets.only(
                            left: 10,
                          ),
                          border: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white))),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                          style: const ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.yellow)),
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) => const RegisterPage())),
                          child: const Text(
                            "Registrarme",
                            style: TextStyle(color: Colors.black),
                          )),
                      TextButton(
                          style: const ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.yellow)),
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              final bytes = utf8.encode(txtPass.text);
                              var newPassword = md5.convert(bytes).toString();

                              setState(() => loading = true);

                              final data = await db.authUser(
                                  phone: txtPhone.text, password: newPassword);

                              if (data == "ok") {
                                await pfrc.saveLogin(true);
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (builder) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25)),
                                        title: Text(
                                          "Error de autenticación",
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        content: Text(data),
                                        actions: [
                                          TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Text("Regresar"))
                                        ],
                                      );
                                    });
                              }

                              print("resultado: $data");

                              setState(() => loading = false);
                            } else {
                              return;
                            }
                          },
                          child: const Text(
                            "Iniciar sesión",
                            style: TextStyle(color: Colors.black),
                          ))
                    ],
                  )
                ],
              ),
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
}
