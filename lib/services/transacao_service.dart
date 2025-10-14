import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/transacao.dart';

class TransacaoService {
  final String apiUrl = 'https://optimus-flutter-app.onrender.com/transacoes'; // 
  //final String apiUrl = 'http://0.0.0.0:8000/transacoes';

  Future<List<Transacao>> fetchTransacoes({String? usuario}) async {
    // Monta a URL, incluindo o filtro de usuário se informado
    String url = apiUrl;
    if (usuario != null && usuario.isNotEmpty) {
      url = '$apiUrl?usuario=$usuario';
    }

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(utf8.decode(response.bodyBytes));
      return jsonData.map((json) => Transacao.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao carregar transações (status: ${response.statusCode})');
    }
  }


  /// Salvar nova transação (POST)
  Future<Transacao> saveTransacoes(Transacao transacao) async {
  final response = await http.post(
    Uri.parse('$apiUrl/save'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'gasto': transacao.gasto,
      'valor_gasto': transacao.valor_gasto,
      'categoria': transacao.categoria,
      'data': transacao.data.toIso8601String().split('T')[0], // "2025-10-09"
      'usuario': transacao.usuario,
    }),
  );

  if (response.statusCode == 200) {
    return Transacao.fromJson(json.decode(utf8.decode(response.bodyBytes)));
  } else {
    throw Exception('Erro ao salvar transação: ${response.body}');
  }
}


  /// Editar transação existente (PUT)
  // Future<Transacao> editTransacoes(String id, Transacao transacao) async {
  //   final response = await http.put(
  //     Uri.parse('$apiUrl/$id'),
  //     headers: {'Content-Type': 'application/json; charset=UTF-8'},
  //     body: json.encode(transacao.toJson()),
  //   );

  //   if (response.statusCode == 200) {
  //     return Transacao.fromJson(json.decode(utf8.decode(response.bodyBytes)));
  //   } else {
  //     throw Exception('Erro ao editar transação');
  //   }
  // }
  Future<Transacao> editTransacoes(Transacao transacao) async {
    print(transacao);
    if (transacao.id == null) {
      throw Exception('ID da transação não pode ser nulo para edição');
    }

    final response = await http.put(
      Uri.parse('$apiUrl/edit/${transacao.id}'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: json.encode(transacao.toJson()),
    );

    if (response.statusCode == 200) {
      return Transacao.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Erro ao editar transação');
    }
  }
}
