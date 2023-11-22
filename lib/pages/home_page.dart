import 'package:flutter/material.dart';
import 'package:flutter_app_challenge/pages/favoritos_page.dart';
import 'package:flutter_app_challenge/pages/livros_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Livraria On'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.book), text: 'Livros'),
              Tab(icon: Icon(Icons.favorite), text: 'Favoritos'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            LivrosPage(),
            FavoritosPage(),
          ],
        ),
      ),
    );
  }
}

