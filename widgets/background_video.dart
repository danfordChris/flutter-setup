import 'package:flutter/material.dart';
import 'package:solomon/core/resources/resources.dart';
import 'package:video_player/video_player.dart';

class BackgroundVideo extends StatefulWidget {
  const BackgroundVideo({super.key});

  @override
  State<BackgroundVideo> createState() => _BackgroundVideoState();
}

class _BackgroundVideoState extends State<BackgroundVideo> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    _initializePage();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _initializePage() async {
    _controller =
        VideoPlayerController.asset(
            Videos.backgroundVideo,
            videoPlayerOptions: VideoPlayerOptions(
              mixWithOthers: true,
            ),
          )
          ..initialize().then((_) {
            _controller
              ..setVolume(0.0)
              ..setLooping(true)
              ..play();

            setState(() {});
          });
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _controller.value.isInitialized,
      child: AspectRatio(aspectRatio: MediaQuery.sizeOf(context).width / MediaQuery.sizeOf(context).height, child: VideoPlayer(_controller)),
    );
  }
}
