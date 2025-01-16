import 'dart:convert';

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
  String inputedMessage = "";
  List<Map<String, String>> chatedMessage = [];

  Future<String?> _handleSubmitted() async {
    print(inputedMessage);
    try {
      var response = await http.post(
        Uri.parse("http://localhost:3000/chatbot/get"),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(
          {
            'msg': inputedMessage,
          },
        ),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 201) {
        print("data['res'], $inputedMessage");
        chatedMessage.add({'User': inputedMessage});
        chatedMessage.add({'AI': data['res']});

        print(chatedMessage);

        inputedMessage = "";
      } else {
        print('Failed to upload diary: ${response.body}');
      }
    } catch (error) {
      print('ai error : $error');
    }

    return null;
  }

  Future<String?> handleSubmitted() async {
    print(inputedMessage);
    try {
      var response = await http.post(
        Uri.parse("http://localhost:3000/chatbot/get"),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(
          {
            'msg': inputedMessage,
          },
        ),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 201) {
        print("data['res'], $inputedMessage");

        // AI의 응답과 유저의 메시지를 리스트에 추가
        setState(() {
          chatedMessage.add({'User': inputedMessage});
          chatedMessage.add({'AI': data['res']});
        });

        print(chatedMessage);
        inputedMessage = ""; // 메시지 입력란 초기화
      } else {
        print('Failed to upload diary: ${response.body}');
      }
    } catch (error) {
      print('AI error: $error');
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/chatBackground.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        padding: EdgeInsets.only(top: 150, right: 17, left: 17, bottom: 20),
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
                ),
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
            Container(
              margin: EdgeInsets.only(top: 10, left: 60),
              padding: EdgeInsets.only(
                top: 7.5,
                bottom: 7.5,
                left: 17,
                right: 17,
              ),
              child: SvgPicture.asset('assets/images/chatBotKoKoChar.svg'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: chatedMessage.length,
                itemBuilder: (context, index) {
                  final message = chatedMessage[index];
                  final isUserMessage = message.containsKey('User');
                  return ListTile(
                    title: Align(
                      alignment: isUserMessage
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: isUserMessage
                          ? Container(
                              margin: EdgeInsets.only(left: 60),
                              padding: EdgeInsets.only(
                                top: 7.5,
                                bottom: 7.5,
                                left: 17,
                                right: 17,
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xffFF516A),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(14),
                                  topRight: Radius.circular(0),
                                  bottomRight: Radius.circular(14),
                                  bottomLeft: Radius.circular(14),
                                ),
                                border: Border.all(
                                  color: Color(0xffDADADA),
                                ),
                              ),
                              child: Text(
                                message.values.first,
                                style: TextStyle(
                                  fontSize: 16,
                                  height: 1.2,
                                  color: Color(0xffFFFFFF),
                                ),
                              ),
                            )
                          : Column(
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
                                    ),
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
                                    message.values.first,
                                    style: TextStyle(
                                      fontSize: 16,
                                      height: 1.2,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter, // 화면 하단에 배치
              child: Container(
                width: double.infinity, // 화면 전체를 차지
                padding: EdgeInsets.symmetric(horizontal: 17),
                color: Color(0xffFFFFFF),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration.collapsed(
                          hintText: "메시지를 입력해주세요.",
                        ),
                        onChanged: (val) {
                          setState(() {
                            inputedMessage =
                                val; // inputedMessage를 업데이트하면서 UI도 갱신
                          });
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: IconButton(
                        icon: SvgPicture.asset(
                          'assets/images/sendButton.svg',
                          width: 36,
                        ),
                        onPressed: () async {
                          if (inputedMessage.trim() != 0) {
                            print('메시지 전송: $inputedMessage'); // 로그 추가
                            await handleSubmitted();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
