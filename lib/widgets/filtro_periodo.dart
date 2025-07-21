import 'package:flutter/material.dart';

class FiltroPeriodo extends StatefulWidget {
  @override
  _FiltroPeriodoState createState() => _FiltroPeriodoState();
}

class _FiltroPeriodoState extends State<FiltroPeriodo> {
  final List<String> filtros = [
    'Hoje',
    'Ontem',
    'Semana Atual',
    'Semana Passada',
    'Mês Atual',
    'Mês Anterior',
  ];

  String? filtroSelecionado = 'Mês Atual'; // aqui já inicia selecionado

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Center(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: filtros.map((texto) {
              final bool selecionado = texto == filtroSelecionado;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    filtroSelecionado = texto;
                  });
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 250),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  decoration: BoxDecoration(
                    color: selecionado ? Color(0xFF0abfa7) : Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: selecionado ? Color(0xFF0abfa7) : Colors.grey.shade300,
                    ),
                    boxShadow: selecionado
                        ? [
                            BoxShadow(
                              color: Color(0xFF0abfa7).withOpacity(0.4),
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ]
                        : [],
                  ),
                  child: Text(
                    texto,
                    style: TextStyle(
                      color: selecionado ? Colors.white : Colors.grey[600],
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
