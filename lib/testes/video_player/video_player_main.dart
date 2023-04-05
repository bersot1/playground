import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerMain extends StatefulWidget {
  const VideoPlayerMain({Key? key}) : super(key: key);

  @override
  State<VideoPlayerMain> createState() => _VideoPlayerMainState();
}

class _VideoPlayerMainState extends State<VideoPlayerMain> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    _controller = VideoPlayerController.network(
        'https://videos.bcsgarcia.com.br/video_1.mp4')
      ..initialize().then((_) {
        setState(() {});
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : Container(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}
