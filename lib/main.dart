import 'package:flutter/material.dart';
import 'package:playground/testes/gradient_image.dart';

import 'testes/code_input.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isError = false;
  TextEditingController textEditingController = TextEditingController();
  GlobalKey<FormState> formStateKey = GlobalKey<FormState>();
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 100,
            ),
            CodeInput(
              focusNode: focusNode,
              formStateglobalKey: formStateKey,
              textEditingController: textEditingController,
              validator: (value) {
                if (value == '123456') {
                  isError = true;
                  setState(() {});
                }
              },
              isStateError: isError,
              lenght: 6,
              title: const Text('Enter your activation code'),
              subTitle: const Text('You have 3 attempts. The code is valid for 20min'),
              titleError: const Text(
                'Enter your activation code',
                style: TextStyle(color: Colors.red),
              ),
              subTitleError: Row(
                children: const [
                  Icon(
                    Icons.error,
                    color: Colors.red,
                    size: 13,
                  ),
                  Flexible(
                    child: Text(
                      'The code is incorrect.Please verify or request a new one.',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: Container()),
            OutlinedButton(
              onPressed: () {
                if (formStateKey.currentState!.validate()) {
                  print('error');
                } else {
                  print('done');
                }
              },
              child: Text('1234'),
            )
          ],
        ),
      ),
    );
  }
}
