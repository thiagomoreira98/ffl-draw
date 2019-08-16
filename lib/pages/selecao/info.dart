import 'package:flutter/material.dart';
import 'package:ffl_draw/core/components/drawer.dart';
import 'package:ffl_draw/pages/selecao/list.dart';
import 'package:ffl_draw/repository/selecao.dart';
import 'package:ffl_draw/models/selecao.dart';

class SelecaoInfo extends StatefulWidget {
  SelecaoInfo({ this.id });
  int id;

  @override
  _SelecaoInfoState createState() => _SelecaoInfoState(id);
}

class _SelecaoInfoState extends State<SelecaoInfo> {
  _SelecaoInfoState(this.id);
  final int id;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _form = GlobalKey<FormState>();

  bool loading = true;
  String title = 'Adicionando Seleção';
  SelecaoRepository _repository = SelecaoRepository();

  bool ativo = true;
  final nomeController = TextEditingController();

  void getSelecao(int id) async {
    Selecao selecao = await _repository.getSelecaoById(id);

    if(selecao != null) {
      title = 'Alterando ${selecao.nome}';
      ativo = selecao.ativo;
      nomeController.text = selecao.nome;
    }

    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    if(id != null) {
      getSelecao(id);
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
      Selecao _selecao = Selecao(
          id: id,
          ativo: ativo,
          nome: nome
      );

      if(_selecao.id != null) {
        await _repository.updateSelecao(_selecao);
      }
      else {
        await _repository.insertSelecao(_selecao);
      }

      Navigator.push(context, MaterialPageRoute(builder: (context) => SelecaoList()));
    }
  }

  goBack(context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => SelecaoList()));
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