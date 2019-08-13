import 'package:flutter/material.dart';
import 'package:ffl_draw/core/storage/storage.dart';
import 'package:ffl_draw/models/user.dart';
import 'package:ffl_draw/pages/login/login.dart';
import 'package:ffl_draw/pages/home/home.dart';

class Auth extends StatefulWidget {
  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {

  bool isLogged = false;
  bool loading = true;

  Future userIsLogged() async {
    Storage storage = Storage();
//    await storage.removeUser();
    User _user = await storage.getUser();

    if(_user.usuario != null)
      setState(() {
        isLogged = true;
      });

    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    userIsLogged();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: render()
    );
  }

  Widget render() {
    if(loading) {
      return Center(
          child: CircularProgressIndicator()
      );
    }
    else {
      return isLogged == true ? Home() : Login();
    }
  }
}