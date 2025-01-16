import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatBot extends StatefulWidget {
  const ChatBot({super.key});

  @override
  _ChatBotPageState createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBot> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      extendBodyBehindAppBar: false,
      body: Padding(
        padding: EdgeInsets.all(17),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                spacing: 7,
                children: [
                  SvgPicture.asset(
                    'assets/images/chatBotKoKo.svg',
                    width: 45,
                    height: 45,
                  ),
                  Text(
                    '코코',
                    style: TextStyle(
                      fontFamily: 'LeeSeoYun',
                      fontSize: 18,
                    ),
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.only(left: 60),
                padding: EdgeInsets.only(
                  top: 7.5,
                  bottom: 7.5,
                  left: 17,
                  right: 17,
                ),
                decoration: BoxDecoration(
                  color: Color(0xffFFFFFF),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(0),
                    topRight: Radius.circular(14),
                    bottomRight: Radius.circular(14),
                    bottomLeft: Radius.circular(14),
                  ),
                  border: Border.all(
                    color: Color(0xffDADADA),
                  ),
                ),
                child: Text(
                  '안녕 나는 코코야!\n오늘 너의 기분은 어때?',
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
