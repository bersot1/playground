import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playground/testes/big_feature_without_provider/bloc/big_feature_event.dart';

import 'bloc/big_feature_bloc.dart';

class PageThreeScreen extends StatefulWidget {
  const PageThreeScreen({Key? key}) : super(key: key);

  static Route route(BigFeatureBloc bigFeatureBloc) {
    return MaterialPageRoute<void>(
      builder: (_) => BlocProvider.value(
        value: bigFeatureBloc,
        child: PageThreeScreen(),
      ),
    );
  }

  @override
  State<PageThreeScreen> createState() => _PageThreeScreenState();
}

class _PageThreeScreenState extends State<PageThreeScreen> {
  late BigFeatureBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<BigFeatureBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ElevatedButton(
          child: Text('Get Data'),
          onPressed: () {
            _bloc.add(BigFeatureGetDataPageThreeEvent());
          },
        ),
      ),
    );
  }
}
