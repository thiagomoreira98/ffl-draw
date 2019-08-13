import 'package:shared_preferences/shared_preferences.dart';

// models
import 'package:ffl_draw/models/user.dart';

class Storage {

  // User
  Future<User> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final nome = await prefs.getString('usuario-nome');
    final usuario = await prefs.getString('usuario-usuario');
    final senha = await prefs.getString('usuario-senha');

    return User(
      nome,
      usuario,
      senha
    );
  }

  Future setUser(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('usuario-nome', user.nome);
    await prefs.setString('usuario-usuario', user.usuario);
    await prefs.setString('usuario-senha', user.senha);
  }

  Future removeUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('usuario-nome');
    await prefs.remove('usuario-usuario');
    await prefs.remove('usuario-senha');
  }

  // Player

}