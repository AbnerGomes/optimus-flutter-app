import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardComFiltro extends StatefulWidget {
  @override
  _DashboardComFiltroState createState() => _DashboardComFiltroState();
}

class _DashboardComFiltroState extends State<DashboardComFiltro> {
  String filtroAtual = 'Hoje';

  // Aqui você pode definir dados diferentes para cada filtro
  final Map<String, List<PieChartSectionData>> dadosPorFiltro = {
    'Hoje': [
      PieChartSectionData(value: 40, color: Color(0xFF388E3C)),
      PieChartSectionData(value: 25, color: Color(0xFF81C784)),
      PieChartSectionData(value: 20, color: Color(0xFFA5D6A7)),
      PieChartSectionData(value: 10, color: Color(0xFFC8E6C9)),
      PieChartSectionData(value: 5, color: Color(0xFFE8F5E9)),
    ],
    'Ontem': [
      PieChartSectionData(value: 30, color: Color(0xFF0D47A1)),
      PieChartSectionData(value: 30, color: Color(0xFF42A5F5)),
      PieChartSectionData(value: 20, color: Color(0xFF90CAF9)),
      PieChartSectionData(value: 15, color: Color(0xFFBBDEFB)),
      PieChartSectionData(value: 5, color: Color(0xFFE3F2FD)),
    ],
    // Defina mais dados para os demais filtros...
  };

  List<PieChartSectionData> get dadosAtuais {
    return dadosPorFiltro[filtroAtual] ??
        dadosPorFiltro.values.first; // fallback
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FiltroPeriodo(
          onFiltroSelecionado: (filtro) {
            setState(() {
              filtroAtual = filtro;
            });
          },
        ),
        SizedBox(height: 24),
        Expanded(
          child: Card(
            color: Colors.white,
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Center(
              child: SizedBox(
                width: 200,
                height: 200,
                child: PieChart(
                  PieChartData(
                    sections: dadosAtuais,
                    centerSpaceRadius: 40,
                    sectionsSpace: 2,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
