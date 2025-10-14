import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard_screen.dart';
import '../services/login_service.dart'; // importa seu service

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final LoginService _loginService = LoginService(); // instancia o service
  bool _carregando = false;
  String? _erro;

  Future<void> _login() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });

    final usuario = _usuarioController.text.trim();
    final senha = _senhaController.text.trim();

    if (usuario.isEmpty || senha.isEmpty) {
      setState(() {
        _erro = 'Preencha usuário e senha';
        _carregando = false;
      });
      return;
    }

    try {
      final sucesso = await _loginService.getLogin(usuario, senha);

      if (sucesso) {
        // salva o usuário localmente
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('usuarioLogado', usuario);

        // redireciona para a HomePage
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        setState(() {
          _erro = 'Usuário ou senha inválidos';
        });
      }
    } catch (e) {
      setState(() {
        _erro = 'Erro ao realizar login. Tente novamente.';
      });
    } finally {
      setState(() {
        _carregando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.account_circle, size: 80, color: Colors.indigo),
                const SizedBox(height: 20),
                TextField(
                  controller: _usuarioController,
                  decoration: const InputDecoration(
                    labelText: 'Usuário',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _senhaController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Senha',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),
                if (_erro != null)
                  Text(
                    _erro!,
                    style: const TextStyle(color: Colors.red),
                  ),
                const SizedBox(height: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: const Color(0xFF0abfa7),
                  ),
                  onPressed: _carregando ? null : _login,
                  child: _carregando
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Entrar',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
