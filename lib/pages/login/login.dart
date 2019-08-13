import 'package:flutter/material.dart';
import 'package:ffl_draw/core/storage/storage.dart';
import 'package:ffl_draw/models/user.dart';
import 'package:ffl_draw/core/environment/environment.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _form = GlobalKey<FormState>();

  final usuarioController = TextEditingController();
  final senhaController = TextEditingController();
  final storage = Storage();
  bool exibirSenha = false;

  void showPassword() {
    setState(() {
      this.exibirSenha = !this.exibirSenha;
    });
  }

  void onSubmit() async {
    String usuario = usuarioController.text;
    String senha = senhaController.text;

    if (this._form.currentState.validate()) {
      User _user = this.getUser(usuario, senha);

      if (_user != null) {
        print('if: ${_user.nome}');
        await storage.setUser(_user);
//        Navigator.push(context, route)
      }
      else {
        print('else: ${_user}');
        this._scaffoldKey.currentState.showSnackBar(
            SnackBar(
              content: new Text('Usuario ou Senha inválido!'),
              action: SnackBarAction(
                label: 'Fechar',
                onPressed: () {},
              ),
            )
        );
      }
    }
  }

  User getUser(usuario, senha) {
    User _user;

    Environment.users.forEach((u) {
      if (u.usuario == usuario && u.senha == senha)
        _user = u;
    });

    return _user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: this._scaffoldKey,
        body: Container(
            padding: EdgeInsets.all(8.0),
            child: Center(
              child: Card(
                child: Form(
                  key: this._form,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 16, right: 16, top: 16),
                        child: TextFormField(
                          controller: usuarioController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: 'Usuario',
                            border: OutlineInputBorder()
                          ),
                          validator: (value) {
                            if(value.isEmpty) {
                              return 'Informe um usuário';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 16, right: 16, top: 16),
                        child: TextFormField(
                          controller: senhaController,
                          keyboardType: TextInputType.text,
                          obscureText: this.exibirSenha ? false : true,
                          decoration: InputDecoration(
                            labelText: 'Senha',
                            border: OutlineInputBorder(),
                            suffixIcon: IconButton(
                                onPressed: () => showPassword(),
                                icon: Icon(this.exibirSenha ? Icons.visibility_off : Icons.visibility)
                            )
                          ),
                          validator: (value) {
                            if(value.isEmpty) {
                              return 'Informe uma senha';
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                          width: 200,
                          height: 40,
                          margin: EdgeInsets.only(top: 16, bottom: 16),
                          child: RaisedButton(
                            child: Text('ENTRAR',
                              style: TextStyle(color: Colors.white, fontSize: 14),
                            ),
                            onPressed: () => onSubmit(),
                            color: Colors.blue,
                          )
                      )
                    ]
                  )
                ),
              ),
            )
        )
    );
  }
}