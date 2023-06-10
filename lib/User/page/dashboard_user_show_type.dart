import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class DashboardUserShowType extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String description;
  final String content;
  final String videoUrl;

  const DashboardUserShowType({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.description,
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
