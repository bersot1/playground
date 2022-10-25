abstract class ICodeInputEvent {}

class CodeInputNewCodeEvent implements ICodeInputEvent {
  final String code;

  CodeInputNewCodeEvent(this.code);
}

class CodeInputNewCodeResetEvent implements ICodeInputEvent {}

class CodeInputNewCodeErrorEvent implements ICodeInputEvent {}

class CodeInputNewCodeAvailableEvent implements ICodeInputEvent {}
