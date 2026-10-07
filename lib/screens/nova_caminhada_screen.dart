import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../services/gps_service.dart';
import '../services/rota_service.dart';
import '../services/storage_service.dart';
import '../models/caminhada.dart';
import '../widgets/mapa_widget.dart';

class NovaCaminhadaScreen extends StatefulWidget {
  const NovaCaminhadaScreen({super.key});

  @override
  State<NovaCaminhadaScreen> createState() => _NovaCaminhadaScreenState();
}

class _NovaCaminhadaScreenState extends State<NovaCaminhadaScreen> {
  LatLng? origem;
  LatLng? destino;

  List<LatLng> rota = [];

  double distancia = 0;
  double calorias = 0;
  double tempo = 0;

  bool carregando = true;
  bool buscandoRota = false;

  @override
  void initState() {
    super.initState();
    carregarLocalizacao();
  }

  Future<void> carregarLocalizacao() async {
    try {
      final posicao = await GpsService.obterLocalizacao();

      if (!mounted) return;

      setState(() {
        origem = LatLng(posicao.latitude, posicao.longitude);

        carregando = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        carregando = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> selecionarDestino(LatLng ponto) async {
    if (origem == null) return;

    setState(() {
      destino = ponto;
      buscandoRota = true;
    });

    try {
      final resultado = await RotaService.obterRota(
        origemLatitude: origem!.latitude,
        origemLongitude: origem!.longitude,
        destinoLatitude: ponto.latitude,
        destinoLongitude: ponto.longitude,
      );

      final pontos = (resultado['pontos'] as List)
          .map((ponto) => LatLng(ponto[0], ponto[1]))
          .toList();

      final distanciaMetros = resultado['distancia'] as double;

      final duracaoSegundos = resultado['duracao'] as double;

      setState(() {
        rota = pontos;
        distancia = distanciaMetros;
        tempo = duracaoSegundos / 60;

        // Aproximação: 60 kcal por km.
        calorias = (distanciaMetros / 1000) * 60;

        buscandoRota = false;
      });
    } catch (e) {
      setState(() {
        buscandoRota = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao calcular rota: $e')));
    }
  }

  Future<void> salvarCaminhada() async {
    if (origem == null || destino == null) {
      return;
    }

    final tituloController = TextEditingController();

    final titulo = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Salvar caminhada'),

          content: TextField(
            controller: tituloController,
            decoration: const InputDecoration(
              labelText: 'Título',
              hintText: 'Ex.: Caminhada no parque',
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),

            ElevatedButton(
              onPressed: () {
                final texto = tituloController.text.trim();

                if (texto.isNotEmpty) {
                  Navigator.pop(context, texto);
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );

    if (titulo == null || titulo.isEmpty) {
      return;
    }

    final caminhada = Caminhada(
      id: DateTime.now().millisecondsSinceEpoch.toString(),

      titulo: titulo,

      origemLatitude: origem!.latitude,
      origemLongitude: origem!.longitude,

      destinoLatitude: destino!.latitude,
      destinoLongitude: destino!.longitude,

      distancia: distancia,
      calorias: calorias,
      tempo: tempo,

      rota: rota.map((ponto) => [ponto.latitude, ponto.longitude]).toList(),
    );

    await StorageService.salvar(caminhada);

    if (!mounted) return;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (carregando) {
      return Scaffold(
        appBar: AppBar(title: const Text('Nova Caminhada')),

        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (origem == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Nova Caminhada')),

        body: const Center(
          child: Text('Não foi possível obter sua localização.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Nova Caminhada')),

      body: Column(
        children: [
          Expanded(
            child: MapaWidget(
              centro: origem!,
              destino: destino,
              rota: rota,
              aoClicar: selecionarDestino,
            ),
          ),

          if (buscandoRota) const LinearProgressIndicator(),

          Container(
            padding: const EdgeInsets.all(16),

            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _Informacao(
                      icone: Icons.straighten,
                      titulo: 'Distância',
                      valor: '${(distancia / 1000).toStringAsFixed(2)} km',
                    ),

                    _Informacao(
                      icone: Icons.local_fire_department,
                      titulo: 'Calorias',
                      valor: '${calorias.toStringAsFixed(0)} kcal',
                    ),

                    _Informacao(
                      icone: Icons.timer,
                      titulo: 'Tempo',
                      valor: '${tempo.toStringAsFixed(0)} min',
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,

                  child: ElevatedButton.icon(
                    onPressed:
                        destino != null && rota.isNotEmpty && !buscandoRota
                        ? salvarCaminhada
                        : null,

                    icon: const Icon(Icons.save),

                    label: const Text('Salvar caminhada'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Informacao extends StatelessWidget {
  final IconData icone;
  final String titulo;
  final String valor;

  const _Informacao({
    required this.icone,
    required this.titulo,
    required this.valor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icone, color: const Color(0xFF6A0019)),

        const SizedBox(height: 4),

        Text(titulo, style: const TextStyle(fontSize: 12)),

        Text(valor, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}