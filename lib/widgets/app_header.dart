import 'package:flutter/material.dart';

class AppHeader extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onLogout; // 👈 adicionamos esta callback

  AppHeader({required this.title, this.onLogout});

  @override
  State<AppHeader> createState() => _AppHeaderState();

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
          color: const Color(0xFF0abfa7),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Ícone à esquerda
            const Align(
              alignment: Alignment.centerLeft,
              child: Icon(Icons.attach_money, size: 28, color: Colors.white),
            ),

            // Título central
            Center(
              child: Text(
                widget.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // À direita
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<String>(
                    dropdownColor: const Color(0xFF0abfa7),
                    value: modoSelecionado,
                    style: const TextStyle(color: Colors.white),
                    underline: const SizedBox(),
                    iconEnabledColor: Colors.white,
                    items: ['Individual', 'Casal']
                        .map((modo) => DropdownMenuItem(
                              value: modo,
                              child: Text(modo,
                                  style: const TextStyle(color: Colors.white)),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        modoSelecionado = value!;
                      });
                    },
                  ),
                  const SizedBox(width: 10),

                  // Avatar e botão de sair
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, color: Colors.black87),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.logout, color: Colors.white),
                        tooltip: 'Sair',
                        onPressed: widget.onLogout, // 👈 chama o logout
                      ),
                    ],
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
