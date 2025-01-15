import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MeditationVideoList extends StatelessWidget {
  final List<Map<String, String>> videoList = [
    {
      'title': '명상 영상 1',
      'path':
          'assets/videos/5MinutesOfGuidedMeditationForLettingGoOfAngerSELF.mp3'
    },
    {
      'title': '명상 영상 2',
      'path': 'assets/videos/8MinutesofSelfForgivenessGuidedMeditationSELF.mp3'
    },
    {
      'title': '명상 영상 3',
      'path':
          'assets/videos/5MinutesOfGuidedMeditationForLettingGoOfAngerSELF.mp3'
    },
  ];

  MeditationVideoList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('명상 영상 리스트'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: videoList.map((video) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MeditationVideoPlayer(videoPath: video['path']!),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.all(8.0),
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    video['title']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class MeditationVideoPlayer extends StatefulWidget {
  final String videoPath;

  const MeditationVideoPlayer({super.key, required this.videoPath});

  @override
  _MeditationVideoPlayerState createState() => _MeditationVideoPlayerState();
}

class _MeditationVideoPlayerState extends State<MeditationVideoPlayer> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoPath)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('명상 영상 재생'),
      ),
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MeditationVideoList(),
  ));
}
