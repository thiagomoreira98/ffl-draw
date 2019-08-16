import 'package:flutter/material.dart';
import 'package:ffl_draw/core/components/drawer.dart';
import 'package:ffl_draw/pages/selecao/info.dart';
import 'package:ffl_draw/repository/selecao.dart';
import 'package:ffl_draw/models/selecao.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SelecaoList extends StatefulWidget {
  @override
  _SelecaoListState createState() => _SelecaoListState();
}

class _SelecaoListState extends State<SelecaoList> {

  bool loading = true;
  SelecaoRepository _repository = SelecaoRepository();
  List<Selecao> _times = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void goToAddSelecao(context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => SelecaoInfo()));
  }

  void getSelecaos() async {
    _times = await _repository.getSelecoes();

    setState(() {
      loading = false;
    });
  }

  void editSelecao(int id) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => SelecaoInfo(id: id)));
  }

  void deleteSelecao(int id, int index) async {
    await _repository.deleteSelecao(id);

    setState(() {
      _times.removeAt(index);
    });
  }

  @override
  void initState() {
    getSelecaos();
    super.initState();
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
              title: Text('Seleções'),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => goToAddSelecao(context),
                ),
              ]
          ),
          drawer: NavDrawer(),
          body: ListView.separated(
            itemCount: _times.length,
            separatorBuilder: (BuildContext context, int index) => Divider(),
            itemBuilder: (context, index) {
              final item = _times[index];

              return new Slidable(
                actionPane: SlidableBehindActionPane(),
                actionExtentRatio: 0.25,
                child: Container(
                  color: Colors.white,
                  child: ListTile(
                    onTap: () => editSelecao(item.id),
//                    leading: Container(
//                      padding: EdgeInsets.only(top: 8),
//                      child: CircleAvatar(
//                        radius: 10,
//                        backgroundColor: item.ativo ? Colors.green : Colors.red,
//                        foregroundColor: Colors.white,
//                      ),
//                    ),
                    title: Text(item.nome,
                        style: TextStyle(color: Colors.black, fontSize: 20)
                    ),
                  ),
                )
//                secondaryActions: <Widget>[
//                  IconSlideAction(
//                    caption: 'Remover',
//                    color: Colors.red,
//                    icon: Icons.delete,
//                    onTap: () => deleteSelecao(item.id, index),
//                  ),
//                ],
              );
            }
          )
      );
    }
  }
}