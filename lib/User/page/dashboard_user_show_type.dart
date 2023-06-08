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
              child: VideoPlayerWidget(
                videoUrl: videoUrl,
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

  @override
  void initState() {
    super.initState();
    _chewieController = ChewieController(
      videoPlayerController: VideoPlayerController.network(widget.videoUrl),
      autoPlay: false,
      looping: true,
    );
  }

  @override
  void dispose() {
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Chewie(
      controller: _chewieController,
    );
  }
}
