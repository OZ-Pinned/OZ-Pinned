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
          'image': 'assets/images/meditationImage1.png',
          'video': 'assets/videos/video1.mp3',
        },
        {
          'title': '마음이 평온해지는\n스트레스 감소 명상',
          'image': 'assets/images/meditationImage2.png',
          'video': 'assets/videos/video1.mp3',
        }
      ]
    },
    {
      'section': '힐링 자연의 소리',
      'videos': [
        {
          'title': '흥분된 마음을 진정시키는 물소리',
          'image': 'assets/images/meditationImage3.png',
          'video': 'assets/videos/video2.mp3',
        },
        {
          'title': '머리가 맑아지는\n 숲 속 치유음악',
          'image': 'assets/images/meditationImage4.png',
          'video': 'assets/videos/video2.mp3',
        }
      ]
    },
    {
      'section': '따듯한 장작타는 소리',
      'videos': [
        {
          'title': '포근한 메리크리스마스\n수면 음악',
          'image': 'assets/images/meditationImage5.png',
          'video': 'assets/videos/video3.mp3',
        },
        {
          'title': '굳은 몸을 녹여주는\n따뜻한 장작타는 소리',
          'image': 'assets/images/meditationImage6.png',
          'video': 'assets/videos/video3.mp3',
        }
      ]
    }
  ];

  MeditationVideoList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: videoList.map((section) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
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
                      childAspectRatio: 160 / 220, // 아이템의 가로 세로 비율
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
                                videoImage: video['image'],
                                videoPath: video['video'],
                              ),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 0,
                          color: Colors.white,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset(
                                  video['image'],
                                  width: 160,
                                  height: 160,
                                  fit: BoxFit.cover,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    video['title'],
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontFamily: 'LeeSeoYun',
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
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
  final String videoImage;
  final String videoPath;

  const MeditationVideoPlayer(
      {super.key, required this.videoImage, required this.videoPath});

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
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(widget.videoImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
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
      ),
    );
  }
}
