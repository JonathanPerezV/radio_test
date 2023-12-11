import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  //todo GUARDAR NOMBRE DEL USUARIO PARA PRESENTAR EN LA APLICACION
  Future<void> saveUserName(String name) async {
    final pfrc = await SharedPreferences.getInstance();

    await pfrc.setString("name", name);
  }

  Future<String?> getUsername() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    return preferences.getString("name");
  }

  //todo GUARDAR APELLIDO DEL USUARIO PARA PRESENTAR EN LA APLICACION
  Future<void> saveUserLastName(String lastname) async{
      final pfrc = await SharedPreferences.getInstance();

      await pfrc.setString("lastname", lastname);
  }

  Future<String?> getUserLastname() async {
      final pfrc = await SharedPreferences.getInstance();

      return pfrc.getString("lastname");
  }

  //todo GUARDAR CORREO DEL USUARIO PARA PRESENTAR EN LA APLICACION(OPCIONAL)
  Future<void> saveMail(mail) async {
    final pfrc = await SharedPreferences.getInstance();

    await pfrc.setString("mail", mail);
  }

  Future<String?> getMail() async {
    final pfrc = await SharedPreferences.getInstance();
    return pfrc.getString("mail");
  }

  //todo CLAVE PRIMARIA DEL USUARIO, PARA REALIZAR ALGUNA ACTUALIZACIÓN DE SUS DATOS COMO LA CONTRASEÑA
  Future<void> saveCelular(String celular) async {
    final pfrc = await SharedPreferences.getInstance();
    await pfrc.setString("celular", celular);
  }

  Future<String?> getCelular() async {
    final pfrc = await SharedPreferences.getInstance();
    return pfrc.getString("celular");
  }

  //todo PARA VALIDAR SI EL USUARIO INICIO SESIÓN Y A TRAVES DE ELLO PERMITIRLE ACCEDER A CIERTAS FUNCIONES DE LA APP
  Future<void> saveLogin(bool login) async {
    final pfrc = await SharedPreferences.getInstance();
    await pfrc.setBool("login", login);
  }

  Future<bool?> getLogin() async {
    final pfrc = await SharedPreferences.getInstance();
    return pfrc.getBool("login");
  }
}
