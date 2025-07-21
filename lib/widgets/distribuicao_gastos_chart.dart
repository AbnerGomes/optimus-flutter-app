import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DistribuicaoGastosChart extends StatelessWidget {
  final List<PieChartSectionData> sections = [
    PieChartSectionData(value: 40, title: '', color: Color(0xFFEF5350)), // vermelho suave
    PieChartSectionData(value: 25, title: '', color: Color(0xFF42A5F5)), // azul suave
    PieChartSectionData(value: 20, title: '', color: Color(0xFF66BB6A)), // verde suave
    PieChartSectionData(value: 10, title: '', color: Color(0xFFFFCA28)), // amarelo suave
    PieChartSectionData(value: 5,  title: '', color: Color(0xFFAB47BC)), // roxo suave
  ];

  final List<Map<String, dynamic>> legendas = [
    {'cor': Color(0xFFEF5350), 'texto': 'Moradia'},
    {'cor': Color(0xFF42A5F5), 'texto': 'Transporte'},
    {'cor': Color(0xFF66BB6A), 'texto': 'Alimentação'},
    // outras categorias omitidas para manter a legenda compacta
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Legendas centralizadas verticalmente
            Expanded(
              flex: 2,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: legendas.map((item) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Row(
                        children: [
                          Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              color: item['cor'],
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(item['texto'], style: TextStyle(fontSize: 13)),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(width: 12),
            // Gráfico centralizado
            Expanded(
              flex: 4,
              child: SizedBox(
                height: 180,
                child: Center(
                  child: PieChart(
                    PieChartData(
                      sections: sections,
                      centerSpaceRadius: 40,
                      sectionsSpace: 1,
                      borderData: FlBorderData(show: false),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
