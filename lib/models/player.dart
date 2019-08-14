class Player {

  int id;
  bool ativo;
  String nome;
  String idPsn;

  Player({
    this.id,
    this.ativo,
    this.nome,
    this.idPsn
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ativo': ativo,
      'nome': nome,
      'idpsn': idPsn,
    };
  }
}