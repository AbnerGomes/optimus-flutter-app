import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginService {
  //final String apiUrl = 'http://0.0.0.0:8000/login';
  final String apiUrl = 'https://optimus-flutter-app.onrender.com/login';

  /// Faz a validação de login chamando a API Flask
  Future<bool> getLogin(String usuario, String senha) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'usuario': usuario,
          'senha': senha,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Espera que a API retorne algo como {"success": true}
        if (data['success'] == true) {
          return true;
        } else {
          return false;
        }
      } else {
        print('Erro na API: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Erro ao conectar à API: $e');
      return false;
    }
  }
}
