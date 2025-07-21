// lib/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import '../widgets/app_header.dart';
import '../widgets/gastos_mensais_chart.dart';
import '../widgets/filtro_periodo.dart';
import '../widgets/distribuicao_gastos_chart.dart';
import '../widgets/total_gasto_info.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppHeader(),
          SizedBox(height: 20),
          GastosMensaisChart(),
          SizedBox(height: 20),
          FiltroPeriodo(),
          SizedBox(height: 20),
          DistribuicaoGastosChart(),
          SizedBox(height: 20),
          TotalGastoInfo(),
        ],
      ),
    );
  }
}
