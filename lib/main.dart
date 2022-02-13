import 'package:flutter/material.dart';
import 'package:playground/bloc/search_cep_view.dart';
import 'package:playground/testes/custom_painter.dart';
import 'package:playground/testes/listview_automatic.dart';
import 'package:playground/testes/sliver_with_appbar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SearchCepBLocView(),
    );
  }
}
