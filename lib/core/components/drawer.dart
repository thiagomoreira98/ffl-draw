import 'package:flutter/material.dart';
import 'package:ffl_draw/core/storage/storage.dart';
import 'package:ffl_draw/pages/home/home.dart';
import 'package:ffl_draw/pages/login/login.dart';
import 'package:ffl_draw/pages/player/list.dart';

class NavDrawer extends StatelessWidget {

  final Storage storage = new Storage();

  void desconectar(context) async {
    await this.storage.removeUser();
    Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
  }

  void logout(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Desconectar"),
          content: new Text("Deseja realmente sair do aplicativo ?"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                this.desconectar(context);
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Drawer Header'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Home'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
              },
            ),
            ListTile(
              title: Text('Player'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => PlayerList()));
              },
            ),
            ListTile(
              title: Text('Sair do aplicativo'),
              onTap: () {
                this.logout(context);
              },
            ),
          ],
        ),
    );
  }
}