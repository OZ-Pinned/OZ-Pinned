import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:video_player/video_player.dart';

class MeditationVideoList extends StatelessWidget {
  final List<Map<String, dynamic>> videoList = [
    {
      'section': '명상 가이드',
      'videos': [
        {
          'title': '생각을 비우는 방법',
          'image': 'assets/images/image1.svg',
          'video': 'assets/videos/video1.mp3',
        },
        {
          'title': '마음이 평온해지는 스트레스 감소 명상',
          'image': 'assets/images/image2.svg',
          'video': 'assets/videos/video1.mp3',
        }
      ]
    },
    {
      'section': '힐링 자연의 소리',
      'videos': [
        {
          'title': '흥분된 마음을 진정시키는 물소리',
          'image': 'assets/images/image3.svg',
          'video': 'assets/videos/video2.mp3',
        },
        {
          'title': '머리가 맑아지는 숲 속 치유음악',
          'image': 'assets/images/image4.svg',
          'video': 'assets/videos/video2.mp3',
        }
      ]
    },
    {
      'section': '따듯한 장작타는 소리',
      'videos': [
        {
          'title': '포근한 메리크리스마스 수면 음악',
          'image': 'assets/images/image5.svg',
          'video': 'assets/videos/video3.mp3',
        },
        {
          'title': '굳은 몸을 녹여주는 따뜻한 장작타는 소리',
          'image': 'assets/images/image6.svg',
          'video': 'assets/videos/video3.mp3',
        }
      ]
    }
  ];

  MeditationVideoList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('코코의 추천 명상'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: videoList.map((section) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    section['section'],
                    style: TextStyle(fontSize: 24, fontFamily: 'LeeSeoYun'),
                  ),
                  SizedBox(height: 8),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // 한 줄에 2개의 아이템
                      childAspectRatio: 3 / 4, // 아이템의 가로 세로 비율
                      mainAxisSpacing: 8, // 세로 간격
                      crossAxisSpacing: 8, // 가로 간격
                    ),
                    itemCount: section['videos'].length,
                    itemBuilder: (context, videoIndex) {
                      final video = section['videos'][videoIndex];
                      return GestureDetector(
                        onTap: () {
                          // 비디오 클릭 시, 재생 페이지로 이동
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MeditationVideoPlayer(
                                videoPath: video['video'],
                              ),
                            ),
                          );
                        },
                        child: Card(
                          child: Column(
                            children: [
                              Expanded(
                                child: SvgPicture.asset(
                                  'assets/images/image1.svg',
                                  width: 153,
                                  height: 153,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  video['title'],
                                  style: TextStyle(
                                      fontFamily: 'LeeSeoYun', fontSize: 18),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 16), // 섹션 간 간격
                ],
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
  bool play = true;

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
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : const CircularProgressIndicator(),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    _controller.seekTo(
                        _controller.value.position - Duration(seconds: 10));
                  },
                  icon: SvgPicture.asset(
                    'assets/images/beforeTenButton.svg',
                    width: 40,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    play = !play;
                    if (play) {
                      _controller.play();
                    } else {
                      _controller.pause();
                    }
                    setState(() {});
                  },
                  icon: SvgPicture.asset(
                    play
                        ? 'assets/images/stopButton.svg'
                        : 'assets/images/playButton.svg',
                    width: 40,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _controller.seekTo(
                        _controller.value.position + Duration(seconds: 10));
                  },
                  icon: SvgPicture.asset(
                    'assets/images/afterTenButton.svg',
                    width: 40,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
