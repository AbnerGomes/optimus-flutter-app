import 'package:flutter/material.dart';

class TotalGastoInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      'Total Gasto no período: R\$ 2.264,03',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
        color: Colors.indigo[900],
      ),
    );
  }
}
