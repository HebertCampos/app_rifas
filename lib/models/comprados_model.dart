class Comprado {
  final int id;
  final String nome;
  final String telefone;

  Comprado({required this.id, required this.nome, required this.telefone});

  factory Comprado.fromJson(Map<String, dynamic> json) {
    return Comprado(
      id: json['id'],
      nome: json['nome'],
      telefone: json['telefone'],
    );
  }
}
