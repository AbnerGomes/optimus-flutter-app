import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/transacao.dart';

class TransacaoService {
  final String apiUrl = 'https://optimus-flutter-app.onrender.com/transacoes'; // coloque sua URL aqui

Future<List<Transacao>> fetchTransacoes() async {
  final response = await http.get(Uri.parse(apiUrl));
  if (response.statusCode == 200) {
    final List<dynamic> jsonData = json.decode(utf8.decode(response.bodyBytes));
    return jsonData.map((json) => Transacao.fromJson(json)).toList();
  } else {
    throw Exception('Erro ao carregar transações');
  }
}


}
