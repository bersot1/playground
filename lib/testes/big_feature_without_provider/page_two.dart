import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playground/testes/big_feature_without_provider/bloc/big_feature_bloc.dart';
import 'package:playground/testes/big_feature_without_provider/bloc/big_feature_event.dart';
import 'package:playground/testes/big_feature_without_provider/bloc/big_feature_state.dart';

class PageTwoScreen extends StatefulWidget {
  const PageTwoScreen({Key? key}) : super(key: key);

  static Route route(BigFeatureBloc bigFeatureBloc) {
    return MaterialPageRoute<void>(
      builder: (_) => BlocProvider.value(
        value: bigFeatureBloc,
        child: PageTwoScreen(),
      ),
    );
  }

  @override
  State<PageTwoScreen> createState() => _PageTwoScreenState();
}

class _PageTwoScreenState extends State<PageTwoScreen> {
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          BlocBuilder<BigFeatureBloc, IBigFeatureState>(
            bloc: _bloc,
            builder: (context, state) {
              return Row(
                children: [
                  if (state is BigFeatureSuccessPageOneState) Text(state.result),
                  Text(_bloc.test ?? "non"),
                ],
              );
            },
          ),
          const Text('Page Two'),
          ElevatedButton(
            onPressed: () {
              _bloc.add(BigFeatureGetDataPageOneEvent());
              // Navigator.of(context).push<void>(PageThreeScreen.route(_bloc));
            },
            child: Text('Go to Page Three'),
          ),
        ],
      ),
    );
  }
}
