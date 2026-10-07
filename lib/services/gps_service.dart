import 'package:geolocator/geolocator.dart';

class GpsService {
  static Future<Position> obterLocalizacao() async {
    bool habilitado = await Geolocator.isLocationServiceEnabled();

    if (!habilitado) {
      throw Exception('GPS está desativado.');
    }

    LocationPermission permissao =
        await Geolocator.checkPermission();

    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();
    }

    if (permissao == LocationPermission.denied ||
        permissao == LocationPermission.deniedForever) {
      throw Exception('Permissão de localização negada.');
    }

    return await Geolocator.getCurrentPosition();
  }
}