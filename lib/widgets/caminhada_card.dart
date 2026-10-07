import 'package:flutter/material.dart';

import '../models/caminhada.dart';

class CaminhadaCard extends StatelessWidget {
  final Caminhada caminhada;
  final VoidCallback aoClicar;

  const CaminhadaCard({
    super.key,
    required this.caminhada,
    required this.aoClicar,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: const Icon(Icons.directions_walk),
        ),
        title: Text(
          caminhada.titulo,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          '${(caminhada.distancia / 1000).toStringAsFixed(2)} km • '
          '${caminhada.tempo.toStringAsFixed(0)} min',
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: aoClicar,
      ),
    );
  }
}