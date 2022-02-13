import 'dart:async';

import 'package:dio/dio.dart';
import 'package:playground/bloc/search_cep_states.dart';
import 'package:rxdart/rxdart.dart';

class SearchCepBlocRxDart {
  final _streamController = StreamController<String>.broadcast();
  Sink<String> get searchCep => _streamController.sink;
  Stream<ISearchCepStatus> get cepResult =>
      _streamController.stream.switchMap(_searchCep);

  Stream<ISearchCepStatus> _searchCep(String cep) async* {
    yield const SearchCepLoading();
    try {
      final response = await Dio().get('https://viacep.com.br/ws/$cep/json/');
      yield SearchCepSuccess(response.data);
    } catch (e) {
      yield SearchCepError('Erro ao buscar CEP');
    }
  }

  void dispose() {
    _streamController.close();
  }
}
