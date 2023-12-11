// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:radio_test_player/controller/database.dart';
import 'package:radio_test_player/controller/preferences/user_preferences.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();

  //todo CONTROLADORES DEL TEXTO
  final txtName = TextEditingController();
  final txtApellido = TextEditingController();
  final txtPhone = TextEditingController();
  final txtMail = TextEditingController();
  final txtPass = TextEditingController();

  //todo instancia a la bd
  final db = FireBaseDB();
  final pfrc = UserPreferences();

  bool loading = false;
  bool obscure = true;

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
            "Registro de usuario",
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
                    child: SizedBox(
                      width: 250,
                      child: Image.asset("assets/horizontes.png"),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.only(left: 15, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.42,
                          child: TextFormField(
                            textCapitalization: TextCapitalization.words,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12),
                            textInputAction: TextInputAction.next,
                            controller: txtName,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Campo obligatorio *";
                              } else {
                                return null;
                              }
                            },
                            decoration: const InputDecoration(
                                labelStyle: TextStyle(
                                    color: Colors.white, fontSize: 12),
                                labelText: "Nombre",
                                hintText: "Primer nombre...",
                                hintStyle: TextStyle(
                                    color: Colors.white, fontSize: 12),
                                contentPadding: EdgeInsets.only(left: 10),
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white))),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.42,
                          //margin: const EdgeInsets.only(left: 25, right: 25),
                          child: TextFormField(
                            textCapitalization: TextCapitalization.words,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12),
                            textInputAction: TextInputAction.next,
                            controller: txtApellido,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Campo obligatorio *";
                              } else {
                                return null;
                              }
                            },
                            decoration: const InputDecoration(
                                labelStyle: TextStyle(
                                    color: Colors.white, fontSize: 12),
                                labelText: "Apellido",
                                hintText: "Primer apellido...",
                                hintStyle: TextStyle(
                                    color: Colors.white, fontSize: 12),
                                contentPadding: EdgeInsets.only(left: 10),
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white))),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.only(left: 15, right: 15),
                    child: TextFormField(
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      inputFormatters: [LengthLimitingTextInputFormatter(10)],
                      controller: txtPhone,
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
                          labelText: "Teléfono celular",
                          hintText: "Escriba su número de teléfono...",
                          hintStyle:
                              TextStyle(color: Colors.white, fontSize: 12),
                          contentPadding: EdgeInsets.only(left: 10),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white))),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.only(left: 15, right: 15),
                    child: TextFormField(
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      controller: txtMail,
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
                          labelText: "Correo electrónico",
                          hintText: "Escriba su correo electrónico...",
                          hintStyle:
                              TextStyle(color: Colors.white, fontSize: 12),
                          contentPadding: EdgeInsets.only(left: 10),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white))),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.only(left: 15, right: 15),
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
                  TextButton(
                      style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.yellow)),
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          //todo Codifico la contraseña por medio de MD5
                          final bytes = utf8.encode(txtPass.text);
                          var newPassword = md5.convert(bytes).toString();

                          setState(() => loading = true);

                          //todo INSERTAR USUARIO EN LA BD
                          await db.insertUser(
                              apellido: txtApellido.text,
                              nombre: txtName.text,
                              correo: txtMail.text,
                              telefono: txtPhone.text,
                              contrasena: newPassword);

                          await pfrc.saveCelular(txtPhone.text);
                          await pfrc.saveMail(txtMail.text);
                          await pfrc.saveUserName(txtName.text);

                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text(
                                  "Usuario creado correctamente. Inicie sesión para continuar")));

                          Navigator.pop(context);

                          setState(() => loading = false);
                        } else {
                          return;
                        }
                      },
                      child: const Text(
                        "Registrarme",
                        style: TextStyle(color: Colors.black),
                      ))
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
