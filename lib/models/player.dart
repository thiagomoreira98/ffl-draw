class Player {

  int id;
  bool ativo;
  String nome;
  String idPsn;
  int idTime;
  int idSelecao;

  Player({
    this.id,
    this.ativo,
    this.nome,
    this.idPsn,
    this.idTime,
    this.idSelecao
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ativo': ativo,
      'nome': nome,
      'idpsn': idPsn,
      'idTime': idTime,
      'idSelecao': idSelecao
    };
  }
}