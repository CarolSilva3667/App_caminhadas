import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/caminhada.dart';

class StorageService {
  static const String chave = 'caminhadas';

  static Future<List<Caminhada>> listar() async {
    final prefs = await SharedPreferences.getInstance();

    final dados = prefs.getStringList(chave) ?? [];

    return dados
        .map(
          (item) => Caminhada.fromJson(
            jsonDecode(item),
          ),
        )
        .toList();
  }

  static Future<void> salvar(Caminhada caminhada) async {
    final prefs = await SharedPreferences.getInstance();

    final caminhadas = await listar();

    caminhadas.add(caminhada);

    final dados = caminhadas
        .map(
          (item) => jsonEncode(item.toJson()),
        )
        .toList();

    await prefs.setStringList(chave, dados);
  }

  static Future<void> atualizar(Caminhada caminhada) async {
    final prefs = await SharedPreferences.getInstance();

    final caminhadas = await listar();

    final indice = caminhadas.indexWhere(
      (item) => item.id == caminhada.id,
    );

    if (indice != -1) {
      caminhadas[indice] = caminhada;
    }

    final dados = caminhadas
        .map(
          (item) => jsonEncode(item.toJson()),
        )
        .toList();

    await prefs.setStringList(chave, dados);
  }
}