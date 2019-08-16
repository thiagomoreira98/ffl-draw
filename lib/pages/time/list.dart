import 'package:flutter/material.dart';
import 'package:ffl_draw/core/components/drawer.dart';
import 'package:ffl_draw/pages/time/info.dart';
import 'package:ffl_draw/repository/time.dart';
import 'package:ffl_draw/models/time.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TimeList extends StatefulWidget {
  @override
  _TimeListState createState() => _TimeListState();
}

class _TimeListState extends State<TimeList> {

  bool loading = true;
  TimeRepository _repository = TimeRepository();
  List<Time> _times = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void goToAddPlayer(context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => TimeInfo()));
  }

  void getTimes() async {
    _times = await _repository.getTimes();

    setState(() {
      loading = false;
    });
  }

  void editTime(int id) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => TimeInfo(id: id)));
  }

  void deleteTime(int id, int index) async {
    await _repository.deleteTime(id);

    setState(() {
      _times.removeAt(index);
    });
  }

  @override
  void initState() {
    getTimes();
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
              title: Text('Times'),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => goToAddPlayer(context),
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
                    onTap: () => editTime(item.id),
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
                ),
//                secondaryActions: <Widget>[
//                  IconSlideAction(
//                    caption: 'Remover',
//                    color: Colors.red,
//                    icon: Icons.delete,
//                    onTap: () => deleteTime(item.id, index),
//                  ),
//                ],
              );
            },
          )
      );
    }
  }
}