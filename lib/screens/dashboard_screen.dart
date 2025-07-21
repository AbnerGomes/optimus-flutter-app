// lib/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import '../widgets/app_header.dart';
import '../widgets/gastos_mensais_chart.dart';
import '../widgets/filtro_periodo.dart';
import '../widgets/distribuicao_gastos_chart.dart';
import '../widgets/total_gasto_info.dart';
import '../widgets/resumo_financeiro.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String dataSelecionada = 'Mês Atual'; // Começa com hoje

  void _atualizarData(String novaData) {
    setState(() {
      dataSelecionada = novaData;
      print(novaData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // AppHeader(),
          // SizedBox(height: 20),
          GastosMensaisChart(),
          SizedBox(height: 20),
          ResumoFinanceiro(totalReceitas: 8000, totalDespesas: 5000),
          SizedBox(height: 20),
          FiltroPeriodo(
            onFiltroSelecionado: (data) => _atualizarData(data),
          ),
          SizedBox(height: 20),
          DistribuicaoGastosChart(dataSelecionada: dataSelecionada),
          SizedBox(height: 20),
          TotalGastoInfo(),
        ],
      ),
    );
  }
}
