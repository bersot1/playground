import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playground/bloc/search_cep_states.dart';

class SearchCepBlocFlutterBloc extends Bloc<String, ISearchCepStatus> {
  SearchCepBlocFlutterBloc() : super(SearchCepSuccess({}));

  Stream<ISearchCepStatus> mapEventToState(String cep) async* {
    yield const SearchCepLoading();
    try {
      final response = await Dio().get('https://viacep.com.br/ws/$cep/json/');
      yield SearchCepSuccess(response.data);
    } catch (e) {
      yield SearchCepError('Erro ao buscar CEP');
    }
  }
}
