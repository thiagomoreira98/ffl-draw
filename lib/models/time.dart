import 'package:equatable/equatable.dart';

class Time extends Equatable {

  int id;
  bool ativo;
  String nome;

  Time({
    this.id,
    this.ativo,
    this.nome
  }) : super([id, ativo, nome]);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ativo': ativo,
      'nome': nome
    };
  }
}