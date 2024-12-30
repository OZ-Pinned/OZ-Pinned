import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class MeditationVideoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MeditationVideoList(),
    );
  }
}

class MeditationVideoList extends StatelessWidget {
  final List<Map<String, String>> videoList = [
    {'title': '명상 영상 1', 'id': 'dZewQEbQQM0'},
    {'title': '명상 영상 2', 'id': 'a2FzNABF6kY'},
    {'title': '명상 영상 3', 'id': 'xvFZjo5PgG0'},
  ];

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

  const MeditationVideoPlayer({required this.videoId});

  @override
  _MeditationVideoPlayerState createState() => _MeditationVideoPlayerState();
}

class _MeditationVideoPlayerState extends State<MeditationVideoPlayer> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      params: YoutubePlayerParams(
        startAt: const Duration(seconds: 10), // 10초 후 시작
        showControls: false, // 기본 컨트롤 숨기기
        showFullscreenButton: false,
      ),
    );
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
                  final currentTime = await _controller.currentTime;
                  _controller.seekTo(currentTime - 10);
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
                onPressed: () async {
                  final isPlaying = await _controller.isPlaying();
                  if (isPlaying) {
                    _controller.pauseVideo();
                  } else {
                    _controller.playVideo();
                  }
                },
                child: Row(
                  children: [
                    Icon(Icons.play_arrow),
                    SizedBox(width: 5),
                    Text("재생/일시정지"),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  // 현재 시간에서 10초 앞으로
                  final currentTime = await _controller.currentTime;
                  _controller.seekTo(currentTime + 10);
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
              _controller.enterFullscreen();
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
