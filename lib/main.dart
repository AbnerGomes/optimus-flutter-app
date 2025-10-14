import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/transacoes_screen.dart';
import 'screens/despesas_screen.dart';
import 'screens/receitas_screen.dart';
import 'widgets/app_header.dart';

void main() {
  runApp(FinancasApp());
}

class FinancasApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFFF7F9FC),
        fontFamily: 'Roboto',
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthCheck(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => HomePage(),
      },
    );
  }
}

// Verifica se há usuário logado
class AuthCheck extends StatefulWidget {
  const AuthCheck({Key? key}) : super(key: key);

  @override
  _AuthCheckState createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  bool _carregando = true;
  bool _logado = false;

  @override
  void initState() {
    super.initState();
    _verificarLogin();
  }

  Future<void> _verificarLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final usuario = prefs.getString('usuarioLogado');
    setState(() {
      _logado = usuario != null;
      _carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_carregando) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return _logado ? HomePage() : const LoginScreen();
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    DashboardScreen(),
    TransacoesScreen(),
    DespesasScreen(),
    ReceitasScreen(),
  ];

  final List<String> _titles = [
    'Dashboard',
    'Transações',
    'Despesas',
    'Receitas',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('usuarioLogado');
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(
        title: _titles[_selectedIndex],
        onLogout: _logout,
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        backgroundColor: const Color(0xFF0abfa7),
        elevation: 10,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart_outline, color: Colors.white),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt, color: Colors.white),
            label: 'Transações',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.money_off_csred_outlined, color: Colors.white),
            label: 'Despesas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money_outlined, color: Colors.white),
            label: 'Receitas',
          ),
        ],
      ),
    );
  }
}
