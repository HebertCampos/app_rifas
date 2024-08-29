class Comprados {
  final int id;
  final String nome;
  final String telefone;

  Comprados({required this.id, required this.nome, required this.telefone});

  factory Comprados.fromJson(Map<String, dynamic> json) {
    return Comprados(
      id: json['id'],
      nome: json['nome'],
      telefone: json['telefone'],
    );
  }
}
