import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapaWidget extends StatelessWidget {
  final LatLng centro;
  final LatLng? destino;
  final List<LatLng> rota;
  final Function(LatLng)? aoClicar;

  const MapaWidget({
    super.key,
    required this.centro,
    this.destino,
    this.rota = const [],
    this.aoClicar,
  });

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: centro,
        initialZoom: 15,
        onTap: aoClicar == null
            ? null
            : (tapPosition, ponto) {
                aoClicar!(ponto);
              },
      ),
      children: [
        TileLayer(
          urlTemplate:
              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName:
              'com.example.app_caminhadas',
        ),

        if (rota.isNotEmpty)
          PolylineLayer(
            polylines: [
              Polyline(
                points: rota,
                strokeWidth: 5,
                color: Colors.blue,
              ),
            ],
          ),

        MarkerLayer(
          markers: [
            Marker(
              point: centro,
              width: 45,
              height: 45,
              child: const Icon(
                Icons.my_location,
                color: Colors.green,
                size: 40,
              ),
            ),

            if (destino != null)
              Marker(
                point: destino!,
                width: 45,
                height: 45,
                child: const Icon(
                  Icons.location_pin,
                  color: Colors.red,
                  size: 45,
                ),
              ),
          ],
        ),
      ],
    );
  }
}