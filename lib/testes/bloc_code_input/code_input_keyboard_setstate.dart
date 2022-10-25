import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'code_input_bloc.dart';
import 'code_input_event.dart';
import 'code_input_state.dart';

class TestePageCodeInputWidget extends StatefulWidget {
  const TestePageCodeInputWidget({Key? key}) : super(key: key);

  @override
  State<TestePageCodeInputWidget> createState() => _TestePageCodeInputWidgetState();
}

class _TestePageCodeInputWidgetState extends State<TestePageCodeInputWidget> {
  bool isError = false;
  String currentCode = "";

  TextEditingController textEditingController = TextEditingController();
  FocusNode focusNode = FocusNode();
  late CodeInputBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = CodeInputBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.withOpacity(0.9),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocBuilder<CodeInputBloc, ICodeInputState>(
              bloc: bloc,
              builder: (context, state) {
                return CodeInputWidget(
                  isStateError: state is CodeInputErrorState,
                  title: Text('Title'),
                  subTitle: Text('Subtitle'),
                  titleError: Text('Title Error'),
                  subTitleError: Text('subTitle error'),
                  onChanged: (value) {
                    bloc.currentCode = value;
                    if (bloc.currentCode.length == 6) {
                      bloc.add(CodeInputNewCodeAvailableEvent());
                    } else {
                      bloc.add(CodeInputNewCodeResetEvent());
                    }
                  },
                  textEditingController: textEditingController,
                  focusNode: focusNode,
                  onFocus: () {
                    focusNode.requestFocus();
                  },
                  paddingBetweenTitleAndSubtitle: EdgeInsets.zero,
                );
              },
            ),
            ElevatedButton(
              onPressed: () {
                if (bloc.currentCode == '123456') {
                  bloc.add(CodeInputNewCodeErrorEvent());
                  focusNode.unfocus();
                }
              },
              child: Text('submit'),
            ),
          ],
        ),
      ),
    );
  }
}

class CodeInputWidget extends StatefulWidget {
  const CodeInputWidget({
    Key? key,
    required this.isStateError,
    required this.title,
    required this.subTitle,
    required this.titleError,
    required this.subTitleError,
    required this.onChanged,
    required this.textEditingController,
    required this.focusNode,
    required this.onFocus,
    required this.paddingBetweenTitleAndSubtitle,
    this.lenght = 6,
    this.mainAxisRowFiedls = MainAxisAlignment.spaceBetween,
    this.marginEachField = EdgeInsets.zero,
    this.heightField = 52,
    this.widthField = 40,
    this.styleOfChildField = const TextStyle(fontSize: 18),
  }) : super(key: key);

  final bool isStateError;
  final int lenght;
  final Widget title;
  final Widget subTitle;
  final Widget titleError;
  final Widget subTitleError;
  final MainAxisAlignment mainAxisRowFiedls;
  final EdgeInsetsGeometry marginEachField;
  final double heightField;
  final double widthField;
  final TextStyle styleOfChildField;
  final Function(String)? onChanged;
  final VoidCallback onFocus;
  final TextEditingController textEditingController;
  final FocusNode focusNode;
  final EdgeInsetsGeometry paddingBetweenTitleAndSubtitle;

  @override
  State<CodeInputWidget> createState() => _CodeInputWidgetState();
}

class _CodeInputWidgetState extends State<CodeInputWidget> {
  int get _length => widget.lenght;
  bool get _isStateError => widget.isStateError;
  Widget get _title => widget.title;
  Widget get _subTitle => widget.subTitle;
  Widget get _titleError => widget.titleError;
  Widget get _subTitleError => widget.subTitleError;
  EdgeInsetsGeometry get _marginEachField => widget.marginEachField;
  MainAxisAlignment get _mainAxisRowFiedls => widget.mainAxisRowFiedls;
  double get _heightField => widget.heightField;
  double get _widthField => widget.widthField;
  TextStyle get _styleOfChildField => widget.styleOfChildField;
  Function(String)? get _onChanged => widget.onChanged;
  TextEditingController get _textEditingController => widget.textEditingController;
  FocusNode get _focusNode => widget.focusNode;
  VoidCallback get _onFocus => widget.onFocus;
  EdgeInsetsGeometry get _paddingBetweenTitleAndSubtitle => widget.paddingBetweenTitleAndSubtitle;

