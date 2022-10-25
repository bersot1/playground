import 'package:flutter/material.dart';

class ImageBehindBodyRadiusSliver extends StatelessWidget {
  const ImageBehindBodyRadiusSliver({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image(
          width: double.infinity,
          image: AssetImage("lib/asset/img_loaction_raw@3x.png"),
          fit: BoxFit.cover,
        ),
        DraggableScrollableSheet(
            maxChildSize: 0.75,
            minChildSize: 0.5,
            builder: (context, scrollController) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration:
                    BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: [
                      Text('123'),
                      Text('123'),
                      Text('123'),
                      Text('123'),
                      SizedBox(height: 100),
                      Text('123'),
                      Text('123'),
                      Text('123'),
                      SizedBox(height: 100),
                      Text('123'),
                      Text('123'),
                      Text('123'),
                      SizedBox(height: 100),
                      Text('123'),
                      Text('123'),
                      Text('123'),
                      SizedBox(height: 100),
                      Text('123'),
                      Text('123'),
                      Text('123'),
                      SizedBox(height: 100),
                      Text('123'),
                      Text('123'),
                      Text('123'),
                      SizedBox(height: 100),
                      Text('123'),
                      Text('123'),
                    ],
                  ),
                ),
              );
            })
      ],
    );
    // CustomScrollView(
    //   slivers: [
    //     SliverAppBar(
    //       backgroundColor: Colors.transparent,
    //       elevation: 0,
    //       floating: true,
    //       pinned: true,
    //       stretch: true,
    //       expandedHeight: 450,
    //       leading: IconButton(
    //         icon: Icon(
    //           Icons.chevron_left,
    //           color: Colors.yellow,
    //         ),
    //         onPressed: () {},
    //       ),
    //       shape: ContinuousRectangleBorder(
    //           borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))),
    //       flexibleSpace: FlexibleSpaceBar(
    //         background: Image.asset(
    //           'lib/asset/img_loaction_raw@3x.png',
    //           fit: BoxFit.cover,
    //         ),
    //       ),
    //     ),
    //     SliverFillRemaining(
    //       child: Column(
    //         children: [
    //           Center(
    //             child: Text('SliverFillRemaining'),
    //           ),
    //         ],
    //       ),
    //     )
    //   ],
    // );

    // SizedBox(
    //   height: MediaQuery.of(context).size.height,
    //   width: MediaQuery.of(context).size.width,
    //   child: Stack(
    //     children: [
    //       Container(
    //         height: 450,
    //         width: double.infinity,
    //         color: Colors.red,
    //         child: Text('teste'),
    //       ),
    //       Positioned(
    //         top: 400,
    //         bottom: 0,
    //         left: 0,
    //         right: 0,
    //         child: Container(
    //           decoration: const BoxDecoration(
    //             color: Color(0xfff5f5f5),
    //             borderRadius: BorderRadius.only(
    //               topLeft: Radius.circular(40),
    //               topRight: Radius.circular(40),
    //             ),
    //           ),
    //           child: ListView(
    //             children: [
    //               Text('1'),
    //               Text('1'),
    //               Text('1'),
    //               Text('1'),
    //               Text('1'),
    //               Text('1'),
    //               Text('1'),
    //               Text('1'),
    //               Text('1'),
    //               Text('1'),
    //               Text('1'),
    //             ],
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
