import 'package:flutter/material.dart';
import 'package:flutter_app_challenge/data/http/exceptions.dart';
import 'package:flutter_app_challenge/data/models/livro_model.dart';
import 'package:flutter_app_challenge/data/repositories/livro_repository.dart';

class LivroStore {
  final ILivroRepository repository;

  // Variável reativa para o loading
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  // Variável reativa para o state
  final ValueNotifier<List<LivroModel>> state =
      ValueNotifier<List<LivroModel>>([]);

  // Variável reativa para o erro
  final ValueNotifier<String> erro = ValueNotifier<String>('');

  LivroStore({required this.repository});

  Future getLivros() async {
    isLoading.value = true;

    try {
      final result = await repository.getLivros();
      state.value = result;
    } on NotFoundException catch (e) {
      erro.value = e.message;
    } catch (e) {
      erro.value = e.toString();
    }

    isLoading.value = false;
  }
}