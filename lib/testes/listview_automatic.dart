import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class ListViewAumatic extends StatefulWidget {
  const ListViewAumatic({Key? key}) : super(key: key);

  @override
  _ListViewAumaticState createState() => _ListViewAumaticState();
}

class _ListViewAumaticState extends State<ListViewAumatic> {
  late Timer timer;
  List<String> list = [];

  final ScrollController _scrollController = ScrollController();

  _scrollToBottom() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  addArrayItem() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final randomText = Random();
      list.add(randomText.nextInt(100).toString());
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    // addArrayItem();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: list.length,
        itemBuilder: (context, i) {
          final item = list[i];
          return Container(
            margin: const EdgeInsets.all(8),
            height: 50,
            width: double.infinity,
            color: Colors.red,
            child: Text(item),
          );
        },
      ),
    );
  }
}
