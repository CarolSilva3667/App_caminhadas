import 'package:flutter/material.dart';

import '../models/caminhada.dart';
import '../services/storage_service.dart';
import '../widgets/caminhada_card.dart';

import 'nova_caminhada_screen.dart';
import 'detalhes_caminhada_screen.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback alternarTema;

  const HomeScreen({
    super.key,
    required this.alternarTema,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Caminhada> caminhadas = [];

  @override
  void initState() {
    super.initState();
    carregarCaminhadas();
  }

  Future<void> carregarCaminhadas() async {
    final dados = await StorageService.listar();

    if (!mounted) return;

    setState(() {
      caminhadas = dados;
    });
  }

  Future<void> novaCaminhada() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const NovaCaminhadaScreen(),
      ),
    );

    carregarCaminhadas();
  }

  @override
  Widget build(BuildContext context) {
    final temaEscuro =
        Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Caminhadas'),
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFF6A0019),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.directions_walk,
                    color: Colors.white,
                    size: 50,
                  ),

                  SizedBox(height: 10),

                  Text(
                    'Caminhadas',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            ListTile(
              leading: Icon(
                Icons.home,
                color: temaEscuro
                    ? Colors.white
                    : const Color(0xFF6A0019),
              ),
              title: const Text('Início'),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: Icon(
                Icons.brightness_6,
                color: temaEscuro
                    ? Colors.white
                    : const Color(0xFF6A0019),
              ),
              title: const Text('Tema claro/escuro'),
              onTap: () {
                widget.alternarTema();
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: Icon(
                Icons.logout,
                color: temaEscuro
                    ? Colors.white
                    : const Color(0xFF6A0019),
              ),
              title: const Text('Sair'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),

      body: caminhadas.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.directions_walk,
                    size: 80,
                    color: temaEscuro
                        ? Colors.white
                        : const Color(0xFF6A0019),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Nenhuma caminhada cadastrada.',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Clique no + para registrar uma nova caminhada.',
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: caminhadas.length,
              itemBuilder: (context, index) {
                final caminhada = caminhadas[index];

                return CaminhadaCard(
                  caminhada: caminhada,
                  aoClicar: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            DetalhesCaminhadaScreen(
                          caminhada: caminhada,
                        ),
                      ),
                    );
                  },
                );
              },
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: novaCaminhada,
        child: const Icon(Icons.add),
      ),
    );
  }
}