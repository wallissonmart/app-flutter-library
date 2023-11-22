import 'package:flutter/material.dart';
import 'package:flutter_app_challenge/data/managers/favoritos_manager.dart';
import 'package:flutter_app_challenge/data/models/livro_model.dart';
import 'package:flutter_app_challenge/widgets/livro_widget.dart';

class FavoritosPage extends StatefulWidget {
  const FavoritosPage({super.key});

  @override
  State<FavoritosPage> createState() => _FavoritosPageState();
}

class _FavoritosPageState extends State<FavoritosPage> {
  late final FavoritosManager favoritosManager;

  @override
  void initState() {
    super.initState();

    favoritosManager = FavoritosManager();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<LivroModel>>(
      future: favoritosManager.getFavoritos(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Erro ao obter livros favoritos: ${snapshot.error}',
              style: const TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              'Nenhum livro favorito encontrado',
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
          );
        } else {
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: snapshot.data!.length,
            itemBuilder: (BuildContext context, int index) {
              return LivroWidget(
                livro: snapshot.data![index],
                favoritosManager: favoritosManager,
                onToggleFavorite: () {
                  favoritosManager.toggleFavorito(snapshot.data![index]);
                },
              );
            },
          );
        }
      },
    );
  }
}
