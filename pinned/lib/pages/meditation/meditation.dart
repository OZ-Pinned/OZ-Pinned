import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pinned/icon/custom_icon_icons.dart';
import 'package:video_player/video_player.dart';
import 'package:easy_localization/easy_localization.dart';

class MeditationVideoList extends StatelessWidget {
  final List<Map<String, dynamic>> videoList = [
    {
      'section': 'meditation_guide'.tr(),
      'videos': [
        {
          'title': 'how_to_clear_thoughts'.tr(),
          'image': 'assets/images/meditationImage1.png',
          'video': 'assets/videos/video1.mp3',
          'background': 'assets/images/meditationBackground2.jpg'
        },
        {
          'title': "peaceful_mind".tr(),
          'image': 'assets/images/meditationImage2.png',
          'video': 'assets/videos/video1.mp3',
          'background': 'assets/images/meditationBackground4.jpg'
        }
      ]
    },
    {
      'section': "healing_nature_sounds".tr(),
      'videos': [
        {
          'title': "water_sounds".tr(),
          'image': 'assets/images/meditationImage3.png',
          'video': 'assets/videos/video2.mp3',
          'background': 'assets/images/meditationBackground3.jpg'
        },
        {
          'title': "forest_music".tr(),
          'image': 'assets/images/meditationImage4.png',
          'video': 'assets/videos/video2.mp3',
          'background': 'assets/images/meditationBackground1.jpg'
        }
      ]
    },
    {
      'section': "fire_sounds".tr(),
      'videos': [
        {
          'title': "warm_fire".tr(),
          'image': 'assets/images/meditationImage5.png',
          'video': 'assets/videos/video3.mp3',
          'background': 'assets/images/meditationBackground6.jpg'
        },
        {
          'title': "relaxing_fire".tr(),
          'image': 'assets/images/meditationImage6.png',
          'video': 'assets/videos/video3.mp3',
          'background': 'assets/images/meditationBackground5.jpg'
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
        backgroundColor: Colors.transparent,
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
                                videoTitle: video['title'],
                                videoImage: video['background'],
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
  final String videoTitle;
  final String videoImage;
  final String videoPath;

  const MeditationVideoPlayer(
      {super.key,
      required this.videoTitle,
      required this.videoImage,
      required this.videoPath});

  @override
  _MeditationVideoPlayerState createState() => _MeditationVideoPlayerState();
}

class _MeditationVideoPlayerState extends State<MeditationVideoPlayer> {
  late VideoPlayerController _controller;
  late Timer _timer;
  bool play = true;
  double _sliderValue = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoPath)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _startTimer();
        _timer = Timer.periodic(Duration(seconds: 1), (timer) {
          if (_controller.value.isInitialized && mounted) {
            setState(() {
              _sliderValue = _controller.value.position.inSeconds.toDouble();
            });
          }
        });
      });
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_controller.value.isInitialized && mounted) {
        setState(() {
          _sliderValue = _controller.value.position.inSeconds.toDouble();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(widget.videoImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (_controller.value.isInitialized)
              Column(
                children: [
                  AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.videoTitle,
                      style: TextStyle(
                        color: Color(0xffFFFFFF),
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  SizedBox(
                    width: 350,
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: Color(0xffFF516A), // 슬라이더의 활성화된 트랙 색상
                        inactiveTrackColor: Color(0xffFFF2F0),
                        trackHeight: 2.0,
                        thumbColor: Color(0xffFF516A),
                      ),
                      child: Slider(
                        value: _sliderValue,
                        min: 0.0,
                        max: _controller.value.duration.inSeconds.toDouble(),
                        onChanged: (value) {
                          setState(() {
                            _sliderValue = value;
                          });
                        },
                        onChangeEnd: (value) {
                          _controller.seekTo(Duration(seconds: value.toInt()));
                        },
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDuration(_controller.value.position),
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        _formatDuration(_controller.value.duration),
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 28,
                    children: [
                      IconButton(
                        onPressed: () {
                          _controller.seekTo(_controller.value.position -
                              Duration(seconds: 10));
                        },
                        icon: SvgPicture.asset(
                          'assets/images/beforeTenButton.svg',
                          width: 28,
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
                          width: 55,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          _controller.seekTo(_controller.value.position +
                              Duration(seconds: 10));
                        },
                        icon: SvgPicture.asset(
                          'assets/images/afterTenButton.svg',
                          width: 28,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                ],
              )
            else
              const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
