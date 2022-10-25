import 'package:flutter/material.dart';

class SliverView extends StatefulWidget {
  const SliverView({Key? key}) : super(key: key);

  @override
  _SliverViewState createState() => _SliverViewState();
}

class _SliverViewState extends State<SliverView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // SliverAppBar(
          //   floating: true,
          //   pinned: true,
          //   stretch: true,
          //   expandedHeight: 300,
          //   flexibleSpace: FlexibleSpaceBar(
          //     title: Text('SliverAppBar'),
          //     background: Column(
          //       children: [
          //         Text('123'),
          //         Text('123'),
          //         Text('123'),
          //         Text('123'),
          //         Text('123'),
          //         Text('123'),
          //         Text('123'),
          //         Text('123'),
          //         Text('123'),
          //         Text('123'),
          //         Text('123'),
          //       ],
          //     ),
          //   ),
          // ),
          SliverFillRemaining(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 50,
                        color: Colors.red,
                        child: Text('AAAAA'),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 50,
                        color: Colors.red,
                        child: Text('AAAAA'),
                      ),
                    ),
                  ],
                ),
                Center(
                  child: Text('SliverFillRemaining'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
