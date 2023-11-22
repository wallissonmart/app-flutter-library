import 'package:flutter/material.dart';
import 'package:flutter_app_challenge/data/http/http_client.dart';
import 'package:flutter_app_challenge/data/managers/favoritos_manager.dart';
import 'package:flutter_app_challenge/data/repositories/livro_repository.dart';
import 'package:flutter_app_challenge/pages/stores/livro_store.dart';
import 'package:flutter_app_challenge/widgets/livro_widget.dart';
import 'package:flutter_app_challenge/data/models/livro_model.dart';

class LivrosPage extends StatefulWidget {
  const LivrosPage({super.key});

  @override
  State<LivrosPage> createState() => _LivrosPageState();
}

class _LivrosPageState extends State<LivrosPage> {
  final LivroStore store = LivroStore(
    repository: LivroRepository(
      client: HttpClient(),
    ),
  );

  late final FavoritosManager favoritosManager;

  @override
  void initState() {
    super.initState();
    store.getLivros();

    favoritosManager =
        FavoritosManager();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<LivroModel>>(
      valueListenable: store.state,
      builder: (context, livros, _) {
        return ValueListenableBuilder<bool>(
          valueListenable: store.isLoading,
          builder: (context, isLoading, _) {
            if (isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: livros.length,
              itemBuilder: (BuildContext context, int index) {
                return LivroWidget(
                  livro: livros[index],
                  favoritosManager: favoritosManager,
                  onToggleFavorite: () {
                    favoritosManager.toggleFavorito(livros[index]);
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