  int selectedIndex = 0;
  List<String> inputList = [];
  bool autoDismissKeyboard = true;
  bool enableEdit = false;

  void _setTextToInput(String data) {
    var replaceInputList = List<String>.filled(_length, '');

    for (var i = 0; i < _length; i++) {
      replaceInputList[i] = data.length > i ? data[i] : "";
    }

    // if (mounted) {
    setState(() {
      selectedIndex = data.length;
      inputList = replaceInputList;
      // _focusNode.requestFocus();
      // if (_focusNode.hasFocus == false) {
      //   _focusNode.requestFocus();
      // }
    });
    // }
  }

  void _textEditingControllerListenerRoutines() {
    _textEditingController.addListener(() {
      var _currentText = _textEditingController.text.toUpperCase();

      _setTextToInput(_currentText);
    });
  }

  // void _onFocus() {
  //   if (_focusNode.hasFocus && MediaQuery.of(context).viewInsets.bottom == 0) {
  //     _focusNode.unfocus();
  //     Future.delayed(const Duration(microseconds: 1), () => _focusNode.requestFocus());
  //   } else {
  //     _focusNode.requestFocus();
  //   }
  // }

  @override
  void initState() {
    super.initState();
    inputList = List<String>.filled(_length, '');
    _focusNode.addListener(() {
      print(_focusNode.hasPrimaryFocus);
      setState(() {});
    });

    _textEditingControllerListenerRoutines();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _isStateError ? _titleError : _title,
        Padding(
          padding: _paddingBetweenTitleAndSubtitle,
          child: Stack(
            children: [
              buildTextFormField(),
              Container(
                color: Colors.transparent,
                height: _heightField,
                width: double.infinity,
              ),
              GestureDetector(
                onTap: () {
                  _onFocus();
                },
                child: Row(
                  mainAxisAlignment: _mainAxisRowFiedls,
                  children: generateFields(),
                ),
              ),
            ],
          ),
        ),
        _isStateError ? _subTitleError : _subTitle,
        const SizedBox(
          height: 12,
        )
      ],
    );
  }

  Widget buildTextFormField() {
    final viewInsetsBottom = MediaQuery.of(context).viewInsets.bottom;
    final height = MediaQuery.of(context).size.height;

    return Container(
      color: Colors.transparent,
      height: 1,
      width: 1,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: TextField(
          key: Key('code-input-text-form-field'),
          controller: _textEditingController,
          focusNode: _focusNode,
          onChanged: _onChanged,
          scrollPadding: EdgeInsets.only(bottom: viewInsetsBottom + height / 3),
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.characters,
          inputFormatters: [LengthLimitingTextInputFormatter(_length)],
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.all(0),
            border: InputBorder.none,
            fillColor: Colors.transparent,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
          ),
          style: TextStyle(
            color: Colors.transparent,
            height: 0,
            fontSize: 0,
          ),
        ),
      ),
    );
  }

  List<Widget> generateFields() {
    var result = <Widget>[];
    // final colors = getColorPalette(context);
    for (var i = 0; i < _length; i++) {
      var widget = Container(
        margin: _marginEachField,
        height: _heightField,
        width: _widthField,
        decoration: _isStateError
            ? BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                border: Border(
                  bottom: BorderSide(
                    width: 1,
                    color: Colors.red,
                  ),
                ),
              )
            : BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                border: Border(
                  bottom: BorderSide(
                    width: 1,
                    color: Colors.white,
                  ),
                ),
              ),
        child: buildChildOfField(i),
      );

      result.add(widget);
    }

    return result;
  }

  Widget buildChildOfField(int index) {
    return Center(
      child: Text(
        inputList[index],
        style: _styleOfChildField,
      ),
    );
  }
}
