import 'package:flutter/material.dart';
import 'dart:math';
import 'package:ffl_draw/core/storage/storage.dart';
import 'package:ffl_draw/core/components/drawer.dart';
import 'package:ffl_draw/repository/player.dart';
import 'package:ffl_draw/models/player.dart';
import 'package:ffl_draw/repository/selecao.dart';
import 'package:ffl_draw/models/selecao.dart';
import 'package:ffl_draw/repository/time.dart';
import 'package:ffl_draw/models/time.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  bool loading = true;
  bool _isDrawed = false;
  Random _random = Random();
  Storage _storage = Storage();
  PlayerRepository _playerRepository = PlayerRepository();
  TimeRepository _timeRepository = TimeRepository();
  SelecaoRepository _selecaoRepository = SelecaoRepository();

  List<Time> _times = [];
  List<Selecao> _selecoes = [];
  List<Player> _players = [];

  Future<void> getTimes() async {
    _times = await _timeRepository.getTimes(true);
  }

  Future<void> getSelecoes() async {
    _selecoes = await _selecaoRepository.getSelecoes(true);
  }

  Future<List<Player>> getPlayers() async {
    return _playerRepository.getPlayers(true);
  }

  @override
  void initState() {
    init();
    super.initState();
  }


  void init() async {
    await getTimes();
    await getSelecoes();

    _isDrawed = await _storage.getIsDrawed();
    if(_isDrawed) {
      _players = await getPlayers();
    }
    else {
      _players = [];
    }

    setState(() {
      loading = false;
    });
  }

  void draw(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Sorteio"),
          content: Container(
              child: Text("Escolha o tipo de sorteio:")
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                  "Seleção",
                  style: TextStyle(fontSize: 16)
              ),
              onPressed: () => drawSelecoes(context),
            ),
            FlatButton(
              child: Text(
                  "Time",
                  style: TextStyle(fontSize: 16)
              ),
              onPressed: () => drawTimes(context),
            ),
          ],
        );
      },
    );
  }

  void alertDrawError(context, name) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Não foi possivel sortear"),
          content: Container(
              child: Text("Numero de ${name} inferior ao numero de players")
          ),
          actions: <Widget>[
            FlatButton(
                child: Text('OK'),
                onPressed: () => Navigator.of(context).pop()
            ),
          ],
        );
      },
    );
  }

  Future<void> drawTimes(context) async {
    Navigator.of(context).pop();
    await clear();

    _players = await getPlayers();

    if (_players.length > _times.length) {
      alertDrawError(context, 'times');
      return;
    }

    List<int> _ids = [];

    _times.forEach((Time t) {
      _ids.add(t.id);
    });

    for(Player p in _players) {
      p.idTime = _draw(_ids.length, 'selecao');
      await _playerRepository.updatePlayer(p);
    }

    await _storage.setIsDrawed(true);
    setState(() {});
  }

  Future<void> drawSelecoes(context) async {
    Navigator.of(context).pop();
    await clear();

    _players = await getPlayers();

    if (_players.length > _selecoes.length) {
      alertDrawError(context, 'seleções');
      return;
    }

    List<int> _ids = [];

    _selecoes.forEach((Selecao s) {
      _ids.add(s.id);
    });

    for(Player p in _players) {
      p.idSelecao = _draw(_ids.length, 'selecao');
      await _playerRepository.updatePlayer(p);
    }

    await _storage.setIsDrawed(true);
    setState(() {});
  }

  Future<void> clear() async {
    for(Player p in _players) {
      p.idSelecao = null;
      p.idTime = null;
      await _playerRepository.updatePlayer(p);
    }

    _players = [];
    await _storage.setIsDrawed(false);
  }

  int _draw(int _max, String timeOrSelecao) {
    int _id = _random.nextInt(_max) + 1;
    if (isDrawed(_id, timeOrSelecao)) {
      return _draw(_max, timeOrSelecao);
    }
    else {
      return _id;
    }
  }

  bool isDrawed(int value, String timeOrSelecao) {
    bool retorno = false;

    for (Player p in _players) {
      if (timeOrSelecao == 'time') {
        if (p.idTime == value) {
          retorno = true;
          break;
        }
      }
      else {
        if (p.idSelecao == value) {
          retorno = true;
          break;
        }
      }
    }

    return retorno;
  }

  String getNomeTime(int id) {
      String nome = '';

     _times.forEach((Time t) {
       if(t.id == id) {
         nome = t.nome;
       }
     });

     return nome;
  }

  String getNomeSelecao(int id) {
    String nome = '';

    _selecoes.forEach((Selecao s) {
      if(s.id == id) {
        nome = s.nome;
      }
    });

    return nome;
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
          appBar: AppBar(
              title: Text('Home'),
              actions: <Widget>[
                IconButton(
                    icon: Icon(Icons.autorenew),
                    onPressed: () => draw(context)
                ),
                IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      clear();
                      _players = [];
                      setState(() {});
                    }
                ),
              ]
          ),
          drawer: NavDrawer(),
          body: ListView.separated(
              itemCount: _players.length,
              separatorBuilder: (BuildContext context, int index) => Divider(),
              itemBuilder: (context, index) {
                Player item = _players[index];

                return ListTile(
                  title: Text(item.nome,
                      style: TextStyle(color: Colors.black, fontSize: 20)
                  ),
                  subtitle: Text('${item.idTime != null ? 'Time' : 'Seleção'}: ${item.idTime != null ? getNomeTime(item.id) : getNomeSelecao(item.idSelecao)}'),
                );
              }
          )
      );
    }
  }
}