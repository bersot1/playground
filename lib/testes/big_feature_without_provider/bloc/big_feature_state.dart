abstract class IBigFeatureState {}

class BigFeatureInitialState implements IBigFeatureState {}

class BigFeatureLoadingPageOneState implements IBigFeatureState {}

class BigFeatureSuccessPageOneState implements IBigFeatureState {
  final String result;

  BigFeatureSuccessPageOneState(this.result);
}

class BigFeatureLoadingPageTwoState implements IBigFeatureState {}

class BigFeatureSuccessPageTwoState implements IBigFeatureState {}

class BigFeatureLoadingPageThreeState implements IBigFeatureState {}

class BigFeatureSuccessPageThreeState implements IBigFeatureState {}
