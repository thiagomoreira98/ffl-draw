class Selecao {

  int id;
  bool ativo;
  String nome;

  Selecao({
    this.id,
    this.ativo,
    this.nome
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ativo': ativo,
      'nome': nome
    };
  }
}