import 'package:shared_preferences/shared_preferences.dart';
import 'package:ffl_draw/models/user.dart';

class Storage {

  // isDrawed
  Future<void> setIsDrawed(bool isDrawed) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDrawed', isDrawed);
  }

  Future<bool> getIsDrawed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isDrawed');
  }

  // Dados Login
  Future setLogin(usuario, senha, remember) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('login-remember', remember);

    if(remember) {
      await prefs.setString('login-usuario', usuario);
      await prefs.setString('login-senha', senha);
    }
  }

  Future getLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return {
      'remember': await prefs.getBool('login-remember'),
      'usuario': await prefs.getString('login-usuario'),
      'senha': await prefs.getString('login-senha')
    };

  }

  // User
  Future<User> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final nome = await prefs.getString('usuario-nome');
    final usuario = await prefs.getString('usuario-usuario');
    final senha = await prefs.getString('usuario-senha');

    return User(nome: nome, usuario: usuario, senha: senha);
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

}