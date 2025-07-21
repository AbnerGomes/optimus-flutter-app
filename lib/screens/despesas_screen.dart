import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DespesasScreen extends StatelessWidget {
  final List<Map<String, dynamic>> transacoes = [
    {
      'data': DateTime(2025, 7, 10),
      'categoria': 'Alimentação',
      'descricao': 'Pizza no jantar',
      'valor': 58.90,
    },
    {
      'data': DateTime(2025, 7, 11),
      'categoria': 'Transporte',
      'descricao': 'Combustível',
      'valor': 120.00,
    },
    {
      'data': DateTime(2025, 7, 12),
      'categoria': 'Lazer',
      'descricao': 'Cinema com a Lídia',
      'valor': 35.00,
    },
  ];

  String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  String formatCurrency(double value) {
    return NumberFormat.simpleCurrency(locale: 'pt_BR').format(value);
  }

  @override
  Widget build(BuildContext context) {
    double total = transacoes.fold(0, (sum, item) => sum + item['valor']);

    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Transações'),
      //   centerTitle: true,
      //   backgroundColor: Colors.teal,
      // ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 8,
            child: Container(
              padding: EdgeInsets.all(16),
              constraints: BoxConstraints(maxWidth: 600),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(
                  //   'Histórico de Transações',
                  //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  // ),
                  SizedBox(height: 12),
                  Expanded(
                    child: ListView.separated(
                      itemCount: transacoes.length,
                      separatorBuilder: (context, index) => Divider(color: Colors.grey.shade300),
                      itemBuilder: (context, index) {
                        final item = transacoes[index];
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(item['descricao'], style: TextStyle(fontWeight: FontWeight.w500)),
                          subtitle: Text(
                            '${item['categoria']} • ${formatDate(item['data'])}',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          trailing: Text(
                            formatCurrency(item['valor']),
                            style: TextStyle(
                              color: Colors.red.shade400,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Divider(thickness: 1, height: 32),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Total do período: ${formatCurrency(total)}',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal[700]),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
