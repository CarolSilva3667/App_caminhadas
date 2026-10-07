import 'dart:convert';
import 'package:http/http.dart' as http;

class RotaService {
  static Future<Map<String, dynamic>> obterRota({
    required double origemLatitude,
    required double origemLongitude,
    required double destinoLatitude,
    required double destinoLongitude,
  }) async {
    final url = Uri.parse(
      'https://router.project-osrm.org/route/v1/foot/'
      '$origemLongitude,$origemLatitude;'
      '$destinoLongitude,$destinoLatitude'
      '?overview=full&geometries=geojson',
    );

    final resposta = await http.get(url);

    if (resposta.statusCode != 200) {
      throw Exception('Erro ao obter rota.');
    }

    final dados = jsonDecode(resposta.body);

    if (dados['routes'] == null ||
        dados['routes'].isEmpty) {
      throw Exception('Nenhuma rota encontrada.');
    }

    final rota = dados['routes'][0];

    final coordenadas =
        rota['geometry']['coordinates'] as List;

    final pontos = coordenadas.map<List<double>>((ponto) {
      return [
        (ponto[1] as num).toDouble(),
        (ponto[0] as num).toDouble(),
      ];
    }).toList();

    return {
      'distancia': (rota['distance'] as num).toDouble(),
      'duracao': (rota['duration'] as num).toDouble(),
      'pontos': pontos,
    };
  }
}