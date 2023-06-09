import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class DashboardUserShowType extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String content;
  final String videoUrl;

  const DashboardUserShowType({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.content,
    required this.videoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.network(
              imageUrl,
              width: 400,
              height: 200,
              fit: BoxFit.cover,
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: 400,
              height: 200,
              child: AspectRatio(
                aspectRatio: 1.0, // 1:1 aspect ratio
                child: VideoPlayerWidget(
                  videoUrl: videoUrl,
                ),
              ),
            ),

            const SizedBox(height: 16.0),
            Html(
              data: content,
              style: {
                'p': Style(fontSize: const FontSize(16.0)),
                'img': Style(
                  width: double.infinity,
                  height: double.infinity,
                  margin: const EdgeInsets.all(0),
                  padding: const EdgeInsets.all(0),
                ),
                'iframe': Style(
                  width: double.infinity,
                  height: 200.0,
                ),
              },
            ),

            // Add any other UI components you need
          ],
        ),
      ),
    );
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
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _chewieController = ChewieController(
      videoPlayerController: VideoPlayerController.network(widget.videoUrl),
      autoPlay: false,
      looping: true,
    );

    _chewieController.addListener(_videoPlayerListener);
    _initializeVideoPlayer();
  }

  @override
  void dispose() {
    _chewieController.dispose();
    super.dispose();
  }

  void _initializeVideoPlayer() async {
    await _chewieController.videoPlayerController.initialize();
    setState(() {
      _isLoading = false;
    });
  }

  void _videoPlayerListener() {
    if (_chewieController.videoPlayerController.value.isInitialized &&
        !_chewieController.videoPlayerController.value.isPlaying) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Chewie(
          controller: _chewieController,
        ),
        if (_isLoading)
          const Center(
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }
}
