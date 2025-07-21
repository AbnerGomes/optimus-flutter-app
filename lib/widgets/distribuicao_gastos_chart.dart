import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/transacao_service.dart'; // ajuste o caminho se necessário
import '../models/transacao.dart'; // ajuste conforme sua estrutura

class DistribuicaoGastosChart extends StatefulWidget {

  final String dataSelecionada;

  const DistribuicaoGastosChart({required this.dataSelecionada, Key? key}) : super(key: key);

  @override
  _DistribuicaoGastosChartState createState() => _DistribuicaoGastosChartState();
}

class _DistribuicaoGastosChartState extends State<DistribuicaoGastosChart> {
  final TransacaoService service = TransacaoService();

  List<PieChartSectionData> sections = [];
  List<Map<String, dynamic>> legendas = [];
  bool carregando = true;

  final List<List<Color>> coresGradientes = [
    [Color(0xFFEF5350), Color(0xFFFF8A80)],
    [Color(0xFF42A5F5), Color(0xFF90CAF9)],
    [Color(0xFF66BB6A), Color(0xFFA5D6A7)],
    [Color(0xFFFFCA28), Color(0xFFFFF59D)],
    [Color(0xFFAB47BC), Color(0xFFE1BEE7)],
    [Color(0xFF8D6E63), Color(0xFFD7CCC8)],
    [Color(0xFF26A69A), Color(0xFF80CBC4)],
  ];

  int? touchedIndex;
  

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  @override
  void didUpdateWidget(covariant DistribuicaoGastosChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.dataSelecionada != widget.dataSelecionada) {
      carregarDados(); // recarrega quando a dataSelecionada muda
    }
  }


  Future<void> carregarDados() async {
    print("DEU BOM" );

    final transacoes = await service.fetchTransacoes(); // ajuste para seu método real

    final agora = DateTime.now();

    final despesas = transacoes.where((t) {
      if (widget.dataSelecionada == 'Hoje') {
        return t.data.year == agora.year &&
              t.data.month == agora.month &&
              t.data.day == agora.day;
      } else if (widget.dataSelecionada == 'Ontem') {
        final ontem = agora.subtract(Duration(days: 1));
        return t.data.year == ontem.year &&
              t.data.month == ontem.month &&
              t.data.day == ontem.day;
      } else if (widget.dataSelecionada == 'Mês Atual') {
        return t.data.year == agora.year &&
              t.data.month == agora.month;
      } else if (widget.dataSelecionada == 'Mês Anterior') {
        final anoMesPassado = (agora.month == 1) ? agora.year - 1 : agora.year;
        final mesPassado = (agora.month == 1) ? 12 : agora.month - 1;
        return t.data.year == anoMesPassado &&
              t.data.month == mesPassado;
      } else if (widget.dataSelecionada == 'Semana Passada') {
        final inicioSemanaPassada = agora.subtract(Duration(days: agora.weekday + 6));
        final fimSemanaPassada = inicioSemanaPassada.add(Duration(days: 6));
        return t.data.isAfter(inicioSemanaPassada.subtract(const Duration(days: 1))) &&
              t.data.isBefore(fimSemanaPassada.add(const Duration(days: 1)));
      }
      return false;
    }).toList();
    
    print(widget.dataSelecionada);

    // Agrupa por categoria
    final Map<String, double> porCategoria = {};
    for (var t in despesas) {
      porCategoria[t.categoria] = (porCategoria[t.categoria] ?? 0) + t.valor_gasto;
    }

    final total = porCategoria.values.fold(0.0, (a, b) => a + b);
    int corIndex = 0;

    final novasSections = <PieChartSectionData>[];
    final novasLegendas = <Map<String, dynamic>>[];

    porCategoria.forEach((categoria, valor) {
      final colors = coresGradientes[corIndex % coresGradientes.length];

      novasSections.add(
        PieChartSectionData(
          value: valor,
          title: '',
          gradient: RadialGradient(
            colors: colors,
            center: Alignment.center,
            radius: 0.85,
          ),
        ),
      );

      novasLegendas.add({
        'gradient': LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        'texto': categoria,
      });

      corIndex++;
    });

    setState(() {
      sections = novasSections;
      legendas = novasLegendas;
      carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: carregando
            ? Center(child: CircularProgressIndicator())
            : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
                                    gradient: item['gradient'],
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
                  Expanded(
                    flex: 4,
                    child: SizedBox(
                      height: 180,
                      child: Center(
                        //child: PieChart(
                          // PieChartData(
                          //   sections: sections,
                          //   centerSpaceRadius: 40,
                          //   sectionsSpace: 1,
                          //   borderData: FlBorderData(show: false),
                          // ),
                         child: sections.isEmpty
                          ? Text("Sem dados para o período selecionado.")
                          : PieChart(
                              PieChartData(
                                sectionsSpace: 1,
                                centerSpaceRadius: 40,
                                borderData: FlBorderData(show: false),
                                pieTouchData: PieTouchData(
                                  touchCallback: (event, response) {
                                    setState(() {
                                      touchedIndex = response?.touchedSection?.touchedSectionIndex;
                                    });
                                  },
                                ),
                                sections: List.generate(sections.length, (i) {
                                  final original = sections[i];
                                  return PieChartSectionData(
                                    value: original.value,
                                    gradient: original.gradient,
                                    title: touchedIndex == i ? '${original.value.toStringAsFixed(2)}' : '',
                                    titleStyle: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    radius: touchedIndex == i ? 60 : 50,
                                  );
                                }),
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
