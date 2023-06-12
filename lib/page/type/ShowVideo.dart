import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class ShowVideo extends StatelessWidget {
  final String nama;
  final String videoUrl;

  const ShowVideo({Key? key, required this.nama, required this.videoUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(nama),
        ),
        body: SizedBox(
          width: 150,
          height: 200,
          child: AspectRatio(
            aspectRatio: 1.0, // 1:1 aspect ratio
            child: VideoPlayerWidget(
              videoUrl: videoUrl,
            ),
          ),
        ));
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerWidget({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late ChewieController _chewieController;
  bool _isVideoInitialized = false;
  bool _isVideoPlaying = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  @override
  void dispose() {
    _chewieController.dispose();
    super.dispose();
  }

  Future<void> _initializeVideoPlayer() async {
    final videoPlayerController =
        VideoPlayerController.network(widget.videoUrl);
    await videoPlayerController.initialize();

    setState(() {
      _chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
        autoPlay: false,
        looping: true,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Text(
              errorMessage,
              style: const TextStyle(color: Colors.white),
            ),
          );
        },
      );
      _isVideoInitialized = true;
    });
  }

  void _onVideoPlay() {
    setState(() {
      _isVideoPlaying = true;
    });
  }

  void _onVideoPause() {
    setState(() {
      _isVideoPlaying = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (_isVideoInitialized)
          Chewie(
            controller: _chewieController,
          )
        else
          const Center(
            child: CircularProgressIndicator(),
          ),
        if (!_isVideoPlaying && _isVideoInitialized)
          GestureDetector(
            onTap: _onVideoPlay,
            child: Container(
              color: Colors.transparent,
              child: const Center(
                child: Icon(
                  Icons.play_arrow,
                  size: 64,
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
