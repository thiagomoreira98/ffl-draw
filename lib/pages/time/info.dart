import 'package:flutter/material.dart';
import 'package:ffl_draw/core/components/drawer.dart';
import 'package:ffl_draw/pages/time/list.dart';
import 'package:ffl_draw/repository/time.dart';
import 'package:ffl_draw/models/time.dart';

class TimeInfo extends StatefulWidget {
  TimeInfo({ this.id });
  int id;

  @override
  _TimeInfoState createState() => _TimeInfoState(id);
}

class _TimeInfoState extends State<TimeInfo> {
  _TimeInfoState(this.id);
  final int id;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _form = GlobalKey<FormState>();

  bool loading = true;
  String title = 'Adicionando Time';
  TimeRepository _repository = TimeRepository();

  bool ativo = true;
  final nomeController = TextEditingController();

  void getTime(int id) async {
    Time time = await _repository.getTimeById(id);

    if(time != null) {
      title = 'Alterando ${time.nome}';
      ativo = time.ativo;
      nomeController.text = time.nome;
    }

    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    if(id != null) {
      getTime(id);
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

    if (this._form.currentState.validate()) {
      Time _time = Time(
          id: id,
          ativo: ativo,
          nome: nome
      );

      if(_time.id != null) {
        await _repository.updateTime(_time);
      }
      else {
        await _repository.insertTime(_time);
      }

      Navigator.push(context, MaterialPageRoute(builder: (context) => TimeList()));
    }
  }

  goBack(context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => TimeList()));
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
//                          Padding(
//                            padding: EdgeInsets.only(left: 16, right: 16, top: 16),
//                            child: SwitchListTile(
//                              secondary: Icon(
//                                  ativo ? Icons.done : Icons.clear,
//                                  color: ativo ? Colors.green : Colors.red
//                              ),
//                              value: ativo,
//                              onChanged: (value) {
//                                setState(() {
//                                  ativo = value;
//                                });
//                              },
//                              title: new Text(ativo ? 'Ativo' : 'Inativo'),
//                            ),
//                          ),
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