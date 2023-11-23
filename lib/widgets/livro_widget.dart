import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_challenge/data/managers/favoritos_manager.dart';
import 'package:flutter_app_challenge/data/models/livro_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vocsy_epub_viewer/epub_viewer.dart';

class LivroWidget extends StatefulWidget {
  final LivroModel livro;
  final FavoritosManager favoritosManager;
  final VoidCallback onToggleFavorite;

  const LivroWidget({
    Key? key,
    required this.livro,
    required this.favoritosManager,
    required this.onToggleFavorite,
  }) : super(key: key);

  @override
  _LivroWidgetState createState() => _LivroWidgetState();
}

class _LivroWidgetState extends State<LivroWidget> {
  late bool isFavorito = false;

  @override
  void initState() {
    super.initState();
    _loadFavoritoState();
  }

  Future<void> _loadFavoritoState() async {
    bool favorito = await widget.favoritosManager.isLivroFavorito(widget.livro);
    setState(() {
      isFavorito = favorito;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _openEpubViewer();
      },
      child: Container(
        margin: const EdgeInsets.all(8.0),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.network(
              widget.livro.cover,
              width: 150,
              height: 200,
              fit: BoxFit.cover,
            ),
            Positioned(
              top: 0,
              right: 0,
              width: 40,
              height: 40,
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: IconButton(
                    icon: Icon(
                      isFavorito ? Icons.bookmark : Icons.bookmark_border,
                      color: isFavorito ? Colors.red : Colors.white,
                    ),
                    onPressed: () async {
                      setState(() {
                        isFavorito = !isFavorito;
                      });
                      widget.onToggleFavorite();
                    },
                    iconSize: 20,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8.0),
                color: Colors.black.withOpacity(0.5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.livro.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.livro.author,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openEpubViewer() async {
    VocsyEpub.setConfig(
      themeColor: Theme.of(context).primaryColor,
      identifier: "bookIdentifier",
      scrollDirection: EpubScrollDirection.ALLDIRECTIONS,

    );

    await _downloadAndOpenBook();
  }

  Future<void> _downloadAndOpenBook() async {
    Completer<String> downloadCompleter = Completer<String>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text('Baixando livro...'),
          content: LinearProgressIndicator(),
        );
      },
    );

    try {
      String path = await _downloadBook();
      downloadCompleter.complete(path);
      Navigator.pop(context);
      if (path.isNotEmpty) {
        await downloadCompleter.future;
        VocsyEpub.open(
          path,
          lastLocation: EpubLocator.fromJson({
            "bookId": "bookId",
            "href": "/OEBPS/ch06.xhtml",
            "created": 1539934158390,
            "locations": {"cfi": "epubcfi(/0!/4/4[simple_book]/2/2/6)"},
          }),
        );
      }
    } catch (e) {
      print('Erro durante o download e abertura do livro: $e');
      Navigator.pop(context);
    }
  }

  Future<String> _downloadBook() async {
    Directory? appDocDir = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();

    String path = appDocDir!.path + '/${widget.livro.title}.epub';
    File file = File(path);

    if (!File(path).existsSync()) {
      Completer<String> completer = Completer<String>();

      await file.create();
      await Dio().download(
        widget.livro.download,
        path,
        deleteOnError: true,
        onReceiveProgress: (receivedBytes, totalBytes) {
          if (!completer.isCompleted) {
            completer.complete(path);
          }
        },
      );

      return completer.future;
    } else {
      return path;
    }
  }
}
