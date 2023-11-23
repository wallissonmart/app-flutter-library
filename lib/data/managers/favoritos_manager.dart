import 'dart:convert';
import 'package:flutter_app_challenge/data/models/livro_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritosManager {
  static const _keyFavoritos = 'favoritos';

  Future<List<LivroModel>> getFavoritos() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritosJson = prefs.getStringList(_keyFavoritos) ?? [];
    return favoritosJson
        .map((json) => LivroModel.fromMap(jsonDecode(json)))
        .toList();
  }

  Future<bool> isLivroFavorito(LivroModel livro) async {
    final favoritos = await getFavoritos();
    return favoritos.any((favLivro) => favLivro.id == livro.id);
  }

  Future<void> toggleFavorito(LivroModel livro) async {
    final prefs = await SharedPreferences.getInstance();
    final favoritos = await getFavoritos();

    if (await isLivroFavorito(livro)) {
      favoritos.removeWhere((favLivro) => favLivro.id == livro.id);
    } else {
      favoritos.add(livro);
    }

    final favoritosJson =
        favoritos.map((livro) => jsonEncode(livro.toMap())).toList();
    prefs.setStringList(_keyFavoritos, favoritosJson);
  }
}
