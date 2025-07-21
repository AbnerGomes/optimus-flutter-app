import 'package:flutter/material.dart';

class ResumoFinanceiro extends StatelessWidget {
  final double totalDespesas;
  final double totalReceitas;

  ResumoFinanceiro({
    required this.totalDespesas,
    required this.totalReceitas,
  });

  @override
  Widget build(BuildContext context) {
    final double maxValor = (totalDespesas > totalReceitas) ? totalDespesas : totalReceitas;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Card Despesas
          Expanded(
            child: _buildCardInterno(
              titulo: 'Despesas',
              valor: totalDespesas,
              maxValor: maxValor,
              corPrimaria: Colors.red,
              corSecundaria: Colors.redAccent,
            ),
          ),
          SizedBox(width: 20),
          // Card Receitas
          Expanded(
            child: _buildCardInterno(
              titulo: 'Receitas',
              valor: totalReceitas,
              maxValor: maxValor,
              corPrimaria: Colors.green,
              corSecundaria: Colors.greenAccent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardInterno({
    required String titulo,
    required double valor,
    required double maxValor,
    required Color corPrimaria,
    required Color corSecundaria,
  }) {
    return Card(
      color: Colors.white, // fundo branco aqui
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
        //   crossAxisAlignment: CrossAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center, // centraliza horizontalmente
          children: [
            Text(
              titulo,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center, // centraliza o texto
            ),
            SizedBox(height: 8),
            Text(
              'R\$ ${valor.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 16, color: corPrimaria),
            ),
            SizedBox(height: 12),
            _buildBarraHorizontal(
              valor: valor,
              maxValor: maxValor,
              corPrimaria: corPrimaria,
              corSecundaria: corSecundaria,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBarraHorizontal({
    required double valor,
    required double maxValor,
    required Color corPrimaria,
    required Color corSecundaria,
  }) {
    final double larguraTotal = 120;
    final double alturaBarra = 20;
    final double larguraPreenchida = maxValor == 0 ? 0 : (valor / maxValor) * larguraTotal;

    return Container(
      width: larguraTotal,
      height: alturaBarra,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          width: larguraPreenchida,
          height: alturaBarra,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [corPrimaria, corSecundaria],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.horizontal(
              left: Radius.circular(10),
              right: Radius.circular(larguraPreenchida == larguraTotal ? 10 : 0),
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: Text('Resumo Financeiro')),
      body: Center(
        child: ResumoFinanceiro(
          totalDespesas: 8000,
          totalReceitas: 5000,
        ),
      ),
    ),
  ));
}
