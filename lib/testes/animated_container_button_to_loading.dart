import 'package:flutter/material.dart';

class AnimatedContainerButtonToLoading extends StatefulWidget {
  const AnimatedContainerButtonToLoading({Key? key}) : super(key: key);

  @override
  State<AnimatedContainerButtonToLoading> createState() => _AnimatedContainerButtonToLoadingState();
}

class _AnimatedContainerButtonToLoadingState extends State<AnimatedContainerButtonToLoading> {
  double width = 100;
  bool isLoading = false;
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                isLoading = !isLoading;
              });
            },
            child: Center(
              child: AnimatedContainer(
                width: isLoading ? 38 : 300,
                height: isLoading ? 38 : 38,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: isLoading ? Colors.transparent : Colors.yellow,
                ),
                alignment: isLoading ? Alignment.center : AlignmentDirectional.topCenter,
                duration: const Duration(milliseconds: 1000),
                curve: Curves.easeIn,
                child: isLoading
                    ? CircularProgressIndicator(
                        color: Colors.yellow,
                      )
                    : Center(child: Text('login')),
              ),
            ),
          ),
          // AnimatedContainer(
          //   curve: Curves.easeIn,
          //   duration: Duration(seconds: 5),
          //   width: isLoading ? 50 : width,
          //   child: isLoading
          //       ? const CircularProgressIndicator()
          //       : ElevatedButton(
          //           onPressed: () {
          //             setState(() {
          //               // width = 10;
          //               isLoading = true;
          //             });
          //           },
          //           child: Text('LoginTeste'),
          //         ),
          // )
        ],
      ),
    );
  }
}
