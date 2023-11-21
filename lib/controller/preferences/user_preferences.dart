import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  Future<void> saveUserName(String name) async {
    final pfrc = await SharedPreferences.getInstance();

    await pfrc.setString("name", name);
  }

  Future<String?> getUsername() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    return preferences.getString("name");
  }

  Future<void> saveMail(mail) async {
    final pfrc = await SharedPreferences.getInstance();

    await pfrc.setString("mail", mail);
  }

  Future<String?> getMail() async {
    final pfrc = await SharedPreferences.getInstance();
    return pfrc.getString("mail");
  }

  Future<void> saveCelular(String celular) async {
    final pfrc = await SharedPreferences.getInstance();
    await pfrc.setString("celular", celular);
  }

  Future<String?> getCelular() async {
    final pfrc = await SharedPreferences.getInstance();
    return pfrc.getString("celular");
  }

  Future<void> saveLogin(bool login) async {
    final pfrc = await SharedPreferences.getInstance();
    await pfrc.setBool("login", login);
  }

  Future<bool?> getLogin() async {
    final pfrc = await SharedPreferences.getInstance();
    return pfrc.getBool("login");
  }
}
