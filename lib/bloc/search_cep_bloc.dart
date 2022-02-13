import 'dart:async';

import 'package:dio/dio.dart';

class SearchCepBloc {
  final _streamController = StreamController<String>.broadcast();
  Sink<String> get searchCep => _streamController.sink;
  Stream<Map> get cepResult => _streamController.stream.asyncMap(_searchCep);
  // asyncMac ->  é um operador de programacao funcional
  // que ajuda a converter o resultado da stream no tipo da saida que necessita
  // nesse caso, o retorno deve ser um MAP mas o resultado da funcao
  // da stream é uma String, ou seja, vai converter a String num MAP

  Future<Map> _searchCep(String cep) async {
    try {
      final response = await Dio().get('https://viacep.com.br/ws/$cep/json/');

      return response.data;
    } catch (e) {
      throw Exception('Erro na pesquisa');
    }
  }

  void dispose() {
    _streamController.close();
  }
}
