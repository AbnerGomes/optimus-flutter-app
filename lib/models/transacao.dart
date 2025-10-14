class Transacao {
  
  String gasto;
  double valor_gasto;
  String categoria;
  DateTime data;
  int? id;
  String? usuario;

  Transacao({ 
    required this.gasto,
    required this.valor_gasto,
    required this.categoria,
    required this.data,
    this.id,
    this.usuario,
  });

    factory Transacao.fromJson(Map<String, dynamic> json) {
    return Transacao(
       
      gasto: json['gasto'],
      valor_gasto: (json['valor_gasto'] as num).toDouble(),
      categoria: json['categoria'],
      data: DateTime.parse(json['data']),
      id: json['id'],
      usuario: json['usuario']
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'gasto': gasto,
        'valor_gasto': valor_gasto,
        'categoria': categoria,
        'data': data.toIso8601String(),
        'usuario': usuario,
      };
}
