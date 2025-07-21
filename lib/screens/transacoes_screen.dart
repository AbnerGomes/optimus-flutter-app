import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transacao.dart';
import '../services/transacao_service.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart' as dp;

// Tela de listagem e gerenciamento de transações
class TransacoesScreen extends StatefulWidget {
  @override
  _TransacoesScreenState createState() => _TransacoesScreenState();
}

class _TransacoesScreenState extends State<TransacoesScreen> {
  // Filtros
  DateTime? dataInicial;
  DateTime? dataFinal;
  String? categoriaSelecionada;

  // Lista de categorias disponíveis
  final List<String> categorias = [
    'Alimentação',
    'Entretenimento',
    'Saúde',
    'Moradia',
    'Mobilidade',
    'Dívidas',
    'Outros',
    'Educação'
  ];

  List<Transacao> transacoes = [];
  bool isLoading = true;
  final TransacaoService service = TransacaoService();

  @override
  void initState() {
    super.initState();
    carregarTransacoes();
  }

  // Carrega todas as transações do serviço
  Future<void> carregarTransacoes() async {
    setState(() {
      isLoading = true;
    });
    try {
      final dados = await service.fetchTransacoes();
      setState(() {
        transacoes = dados;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Erro ao carregar transações: $e');
    }
  }

  // Retorna ícone baseado na categoria
  IconData getIconeCategoria(String categoria) {
    switch (categoria) {
      case 'Alimentação':
        return Icons.restaurant;
      case 'Mobilidade':
        return Icons.directions_car;
      case 'Entretenimento':
        return Icons.movie;
      case 'Saúde':
        return Icons.local_hospital;
      case 'Educação':
        return Icons.movie;
      case 'Dívidas':
        return Icons.money;   
      case 'Moradia':
        return Icons.house;            
      default:
        return Icons.category;
    }
  }

  // Filtra as transações conforme data e categoria
  List<Transacao> get transacoesFiltradas {
    return transacoes.where((t) {
      final dentroData = (dataInicial == null || t.data.isAfter(dataInicial!.subtract(Duration(days: 1)))) &&
          (dataFinal == null || t.data.isBefore(dataFinal!.add(Duration(days: 1))));
      final mesmaCategoria = categoriaSelecionada == null || t.categoria == categoriaSelecionada;
      return dentroData && mesmaCategoria;
    }).toList();
  }

  // Soma total das transações filtradas
  double get totalPeriodo =>
      transacoesFiltradas.fold(0.0, (soma, item) => soma + item.valor_gasto);

  // Abre o seletor de intervalo de datas
  Future<void> selecionarIntervaloData(BuildContext context) async {
    DateTime hoje = DateTime.now();
    DateTime firstDate = DateTime(2000);
    DateTime lastDate = DateTime(2100);

    DateTime? _start = dataInicial ?? hoje;
    DateTime? _end = dataFinal ?? hoje;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              title: Text("Selecione o intervalo"),
              content: SizedBox(
                width: 300,
                height: 300,
                child: dp.RangePicker(
                  selectedPeriod: dp.DatePeriod(_start!, _end!),
                  onChanged: (dp.DatePeriod newPeriod) {
                    setModalState(() {
                      _start = newPeriod.start;
                      _end = newPeriod.end;
                    });
                  },
                  firstDate: firstDate,
                  lastDate: lastDate,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancelar"),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      dataInicial = _start;
                      dataFinal = _end;
                    });
                    Navigator.pop(context);
                  },
                  child: Text("Confirmar"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Edita uma transação existente
  void _editarTransacao(Transacao transacao) {
    final descricaoController = TextEditingController(text: transacao.gasto);
    final valorController = TextEditingController(text: transacao.valor_gasto.toString());
    String categoriaAtual = transacao.categoria;
    DateTime dataSelecionada = transacao.data;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar Transação'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: descricaoController,
                  decoration: InputDecoration(labelText: 'Descrição'),
                ),
                TextFormField(
                  controller: valorController,
                  decoration: InputDecoration(labelText: 'Valor'),
                  keyboardType: TextInputType.number,
                ),
                DropdownButtonFormField<String>(
                  value: categoriaAtual,
                  decoration : InputDecoration(labelText: 'Categoria'),
                  items: categorias.map((c) {
                    return DropdownMenuItem(value: c, child: Text(c));
                  }).toList(),
                  onChanged: (value) {
                    categoriaAtual = value!;
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text('Data: ${DateFormat('dd/MM/yyyy').format(dataSelecionada)}'),
                    IconButton(
                      icon: Icon(Icons.calendar_today, size: 20),
                      onPressed: () async {
                        final novaData = await showDatePicker(
                          context: context,
                          initialDate: dataSelecionada,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (novaData != null) {
                          setState(() {
                            dataSelecionada = novaData;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancelar')),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  transacao.gasto = descricaoController.text;
                  transacao.valor_gasto = double.tryParse(valorController.text) ?? 0.0;
                  transacao.categoria = categoriaAtual;
                  transacao.data = dataSelecionada;
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Transação atualizada')));
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  // Cria nova transação
  void _novaTransacao() {
    final descricaoController = TextEditingController();
    final valorController = TextEditingController();
    String categoriaAtual = categorias.first;
    DateTime dataSelecionada = DateTime.now();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Nova Transação'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: descricaoController,
                  decoration: InputDecoration(labelText: 'Descrição'),
                ),
                TextFormField(
                  controller: valorController,
                  decoration: InputDecoration(labelText: 'Valor'),
                  keyboardType: TextInputType.number,
                ),
                DropdownButtonFormField<String>(
                  value: categoriaAtual,
                  decoration: InputDecoration(labelText: 'Categoria'),
                  items: categorias.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (value) {
                    categoriaAtual = value!;
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text('Data: ${DateFormat('dd/MM/yyyy').format(dataSelecionada)}'),
                    IconButton(
                      icon: Icon(Icons.calendar_today, size: 20),
                      onPressed: () async {
                        final novaData = await showDatePicker(
                          context: context,
                          initialDate: dataSelecionada,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (novaData != null) {
                          setState(() {
                            dataSelecionada = novaData;
                          });
                        }
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancelar')),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  transacoes.add(Transacao(
                    gasto: descricaoController.text,
                    valor_gasto: double.tryParse(valorController.text) ?? 0.0,
                    categoria: categoriaAtual,
                    data: dataSelecionada,
                  ));
                });
                Navigator.pop(context);
              },
              child: Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('dd/MM/yyyy');

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            // Cabeçalho da tela
            // Container(
            //   height: 60,
            //   width: double.infinity,
            //   color: Color(0xFF0abfa7),
            //   alignment: Alignment.center,
            //   child: Text(
            //     'Transações',
            //     style: TextStyle(
            //       color: Colors.white,
            //       fontSize: 20,
            //       fontWeight: FontWeight.w600,
            //     ),
            //   ),
            // ),

            // Conteúdo principal da tela
            Expanded(
              child: Center(
                child: Container(
                  constraints: BoxConstraints(maxWidth: 800),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
                  child: Column(
                    children: [
                      // Filtros (datas e categoria)
                      Card(
                        color: Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              OutlinedButton.icon(
                                icon: Icon(Icons.calendar_today, color: Color(0xFF0abfa7)),
                                onPressed: () => selecionarIntervaloData(context),
                                label: Text(
                                  (dataInicial != null && dataFinal != null)
                                      ? '${formatter.format(dataInicial!)} - ${formatter.format(dataFinal!)}'
                                      : 'Selecione o intervalo',
                                ),
                              ),
                              DropdownButton<String>(
                                value: categoriaSelecionada,
                                hint: Text('Categoria'),
                                items: categorias.map((c) {
                                  return DropdownMenuItem(
                                    value: c,
                                    child: Row(
                                      children: [
                                        Icon(getIconeCategoria(c), size: 18, color: Color(0xFF0abfa7)),
                                        SizedBox(width: 6),
                                        Text(c),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                underline: SizedBox(),
                                onChanged: (valor) => setState(() => categoriaSelecionada = valor),
                              ),
                              TextButton.icon(
                                onPressed: () => setState(() {
                                  dataInicial = null;
                                  dataFinal = null;
                                  categoriaSelecionada = null;
                                }),
                                icon: Icon(Icons.clear, color: Colors.redAccent),
                                label: Text('Limpar filtros', style: TextStyle(color: Colors.redAccent)),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 16),
                      // Lista de transações
                      isLoading
                          ? Expanded(child: Center(child: CircularProgressIndicator()))
                          : Expanded(
                              child: Card(
                                color: Colors.white,
                                elevation: 2,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: ListView.builder(
                                    itemCount: transacoesFiltradas.length,
                                    itemBuilder: (context, index) {
                                      final t = transacoesFiltradas[index];
                                      return Container(
                                        margin: EdgeInsets.symmetric(vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(8),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.05),
                                              blurRadius: 4,
                                              offset: Offset(0, 2),
                                            )
                                          ],
                                        ),
                                        child: ListTile(
                                          leading: Icon(getIconeCategoria(t.categoria), color: Color(0xFF0abfa7)),
                                          title: Text(t.gasto),
                                          subtitle: Text('${t.categoria} - ${formatter.format(t.data)}'),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text('R\$ ${t.valor_gasto.toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold)),
                                              SizedBox(width: 8),
                                              IconButton(
                                                icon: Icon(Icons.edit, size: 20, color: Colors.blueAccent),
                                                onPressed: () => _editarTransacao(t),
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.delete, size: 20, color: Colors.redAccent),
                                                onPressed: () {
                                                  setState(() {
                                                    transacoes.remove(t);
                                                  });
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: Text('Transação excluída')),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                      SizedBox(height: 12),
                      // Total do período
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Total do período: R\$ ${totalPeriodo.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      // Botão flutuante para adicionar nova transação
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            height: 60,
            width: 60,
            child: FloatingActionButton(
              onPressed: _novaTransacao,
              backgroundColor: Color(0xFF0abfa7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 28,
              ),
              tooltip: 'Nova Transação',
            ),
          ),
        ),
      ),
    );
  }
}
