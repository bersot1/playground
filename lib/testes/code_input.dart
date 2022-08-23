import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/rendering/editable.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class CodeInput extends StatefulWidget {
  const CodeInput({
    Key? key,
    required this.isStateError,
    required this.title,
    required this.subTitle,
    required this.titleError,
    required this.subTitleError,
    required this.validator,
    required this.textEditingController,
    required this.focusNode,
    required this.formStateglobalKey,
    this.lenght = 6,
    this.paddingWidget = const EdgeInsets.symmetric(horizontal: 16),
    this.mainAxisRowFiedls = MainAxisAlignment.spaceBetween,
    this.marginEachField = EdgeInsets.zero,
    this.heightField = 52,
    this.widthField = 40,
    this.defaultFieldBoxDecoration = const BoxDecoration(
      color: Color(0xffeeeeee),
      border: Border(
        bottom: BorderSide(
          width: 1,
          color: Colors.black,
        ),
      ),
    ),
    this.errorFieldBoxDecoration = const BoxDecoration(
      color: Color(0xffeeeeee),
      border: Border(
        bottom: BorderSide(
          width: 1,
          color: Colors.red,
        ),
      ),
    ),
    this.styleOfChildField = const TextStyle(fontSize: 18),
  }) : super(key: key);

  final bool isStateError;
  final int lenght;
  final Widget title;
  final Widget subTitle;
  final Widget titleError;
  final Widget subTitleError;
  final EdgeInsetsGeometry paddingWidget;
  final MainAxisAlignment mainAxisRowFiedls;
  final EdgeInsetsGeometry marginEachField;
  final double heightField;
  final double widthField;
  final BoxDecoration defaultFieldBoxDecoration;
  final BoxDecoration errorFieldBoxDecoration;
  final TextStyle styleOfChildField;
  final FormFieldValidator<String>? validator;
  final TextEditingController textEditingController;
  final FocusNode focusNode;
  final GlobalKey<FormState> formStateglobalKey;

  @override
  State<CodeInput> createState() => _CodeInputState();
}

class _CodeInputState extends State<CodeInput> {
  late String currentText;

  int get _length => widget.lenght;
  bool get _isStateError => widget.isStateError;
  Widget get _title => widget.title;
  Widget get _subTitle => widget.subTitle;
  Widget get _titleError => widget.titleError;
  Widget get _subTitleError => widget.subTitleError;
  EdgeInsetsGeometry get _paddingWidget => widget.paddingWidget;
  EdgeInsetsGeometry get _marginEachField => widget.marginEachField;
  MainAxisAlignment get _mainAxisRowFiedls => widget.mainAxisRowFiedls;
  double get _heightField => widget.heightField;
  double get _widthField => widget.widthField;
  BoxDecoration get _defaultFieldBoxDecoration => widget.defaultFieldBoxDecoration;
  BoxDecoration get _errorFieldBoxDecoration => widget.errorFieldBoxDecoration;
  TextStyle get _styleOfChildField => widget.styleOfChildField;
  FormFieldValidator<String>? get _validator => widget.validator;
  TextEditingController get _textEditingController => widget.textEditingController;
  FocusNode get _focusNode => widget.focusNode;
  GlobalKey<FormState> get _formStateGlobalKey => widget.formStateglobalKey;

  int selectedIndex = 0;
  List<String> inputList = [];
  bool autoDismissKeyboard = true;
  bool enableEdit = false;

  void _setTextToInput(String data) {
    var replaceInputList = List<String>.filled(_length, '');

    for (var i = 0; i < _length; i++) {
      replaceInputList[i] = data.length > i ? data[i] : "";
    }

    if (mounted) {
      setState(() {
        selectedIndex = data.length;
        inputList = replaceInputList;
      });
    }
  }

  void _textEditingControllerListenerRoutines() {
    _textEditingController.addListener(() {
      var _currentText = _textEditingController.text;

      if (_currentText.length < _length) {
        enableEdit = false;
      }

      if ((autoDismissKeyboard && _currentText.length == _length) && enableEdit == false) {
        _focusNode.unfocus();
      }

      _setTextToInput(_currentText);
    });
  }

  void _onFocus() {
    if (_focusNode.hasFocus && MediaQuery.of(context).viewInsets.bottom == 0) {
      _focusNode.unfocus();
      Future.delayed(const Duration(microseconds: 1), () => _focusNode.requestFocus());
    } else {
      _focusNode.requestFocus();
    }
  }

