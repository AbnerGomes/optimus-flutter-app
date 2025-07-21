import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DistribuicaoGastosChart extends StatelessWidget {
  // Dados do gráfico de pizza com degradê radial aplicado em cada fatia
  final List<PieChartSectionData> sections = [
    PieChartSectionData(
      value: 40,
      title: '',
      gradient: RadialGradient(
        colors: [
          Color(0xFFEF5350), // vermelho escuro
          Color(0xFFFF8A80), // vermelho claro
        ],
        center: Alignment.center,
        radius: 0.85,
      ),
    ),
    PieChartSectionData(
      value: 25,
      title: '',
      gradient: RadialGradient(
        colors: [
          Color(0xFF42A5F5), // azul escuro
          Color(0xFF90CAF9), // azul claro
        ],
        center: Alignment.center,
        radius: 0.85,
      ),
    ),
    PieChartSectionData(
      value: 20,
      title: '',
      gradient: RadialGradient(
        colors: [
          Color(0xFF66BB6A), // verde escuro
          Color(0xFFA5D6A7), // verde claro
        ],
        center: Alignment.center,
        radius: 0.85,
      ),
    ),
    PieChartSectionData(
      value: 10,
      title: '',
      gradient: RadialGradient(
        colors: [
          Color(0xFFFFCA28), // amarelo escuro
          Color(0xFFFFF59D), // amarelo claro
        ],
        center: Alignment.center,
        radius: 0.85,
      ),
    ),
    PieChartSectionData(
      value: 5,
      title: '',
      gradient: RadialGradient(
        colors: [
          Color(0xFFAB47BC), // roxo escuro
          Color(0xFFE1BEE7), // roxo claro
        ],
        center: Alignment.center,
        radius: 0.85,
      ),
    ),
  ];

  // Mesmas cores usadas no gráfico, para legenda
  final List<Map<String, dynamic>> legendas = [
    {
      'gradient': LinearGradient(
        colors: [Color(0xFFEF5350), Color(0xFFFF8A80)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      'texto': 'Moradia'
    },
    {
      'gradient': LinearGradient(
        colors: [Color(0xFF42A5F5), Color(0xFF90CAF9)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      'texto': 'Transporte'
    },
    {
      'gradient': LinearGradient(
        colors: [Color(0xFF66BB6A), Color(0xFFA5D6A7)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      'texto': 'Alimentação'
    },
    // Outras categorias omitidas para manter legenda compacta
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
            // Legendas com degradê nas caixas de cor
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
                          // Caixa com degradê usando BoxDecoration e LinearGradient
                          Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              gradient: item['gradient'],  // Aplicando degradê na legenda
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
            // Gráfico centralizado com degradê radial em cada fatia
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
