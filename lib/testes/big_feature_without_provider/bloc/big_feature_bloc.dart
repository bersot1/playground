import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playground/testes/big_feature_without_provider/bloc/big_feature_event.dart';
import 'package:playground/testes/big_feature_without_provider/bloc/big_feature_state.dart';

class BigFeatureBloc extends Bloc<IBigFeatureEvent, IBigFeatureState> {
  BigFeatureBloc() : super(BigFeatureInitialState()) {
    on<BigFeatureGetDataPageOneEvent>(_functionPageOne);
    on<BigFeatureGetDataPageTwoEvent>(_functionPageTwo);
    on<BigFeatureGetDataPageThreeEvent>(_functionPageThree);
  }

  String? test;

  Future<void> _functionPageOne(
    IBigFeatureEvent event,
    Emitter<IBigFeatureState> emit,
  ) async {
    emit(BigFeatureLoadingPageOneState());
    await Future.delayed(const Duration(seconds: 5));
    test = 'Julia';
    emit(BigFeatureSuccessPageOneState('resultado page one'));
  }

  _functionPageTwo(
    IBigFeatureEvent event,
    Emitter<IBigFeatureState> emit,
  ) {
    print('page two');
  }

  _functionPageThree(
    IBigFeatureEvent event,
    Emitter<IBigFeatureState> emit,
  ) {
    print('page Three');
  }
}
