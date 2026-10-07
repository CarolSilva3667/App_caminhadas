import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';

import '../models/caminhada.dart';
import '../services/storage_service.dart';
import '../widgets/mapa_widget.dart';

class DetalhesCaminhadaScreen extends StatefulWidget {
  final Caminhada caminhada;

  const DetalhesCaminhadaScreen({super.key, required this.caminhada});

  @override
  State<DetalhesCaminhadaScreen> createState() =>
      _DetalhesCaminhadaScreenState();
}

class _DetalhesCaminhadaScreenState extends State<DetalhesCaminhadaScreen> {
  late Caminhada caminhada;

  @override
  void initState() {
    super.initState();

    caminhada = widget.caminhada;
  }

  Future<void> tirarFoto() async {
    final picker = ImagePicker();

    final imagem = await picker.pickImage(source: ImageSource.camera);

    if (imagem == null) return;

    final atualizada = Caminhada(
      id: caminhada.id,
      titulo: caminhada.titulo,

      origemLatitude: caminhada.origemLatitude,

      origemLongitude: caminhada.origemLongitude,

      destinoLatitude: caminhada.destinoLatitude,

      destinoLongitude: caminhada.destinoLongitude,

      distancia: caminhada.distancia,
      calorias: caminhada.calorias,
      tempo: caminhada.tempo,

      rota: caminhada.rota,

      foto: imagem.path,
    );

    await StorageService.atualizar(atualizada);

    setState(() {
      caminhada = atualizada;
    });
  }

  @override
  Widget build(BuildContext context) {
    final origem = LatLng(caminhada.origemLatitude, caminhada.origemLongitude);

    final destino = LatLng(
      caminhada.destinoLatitude,
      caminhada.destinoLongitude,
    );

    final rota = caminhada.rota
        .map((ponto) => LatLng(ponto[0], ponto[1]))
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text(caminhada.titulo)),

      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 350,

              child: MapaWidget(centro: origem, destino: destino, rota: rota),
            ),

            Padding(
              padding: const EdgeInsets.all(16),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    caminhada.titulo,

                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6A0019),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,

                    children: [
                      _Info(
                        icone: Icons.straighten,
                        titulo: 'Distância',
                        valor:
                            '${(caminhada.distancia / 1000).toStringAsFixed(2)} km',
                      ),

                      _Info(
                        icone: Icons.local_fire_department,
                        titulo: 'Calorias',
                        valor: '${caminhada.calorias.toStringAsFixed(0)} kcal',
                      ),

                      _Info(
                        icone: Icons.timer,
                        titulo: 'Tempo',
                        valor: '${caminhada.tempo.toStringAsFixed(0)} min',
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  if (caminhada.foto != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),

                      child: kIsWeb
                          ? const SizedBox(
                              height: 250,

                              child: Center(
                                child: Text('Foto salva no dispositivo.'),
                              ),
                            )
                          : Image.file(
                              File(caminhada.foto!),

                              width: double.infinity,
                              height: 250,

                              fit: BoxFit.cover,
                            ),
                    )
                  else
                    Center(
                      child: Column(
                        children: [
                          const Icon(
                            Icons.camera_alt,

                            size: 80,

                            color: Color(0xFF6A0019),
                          ),

                          const SizedBox(height: 10),

                          ElevatedButton.icon(
                            onPressed: tirarFoto,

                            icon: const Icon(Icons.camera_alt),

                            label: const Text('Tirar foto'),
                          ),
                        ],
                      ),
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

class _Info extends StatelessWidget {
  final IconData icone;
  final String titulo;
  final String valor;

  const _Info({required this.icone, required this.titulo, required this.valor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icone, color: const Color(0xFF6A0019)),

        const SizedBox(height: 4),

        Text(titulo),

        Text(valor, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}