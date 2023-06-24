import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ShowContent extends StatelessWidget {
  final String nama;
  final String content;

  const ShowContent({required this.nama, required this.content, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(nama),
      ),
      body: SingleChildScrollView(
        controller: ScrollController(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
      ),
    );
  }
}
