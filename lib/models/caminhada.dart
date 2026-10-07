class Caminhada {
  final String id;
  final String titulo;

  final double origemLatitude;
  final double origemLongitude;

  final double destinoLatitude;
  final double destinoLongitude;

  final double distancia;
  final double calorias;
  final double tempo;

  final List<List<double>> rota;

  final String? foto;

  Caminhada({
    required this.id,
    required this.titulo,
    required this.origemLatitude,
    required this.origemLongitude,
    required this.destinoLatitude,
    required this.destinoLongitude,
    required this.distancia,
    required this.calorias,
    required this.tempo,
    required this.rota,
    this.foto,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'origemLatitude': origemLatitude,
      'origemLongitude': origemLongitude,
      'destinoLatitude': destinoLatitude,
      'destinoLongitude': destinoLongitude,
      'distancia': distancia,
      'calorias': calorias,
      'tempo': tempo,
      'rota': rota,
      'foto': foto,
    };
  }

  factory Caminhada.fromJson(Map<String, dynamic> json) {
    return Caminhada(
      id: json['id'],
      titulo: json['titulo'],
      origemLatitude: json['origemLatitude'],
      origemLongitude: json['origemLongitude'],
      destinoLatitude: json['destinoLatitude'],
      destinoLongitude: json['destinoLongitude'],
      distancia: json['distancia'],
      calorias: json['calorias'],
      tempo: json['tempo'],
      rota: List<List<double>>.from(
        (json['rota'] as List).map(
          (ponto) => List<double>.from(ponto),
        ),
      ),
      foto: json['foto'],
    );
  }
}