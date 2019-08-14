import 'package:flutter/material.dart';
import 'package:ffl_draw/core/components/drawer.dart';
import 'package:ffl_draw/pages/player/info.dart';
import 'package:ffl_draw/repository/player.dart';
import 'package:ffl_draw/models/player.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class PlayerList extends StatefulWidget {
  @override
  _PlayerListState createState() => _PlayerListState();
}

class _PlayerListState extends State<PlayerList> {

  bool loading = true;
  PlayerRepository _repository = PlayerRepository();
  List<Player> _players = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void goToAddPlayer(context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => PlayerInfo()));
  }

  void getPlayers() async {
    _players = await _repository.getPlayers();

    setState(() {
      loading = false;
    });
  }

  void editPlayer(int id) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => PlayerInfo(id: id)));
  }

  void deletePlayer(int id, int index) async {
    await _repository.deletePlayer(id);

    setState(() {
      _players.removeAt(index);
    });
  }

  @override
  void initState() {
    getPlayers();
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
              title: Text('Players'),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => goToAddPlayer(context),
                ),
              ]
          ),
          drawer: NavDrawer(),
          body: ListView.separated(
            itemCount: _players.length,
            separatorBuilder: (BuildContext context, int index) => Divider(),
            itemBuilder: (context, index) {
              final item = _players[index];

              return new Slidable(
                actionPane: SlidableBehindActionPane(),
                actionExtentRatio: 0.25,
                child: Container(
                  color: Colors.white,
                  child: ListTile(
                    leading: Container(
                      padding: EdgeInsets.only(top: 8),
                      child: CircleAvatar(
                        radius: 10,
                        backgroundColor: item.ativo ? Colors.green : Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    title: Text(item.nome,
                        style: TextStyle(color: Colors.black, fontSize: 20)
                    ),
                    subtitle: Text('PSN: ${item.idPsn}'),
                  ),
                ),
                secondaryActions: <Widget>[
                  IconSlideAction(
                    caption: 'Editar',
                    color: Colors.grey,
                    icon: Icons.edit,
                    onTap: () => editPlayer(item.id),
                  ),
                  IconSlideAction(
                    caption: 'Remover',
                    color: Colors.red,
                    icon: Icons.delete,
                    onTap: () => deletePlayer(item.id, index),
                  ),
                ],
              );
            },
          )
      );
    }
  }
}