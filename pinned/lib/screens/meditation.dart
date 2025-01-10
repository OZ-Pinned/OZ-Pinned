import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class MeditationVideoList extends StatelessWidget {
  final List<Map<String, String>> videoList = [
    {'title': '명상 영상 1', 'id': 'zAIZpNbYytI'},
    {'title': '명상 영상 2', 'id': 'LfrO8t8lsWU'},
    {'title': '명상 영상 3', 'id': 'xvFZjo5PgG0'},
  ];

  MeditationVideoList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('명상 영상 리스트'),
      ),
      body: ListView.builder(
        itemCount: videoList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(videoList[index]['title']!),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      MeditationVideoPlayer(videoId: videoList[index]['id']!),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class MeditationVideoPlayer extends StatefulWidget {
  final String videoId;

  const MeditationVideoPlayer({super.key, required this.videoId});

  @override
  _MeditationVideoPlayerState createState() => _MeditationVideoPlayerState();
}

class _MeditationVideoPlayerState extends State<MeditationVideoPlayer> {
  late YoutubePlayerController _controller;
  bool _isPlaying = false; // 재생 상태 관리

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      params: YoutubePlayerParams(
        mute: false,
        showControls: true,
        showFullscreenButton: true,
      ),
    );

    // 비디오 로드
    _controller.loadVideoById(videoId: widget.videoId);

    _controller.listen((event) {
      setState(() {
        _isPlaying = event.playerState == PlayerState.playing;
      });
    });
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('명상 영상 재생'),
      ),
      body: Column(
        children: [
          YoutubePlayerControllerProvider(
            controller: _controller,
            child: YoutubePlayerIFrame(
              aspectRatio: 16 / 9,
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () async {
                  // 현재 시간에서 10초 뒤로
                  final currentPosition = await _controller.currentTime;
                  _controller.seekTo(seconds: currentPosition - 10);
                },
                child: Row(
                  children: [
                    Icon(Icons.replay_10),
                    SizedBox(width: 5),
                    Text("10초 뒤로"),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_isPlaying) {
                    _controller.pauseVideo();
                  } else {
                    _controller.playVideo();
                  }
                },
                child: Row(
                  children: [
                    Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                    SizedBox(width: 5),
                    Text(_isPlaying ? "일시정지" : "재생"),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  // 현재 시간에서 10초 앞으로
                  final currentPosition = await _controller.currentTime;
                  _controller.seekTo(seconds: currentPosition + 10);
                },
                child: Row(
                  children: [
                    Icon(Icons.forward_10),
                    SizedBox(width: 5),
                    Text("10초 앞으로"),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _controller.enterFullScreen();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.fullscreen),
                SizedBox(width: 5),
                Text("풀스크린"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
