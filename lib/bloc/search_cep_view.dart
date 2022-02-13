import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playground/bloc/search_cep_bloc.dart';
import 'package:playground/bloc/search_cep_bloc_rxdart.dart';
import 'package:playground/bloc/search_cep_states.dart';
import 'package:playground/bloc/search_cep_with_flutter_bloc.dart';

class SearchCepBLocView extends StatefulWidget {
  const SearchCepBLocView({Key? key}) : super(key: key);

  @override
  _SearchCepBLocViewState createState() => _SearchCepBLocViewState();
}

class _SearchCepBLocViewState extends State<SearchCepBLocView> {
  final TextEditingController controller = TextEditingController();

  final streamSearchBloc = SearchCepBlocFlutterBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CEP'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'CEP',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () => streamSearchBloc.add('29105670'),
                child: const Text('Buscar'),
              ),
            ),
            // StreamBuilder(
            //   stream: streamSearchBloc.cepResult,
            //   builder: (context, snapshot) {
            //     if (snapshot.hasError) {
            //       return Text(
            //         '${snapshot.error}',
            //         style: TextStyle(color: Colors.red),
            //       );
            //     }

            //     if (!snapshot.hasData) return Container();

            //     if (snapshot.connectionState == ConnectionState.waiting) {
            //       return const Expanded(child: CircularProgressIndicator());
            //     }

            //     return Text("Cidade: ${snapshot.data}");
            //   },
            // ),

            // StreamBuilder<ISearchCepStatus>(
            //   stream: streamSearchBloc.cepResult,
            //   builder: (context, snapshot) {
            //     if (!snapshot.hasData) return Container();

            //     var state = snapshot.data;

            //     if (state is SearchCepError) {
            //       return Text(state.message);
            //     }

            //     if (state is SearchCepLoading) {
            //       return const Expanded(
            //           child: Center(child: CircularProgressIndicator()));
            //     }

            //     state = state as SearchCepSuccess;

            //     return Text(state.data['localidade']);
            //   },
            // ),

            BlocBuilder<SearchCepBlocFlutterBloc, ISearchCepStatus>(
              bloc: streamSearchBloc,
              builder: (context, state) {
                if (state is SearchCepError) {
                  return Text(state.message);
                }

                if (state is SearchCepLoading) {
                  return const Expanded(
                      child: Center(child: CircularProgressIndicator()));
                }

                state = state as SearchCepSuccess;

                return Text(state.data['localidade']);
              },
            )
          ],
        ),
      ),
    );
  }
}
