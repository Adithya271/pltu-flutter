import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DashboardUserShowType extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String description;
  final String content;

  const DashboardUserShowType({
    Key? key,
    required this.imageUrl,
    required this.name,
    required this.description,
    required this.content,
  }) : super(key: key);

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
            HtmlWidget(
              content,
              textStyle: const TextStyle(fontSize: 16.0),
              customWidgetBuilder: (element) {
                if (element.localName == 'iframe' &&
                    element.attributes['src'] != null &&
                    element.attributes['src']!.contains('youtube.com')) {
                  final videoUrl = element.attributes['src']!;
                  final youtubeId = YoutubePlayer.convertUrlToId(videoUrl);
                  if (youtubeId != null) {
                    return YoutubePlayer(
                      controller: YoutubePlayerController(
                        initialVideoId: youtubeId,
                        flags: const YoutubePlayerFlags(
                          autoPlay: false,
                          mute: false,
                        ),
                      ),
                      showVideoProgressIndicator: true,
                    );
                  }
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}
