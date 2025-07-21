class Transacao {
  String gasto;
  double valor_gasto;
  String categoria;
  DateTime data;

  Transacao({
    required this.gasto,
    required this.valor_gasto,
    required this.categoria,
    required this.data,
  });

    factory Transacao.fromJson(Map<String, dynamic> json) {
    return Transacao(
      gasto: json['gasto'],
      valor_gasto: (json['valor_gasto'] as num).toDouble(),
      categoria: json['categoria'],
      data: DateTime.parse(json['data']),
    );
  }

  Map<String, dynamic> toJson() => {
        'gasto': gasto,
        'valor_gasto': valor_gasto,
        'categoria': categoria,
        'data': data.toIso8601String(),
      };
}
