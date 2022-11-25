import 'package:flutter/material.dart';

class GradientImage extends StatefulWidget {
  const GradientImage({Key? key}) : super(key: key);

  @override
  State<GradientImage> createState() => _GradientImageState();
}

class _GradientImageState extends State<GradientImage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: const [],
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Container(
              color: Colors.blue,
              width: double.infinity,
              height: 550,
              child: Image.asset(
                'lib/asset/add_agreement.webp',
                fit: BoxFit.fill,
              ),
            ),
            Positioned(
              bottom: 130,
              child: Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                      // boxShadow: [
                      //   BoxShadow(
                      //     blurRadius: 2, color: Colors.transparent,
                      //     // offset: Offset(2, 1),
                      //   )
                      // ],
                      // gradient: LinearGradient(
                      //   begin: Alignment.topCenter,
                      //   end: Alignment.bottomCenter,
                      //   colors: [
                      //     Colors.transparent,
                      //     Colors.white,
                      //   ],
                      // ),
                      ),
                  child: Column()),
            ),
            Positioned(
              bottom: 130,
              child: Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    // boxShadow: [
                    //   BoxShadow(
                    //     blurRadius: 2, color: Colors.transparent,
                    //     // offset: Offset(2, 1),
                    //   )
                    // ],
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: const [
                        Colors.transparent,
                        Colors.white,
                      ],
                    ),
                  ),
                  child: Column()),
            ),
            // Positioned(
            //   bottom: 130,
            //   child: Container(
            //       height: 200,
            //       width: MediaQuery.of(context).size.width,
            //       decoration: BoxDecoration(
            //         color: Colors.white,
            //         // boxShadow: [
            //         //   BoxShadow(
            //         //     blurRadius: 2, color: Colors.transparent,
            //         //     // offset: Offset(2, 1),
            //         //   )
            //         // ],
            //         gradient: LinearGradient(
            //           begin: Alignment.topCenter,
            //           end: Alignment.bottomCenter,
            //           colors: [
            //             Colors.transparent,
            //             Colors.white,
            //           ],
            //         ),
            //       ),
            //       child: Column()),
            // ),
            // Positioned(
            //   bottom: 130,
            //   child: Container(
            //       height: 200,
            //       width: MediaQuery.of(context).size.width,
            //       decoration: BoxDecoration(
            //         color: Colors.white,
            //         // boxShadow: [
            //         //   BoxShadow(
            //         //     blurRadius: 2, color: Colors.transparent,
            //         //     // offset: Offset(2, 1),
            //         //   )
            //         // ],
            //         gradient: LinearGradient(
            //           begin: Alignment.topCenter,
            //           end: Alignment.bottomCenter,
            //           colors: [
            //             Colors.transparent,
            //             Colors.white,
            //           ],
            //         ),
            //       ),
            //       child: Column()),
            // ),
            // Positioned(
            //   bottom: 0,
            //   child: Container(
            //       height: 50,
            //       width: MediaQuery.of(context).size.width,
            //       decoration: const BoxDecoration(
            //         color: Colors.white,
            //         // boxShadow: [
            //         //   BoxShadow(
            //         //     blurRadius: 2, color: Colors.transparent,
            //         //     // offset: Offset(2, 1),
            //         //   )
            //         // ],
            //         gradient: LinearGradient(
            //           begin: Alignment.topCenter,
            //           end: Alignment.bottomCenter,
            //           tileMode: TileMode.mirror,
            //           colors: [
            //             Colors.white,
            //             Colors.transparent,
            //           ],
            //         ),
            //       ),
            //       child: Column()),
            // ),
            Positioned(
              bottom: 0,
              child: Container(
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Center(child: Text('Easily access your agreement 24/7')),
                    const Center(
                      child: Text(
                          'Check yout monthly payment dates and get daster access to your financial services via the My BMW app'),
                    ),
                    const Divider(),
                    Center(child: ElevatedButton(onPressed: () {}, child: const Text('ADD AGREEMENT')))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// child: Column(
//                   children: [
//                     SizedBox(
//                       height: 100,
//                     ),
//                     Text('Easily access your agreement 24/7'),
//                     Text(
//                         'Check yout monthly payment dates and get daster access to your financial services via the My BMW app'),
//                     Divider(),
//                     ElevatedButton(onPressed: () {}, child: Text('ADD AGREEMENT'))
//                   ],
//                 ),