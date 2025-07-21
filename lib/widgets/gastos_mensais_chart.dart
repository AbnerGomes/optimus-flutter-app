import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class GastosMensaisChart extends StatelessWidget {
  // Dados do gráfico de barras com degradê mais vivo
  final List<BarChartGroupData> barGroups = [
    BarChartGroupData(x: 0, barRods: [
      BarChartRodData(
        toY: 6000,
        width: 18,
        borderRadius: BorderRadius.circular(4),
        gradient: LinearGradient(
          colors: [Color(0xFF00C9A7), Color(0xFF8EF4C2)], // Verde brilhante degradê
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      )
    ]),
    BarChartGroupData(x: 1, barRods: [
      BarChartRodData(
        toY: 3000,
        width: 18,
        borderRadius: BorderRadius.circular(4),
        gradient: LinearGradient(
          colors: [Color(0xFF00C9A7), Color(0xFF8EF4C2)],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      )
    ]),
    BarChartGroupData(x: 2, barRods: [
      BarChartRodData(
        toY: 8000,
        width: 18,
        borderRadius: BorderRadius.circular(4),
        gradient: LinearGradient(
          colors: [Color(0xFF00C9A7), Color(0xFF8EF4C2)],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      )
    ]),
    BarChartGroupData(x: 3, barRods: [
      BarChartRodData(
        toY: 2000,
        width: 18,
        borderRadius: BorderRadius.circular(4),
        gradient: LinearGradient(
          colors: [Color(0xFF00C9A7), Color(0xFF8EF4C2)],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      )
    ]),
    BarChartGroupData(x: 4, barRods: [
      BarChartRodData(
        toY: 4000,
        width: 18,
        borderRadius: BorderRadius.circular(4),
        gradient: LinearGradient(
          colors: [Color(0xFF00C9A7), Color(0xFF8EF4C2)],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      )
    ]),
  ];

  // Rótulos personalizados no eixo X
  final List<String> labels = ['JAN/25', 'FEV/25', 'MAR/25', 'ABR/25', 'MAI/25'];

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título acima do gráfico
            Center(
              child: Text(
                  'Gastos Mensais',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal.shade700,
                  ),
                ),
            ),  
            const SizedBox(height: 12),

            SizedBox(
              height: 220,
              child: BarChart(
                BarChartData(
                  gridData: FlGridData(show: false), // Remove grade
                  borderData: FlBorderData(show: false), // Remove bordas
                  barGroups: barGroups, // Dados das barras
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 32,
                        getTitlesWidget: (value, _) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              labels[value.toInt()],
                              style: TextStyle(fontSize: 12),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        interval: 4000,
                        getTitlesWidget: (value, _) {
                          if (value % 4000 == 0 && value <= 8000) {
                            return Text(
                              '${value.toInt()}',
                              style: TextStyle(fontSize: 10, color: Colors.grey[700]),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
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
