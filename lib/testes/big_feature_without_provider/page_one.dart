import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playground/testes/big_feature_without_provider/bloc/big_feature_bloc.dart';
import 'package:playground/testes/big_feature_without_provider/bloc/big_feature_event.dart';
import 'package:playground/testes/big_feature_without_provider/bloc/big_feature_state.dart';
import 'package:playground/testes/big_feature_without_provider/page_two.dart';

class PageOneScreen extends StatefulWidget {
  const PageOneScreen({Key? key}) : super(key: key);

  @override
  State<PageOneScreen> createState() => _PageOneScreenState();
}

class _PageOneScreenState extends State<PageOneScreen> {
  late BigFeatureBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BigFeatureBloc();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BigFeatureBloc(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BlocBuilder<BigFeatureBloc, IBigFeatureState>(
                  bloc: _bloc,
                  builder: (context, state) {
                    return Row(
                      children: [
                        if (state is BigFeatureLoadingPageOneState) const CircularProgressIndicator(),
                        if (state is BigFeatureSuccessPageOneState) Text(state.result),
                        Text(_bloc.test ?? 'non'),
                      ],
                    );
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    _bloc.add(BigFeatureGetDataPageOneEvent());
                  },
                  child: Text('start'),
                ),
                const Text('Page one'),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push<void>(
                      PageTwoScreen.route(
                        context.read<BigFeatureBloc>(),
                      ),
                    );
                  },
                  child: Text('Go to page two'),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

// gerencimento de estado
// validar se o ecra atual nao vai alterar o antigo
