import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playground/testes/bloc_code_input/code_input_event.dart';
import 'package:playground/testes/bloc_code_input/code_input_state.dart';

class CodeInputBloc extends Bloc<ICodeInputEvent, ICodeInputState> {
  CodeInputBloc() : super(CodeInputInitialState());

  String currentCode = "";

  @override
  Stream<ICodeInputState> mapEventToState(ICodeInputEvent event) async* {
    if (event is CodeInputNewCodeErrorEvent) {
      yield CodeInputErrorState();
    } else if (event is CodeInputNewCodeResetEvent) {
      yield CodeInputInitialState();
    }
  }
}
