import 'dart:convert';

import 'package:flutter_app_challenge/data/http/exceptions.dart';
import 'package:flutter_app_challenge/data/http/http_client.dart';
import 'package:flutter_app_challenge/data/models/livro_model.dart';

abstract class ILivroRepository {
  Future<List<LivroModel>> getLivros();
}

class LivroRepository implements ILivroRepository {
  final IHttpClient client;

  LivroRepository({required this.client});

  @override
  Future<List<LivroModel>> getLivros() async {
    final response = await client.get(
      url: 'https://escribo.com/books.json',
    );

    if (response.statusCode == 200) {
      final List<LivroModel> livros = [];

      final body = jsonDecode(response.body);

      body.forEach((item) {
        final LivroModel livro = LivroModel.fromMap(item);

        if (livros.every((livroExistente) => livroExistente.id != livro.id)) {
          livros.add(livro);
        }
      });

      return livros;
    } else if (response.statusCode == 404) {
      throw NotFoundException('A url informada não é válida');
    } else {
      throw Exception('Não foi possível carregar os livros');
    }
  }
}