  @override
  void initState() {
    super.initState();
    inputList = List<String>.filled(_length, '');
    currentText = '';
    _focusNode.addListener(() {
      setState(() {});
    });

    _textEditingControllerListenerRoutines();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _paddingWidget,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _isStateError ? _titleError : _title,
          const SizedBox(
            height: 10,
          ),
          Stack(
            children: [
              GestureDetector(
                onTap: () {
                  if (currentText.length == _length) {
                    enableEdit = true;
                  } else {
                    enableEdit = false;
                  }
                  _onFocus();
                },
                child: Row(
                  mainAxisAlignment: _mainAxisRowFiedls,
                  children: generateFields(),
                ),
              ),
              buildTextFormField(),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          _isStateError ? _subTitleError : _subTitle,
        ],
      ),
    );
  }

  Widget buildTextFormField() {
    return AbsorbPointer(
      absorbing: false,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        color: Colors.transparent,
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Form(
            key: _formStateGlobalKey,
            child: TextFormField(
              selectionControls: CustomColorSelectionHandle(Colors.transparent),
              controller: _textEditingController,
              focusNode: _focusNode,
              autocorrect: false,
              keyboardType: TextInputType.number,
              textCapitalization: TextCapitalization.none,
              validator: _validator,
              inputFormatters: [LengthLimitingTextInputFormatter(6)],
              enableInteractiveSelection: true,
              cursorWidth: 2,
              showCursor: false,
              scrollPadding: EdgeInsets.zero,
              toolbarOptions: ToolbarOptions(
                paste: true,
              ),
              onChanged: (value) {
                currentText = value;
                print(currentText);
              },
              cursorColor: Colors.transparent,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(0),
                border: InputBorder.none,
                fillColor: Colors.transparent,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
              ),
              style: const TextStyle(
                color: Colors.yellow,
                height: 0.01,
                fontSize: 0.01,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> generateFields() {
    var result = <Widget>[];
    for (var i = 0; i < _length; i++) {
      var widget = Container(
        margin: _marginEachField,
        height: _heightField,
        width: _widthField,
        decoration: _isStateError ? _errorFieldBoxDecoration : _defaultFieldBoxDecoration,
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

class CustomColorSelectionHandle extends TextSelectionControls {
  CustomColorSelectionHandle(this.handleColor)
      : _controls = Platform.isIOS ? cupertinoTextSelectionControls : materialTextSelectionControls;

  final Color handleColor;
  final TextSelectionControls _controls;

  /// Wrap the given handle builder with the needed theme data for
  /// each platform to modify the color.
  Widget _wrapWithThemeData(Widget Function(BuildContext) builder) => Platform.isIOS
      // ios handle uses the CupertinoTheme primary color, so override that.
      ? CupertinoTheme(data: CupertinoThemeData(primaryColor: handleColor), child: Builder(builder: builder))
      // material handle uses the selection handle color, so override that.
      : TextSelectionTheme(
          data: TextSelectionThemeData(selectionHandleColor: handleColor), child: Builder(builder: builder));

  @override
  Widget buildHandle(
    BuildContext context,
    TextSelectionHandleType type,
    double textLineHeight, [
    VoidCallback? onTap,
    double? startGlyphHeight,
    double? endGlyphHeight,
  ]) {
    return _wrapWithThemeData((BuildContext context) => _controls.buildHandle(context, type, textLineHeight));
  }

  @override
  Widget buildToolbar(
      BuildContext context,
      Rect globalEditableRegion,
      double textLineHeight,
      Offset position,
      List<TextSelectionPoint> endpoints,
      TextSelectionDelegate delegate,
      ClipboardStatusNotifier clipboardStatus,
      Offset? lastSecondaryTapDownPosition) {
    return _controls.buildToolbar(
      context,
      globalEditableRegion,
      textLineHeight,
      position,
      endpoints,
      delegate,
      clipboardStatus,
      lastSecondaryTapDownPosition,
    );
  }

  @override
  Offset getHandleAnchor(
    TextSelectionHandleType type,
    double textLineHeight, [
    double? startGlyphHeight,
    double? endGlyphHeight,
  ]) {
    return _controls.getHandleAnchor(type, textLineHeight, startGlyphHeight, endGlyphHeight);
  }

  @override
  Size getHandleSize(double textLineHeight) {
    return _controls.getHandleSize(textLineHeight);
  }
}
