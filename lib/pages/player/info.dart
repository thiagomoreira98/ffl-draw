import 'package:flutter/material.dart';
import 'package:ffl_draw/core/components/drawer.dart';
import 'package:ffl_draw/pages/player/list.dart';
import 'package:ffl_draw/repository/player.dart';
import 'package:ffl_draw/models/player.dart';

class PlayerInfo extends StatefulWidget {
  PlayerInfo({ this.id });
  int id;

  @override
  _PlayerInfoState createState() => _PlayerInfoState(id);
}

class _PlayerInfoState extends State<PlayerInfo> {
  _PlayerInfoState(this.id);
  final int id;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _form = GlobalKey<FormState>();

  bool loading = true;
  String title = 'Adicionando Player';
  PlayerRepository _repository = PlayerRepository();

  bool ativo = true;
  final nomeController = TextEditingController();
  final idPsnController = TextEditingController();

  void getPlayer(int id) async {
     Player player = await _repository.getPlayerById(id);

     if(player != null) {
        title = 'Alterando ${player.nome}';
        ativo = player.ativo;
        nomeController.text = player.nome;
        idPsnController.text = player.idPsn;
     }

     setState(() {
       loading = false;
     });
  }

  @override
  void initState() {
    if(id != null) {
      getPlayer(id);
    }
    else {
      setState(() {
        loading = false;
      });
    }

    super.initState();
  }

  void onSubmit() async {

    String nome = nomeController.text;
    String idPsn = idPsnController.text;

    if (this._form.currentState.validate()) {
      Player _player = Player(
        id: id,
        ativo: ativo,
        nome: nome,
        idPsn: idPsn
      );

      if(_player.id != null) {
        await _repository.updatePlayer(_player);
      }
      else {
        await _repository.insertPlayer(_player);
      }

      Navigator.push(context, MaterialPageRoute(builder: (context) => PlayerList()));
    }
  }

  goBack(context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => PlayerList()));
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Center(
          child: CircularProgressIndicator()
      );
    }
    else {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(title),
          automaticallyImplyLeading: true,
          leading: IconButton(icon:Icon(Icons.arrow_back),
            onPressed:() => goBack(context),
          )
        ),
        drawer: NavDrawer(),
        body: Container(
            padding: EdgeInsets.all(8.0),
            child: Center(
              child: Card(
                child: Form(
                    key: _form,
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                                left: 16, right: 16, top: 16),
                            child: SwitchListTile(
                              secondary: Icon(Icons.brush),
                              value: ativo,
                              onChanged: (value) {
                                setState(() {
                                  ativo = value;
                                });
                              },
                              title: new Text(ativo ? 'Ativo' : 'Inativo'),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 16, right: 16, top: 8),
                            child: TextFormField(
                              controller: nomeController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  labelText: 'Nome',
                                  border: OutlineInputBorder()
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Informe um nome';
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 16, right: 16, top: 16),
                            child: TextFormField(
                              controller: idPsnController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                labelText: 'ID PSN',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Informe uma ID PSN';
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
                                child: Text(id != null ? 'ALTERAR' : 'CADASTRAR',
                                  style: TextStyle(color: Colors.white, fontSize: 14),
                                ),
                                onPressed: () => onSubmit(),
                                color: Colors.blue,
                              )
                          ),

                        ]
                    )
                ),
              ),
            )
        ),
      );
    }
  }
}