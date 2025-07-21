import 'package:flutter/material.dart';

class AppHeader extends StatefulWidget {
  @override
  State<AppHeader> createState() => _AppHeaderState();
}

class _AppHeaderState extends State<AppHeader> {
  String modoSelecionado = 'Individual';

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.attach_money, size: 40, color: Colors.green[700]),
        Spacer(),
        DropdownButton<String>(
          value: modoSelecionado,
          items: ['Individual', 'Casal']
              .map((modo) => DropdownMenuItem(
                    value: modo,
                    child: Text(modo),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              modoSelecionado = value!;
            });
          },
        ),
        SizedBox(width: 10),
        CircleAvatar(
          backgroundColor: Colors.grey[300],
          child: Icon(Icons.person, color: Colors.black87),
        ),
      ],
    );
  }
}
