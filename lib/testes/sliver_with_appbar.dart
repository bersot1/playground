import 'package:flutter/material.dart';

class SliverWithAppbar extends StatefulWidget {
  const SliverWithAppbar({Key? key}) : super(key: key);

  @override
  _SliverWithAppbarState createState() => _SliverWithAppbarState();
}

class _SliverWithAppbarState extends State<SliverWithAppbar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('teste'),
      ),
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, value) {
            return [
              SliverAppBar(
                pinned: true,
                floating: true,
                expandedHeight: 300,
                flexibleSpace: FlexibleSpaceBar(
                  background: Column(
                    children: [
                      Text('123'),
                      Text('123'),
                      Text('123'),
                      Text('123'),
                      Text('123'),
                      Text('123'),
                      Text('123'),
                      Text('123'),
                      Text('123'),
                      Text('123'),
                      Text('123'),
                      Text('123'),
                      Text('123'),
                    ],
                  ),
                ),
                bottom: TabBar(
                  tabs: [
                    Tab(icon: Icon(Icons.call), text: "Call"),
                    Tab(icon: Icon(Icons.message), text: "Message"),
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              Tab1(),
              Tab2(),
            ],
          ),
        ),
      ),
    );
  }
}

class Tab1 extends StatelessWidget {
  const Tab1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Tab1"),
    );
  }
}

class Tab2 extends StatelessWidget {
  const Tab2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Tab1"),
    );
  }
}
