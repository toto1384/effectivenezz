import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class GYoutubePlayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: YoutubePlayer(
        controller: YoutubePlayerController(
            initialVideoId: 'qh9czFNGDBc',
            flags: YoutubePlayerFlags(
              autoPlay: false,
            )
        ),
        showVideoProgressIndicator: true,
      ),
    );
  }
}
