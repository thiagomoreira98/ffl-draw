import 'package:flutter/material.dart';
import 'package:ffl_draw/core/components/drawer.dart';
import 'package:ffl_draw/pages/player/list.dart';
import 'package:ffl_draw/repository/player.dart';
import 'package:ffl_draw/repository/time.dart';
import 'package:ffl_draw/repository/selecao.dart';
import 'package:ffl_draw/models/player.dart';
import 'package:ffl_draw/models/time.dart';
import 'package:ffl_draw/models/selecao.dart';

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
  TimeRepository _timeRepository = TimeRepository();
  SelecaoRepository _selecaoRepository = SelecaoRepository();

  List<Time> _times = [];
  List<Selecao> _selecoes = [];

  bool ativo = true;
  int idTime;
  int idSelecao;
  final nomeController = TextEditingController();
  final idPsnController = TextEditingController();

  void getPlayer(int id) async {
     Player player = await _repository.getPlayerById(id);

     if(player != null) {
        title = 'Alterando ${player.nome}';
        ativo = player.ativo;
        nomeController.text = player.nome;
        idPsnController.text = player.idPsn;
        idTime = player.idTime;
        idSelecao = player.idSelecao;
     }
  }

  Future<void> getTimes() async {
    _times = await _timeRepository.getTimes(true);
  }

  Future<void> getSelecoes() async {
    _selecoes = await _selecaoRepository.getSelecoes(true);
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  void init() async {
    await getTimes();
    await getSelecoes();

    if(id != null) {
      await getPlayer(id);
    }

    setState(() {
      loading = false;
    });
  }

  void onSubmit() async {

    String nome = nomeController.text;
    String idPsn = idPsnController.text;

    if (this._form.currentState.validate()) {
      Player _player = Player(
        id: id,
        ativo: ativo,
        nome: nome,
        idPsn: idPsn,
        idTime: idTime,
        idSelecao: idSelecao
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
                              secondary: Icon(
                                  ativo ? Icons.done : Icons.clear,
                                  color: ativo ? Colors.green : Colors.red
                              ),
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
                              maxLength: 100,
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
                              maxLength: 50,
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
//                          Padding(
//                            padding: EdgeInsets.only(left: 16, right: 16, top: 16),
//                            child: DropdownButtonFormField<int>(
//                              decoration: InputDecoration(
//                                border: OutlineInputBorder(),
//                                labelText: 'Time',
//                              ),
//                              value: idTime,
//                              items: _times.map((Time t) {
//                                return DropdownMenuItem<int>(
//                                    value: t.id,
//                                    child: Text(t.nome)
//                                );
//                              }).toList(),
//                              onChanged: (int id) {
//                                setState(() {
//                                  idTime = id;
//                                });
//                              },
//                            )
//                          ),
//                          Padding(
//                              padding: EdgeInsets.only(left: 16, right: 16, top: 16),
//                              child: DropdownButtonFormField<Selecao>(
//                                decoration: InputDecoration(
//                                    border: OutlineInputBorder(),
//                                    labelText: 'Seleção'
//                                ),
//                                items: _selecoes.map((Selecao s) {
//                                  return DropdownMenuItem<Selecao>(
//                                      value: s,
//                                      child: Text(s.nome)
//                                  );
//                                }).toList(),
//                                onChanged: (Selecao selecao) {
//                                  setState(() {
//                                    idSelecao = selecao.id;
//                                  });
//                                },
//                              )
//                          ),
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