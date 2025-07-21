import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';
import 'screens/transacoes_screen.dart';
import 'screens/despesas_screen.dart';
import 'screens/receitas_screen.dart';

//função principal rodando a app chamando a classe principal (widget)
void main() {
  runApp(FinancasApp());
}

//classe do app em si
class FinancasApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //title: 'App de Finanças',
      theme: ThemeData(
         brightness: Brightness.light,
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Color(0xFFF7F9FC),
        fontFamily: 'Roboto',
        textTheme: TextTheme(
            bodyMedium: TextStyle(fontSize: 16),
      ),
      ),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        backgroundColor: const Color(0xFF0abfa7),
        elevation: 10,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart_outline, color: Colors.white),
            label: 'Dashboard',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.list_alt, color: Colors.white),
            label: 'Transações',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.money_off_csred_outlined, color: Colors.white),
            label: 'Despesas',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.attach_money_outlined, color: Colors.white),
            label: 'Receitas',
          ),
        ],
      ),
    );
  }
}


