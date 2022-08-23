import 'package:flutter/material.dart';

class DraftPage extends StatefulWidget {
  const DraftPage({Key? key}) : super(key: key);

  @override
  State<DraftPage> createState() => _DraftPageState();
}

class _DraftPageState extends State<DraftPage> {
  late Map<String, dynamic> returnJson;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    _getData();
  }

  Future<void> _getData() async {
    await Future.delayed(const Duration(seconds: 5));

    returnJson = {
      'widget': 'Text',
    };

    final test = returnJson['widget'] as Widget;

    print(test.runtimeType);

    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(extendBodyBehindAppBar: true, body: Text('123'));
  }
}
