import 'package:flutter/material.dart';

class AppHeader extends StatefulWidget implements PreferredSizeWidget {
  
  final String title;

  AppHeader({required this.title});

  @override
  State<AppHeader> createState() => _AppHeaderState();

  // Aqui indicamos a altura padrão da appbar
  @override
  Size get preferredSize => Size.fromHeight(56);
}

class _AppHeaderState extends State<AppHeader> {
  String modoSelecionado = 'Individual';

  @override
  Widget build(BuildContext context) {
    final larguraTela = MediaQuery.of(context).size.width;

    return SafeArea(
      bottom: false,
      child: Container(
        width: larguraTela,
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Color(0xFF0abfa7),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Conteúdo à esquerda
            Align(
              alignment: Alignment.centerLeft,
              child: Icon(Icons.attach_money, size: 28, color: Colors.white),
            ),

            // Título centralizado
            Center(
              child: Text(
                widget.title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Conteúdo à direita
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<String>(
                    dropdownColor: Color(0xFF0abfa7),
                    value: modoSelecionado,
                    style: TextStyle(color: Colors.white),
                    underline: SizedBox(),
                    iconEnabledColor: Colors.white,
                    items: ['Individual', 'Casal']
                        .map((modo) => DropdownMenuItem(
                              value: modo,
                              child: Text(modo, style: TextStyle(color: Colors.white)),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
