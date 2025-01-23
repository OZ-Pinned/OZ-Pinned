import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';

class ChatBot extends StatefulWidget {
  final String email;
  final String name;
  const ChatBot({super.key, required this.email, required this.name});

  @override
  _ChatBotPageState createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBot> {
  String inputedMessage = "";
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> chatedMessage = [
    // 첫 메시지를 추가하여 처음 화면에서 보여줄 수 있도록 설정
    {'AI': tr("chatbot_hello")}
  ];

  final ScrollController _scrollController =
      ScrollController(); // ScrollController 추가

  Future<String?> handleSubmitted() async {
    print(inputedMessage);
    setState(() {
      chatedMessage.add({'User': inputedMessage});
      _controller.clear();
    });
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 1000),
      curve: Curves.easeOut,
    );
    try {
      var response = await http.post(
        Uri.parse("http://localhost:3000/chatbot/get"),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(
          {
            'email': widget.email,
            'msg': inputedMessage,
            'name': widget.name,
          },
        ),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 201) {
        print("data['res'], $inputedMessage");

        // AI의 응답과 유저의 메시지를 리스트에 추가
        setState(() {
          chatedMessage.add({'AI': data['res']});
          inputedMessage = "";
        });
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 1000),
          curve: Curves.easeOut,
        );

        print(chatedMessage);
        inputedMessage = ""; // 메시지 입력란 초기화

        // 새로운 메시지가 추가된 후 스크롤을 맨 아래로 내리기
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 300,
          duration: Duration(milliseconds: 800),
          curve: Curves.easeOut,
        );
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
        backgroundColor: Color(0xffFFF9F8),
        scrolledUnderElevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/chatBackground.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        padding: EdgeInsets.only(right: 0, left: 0, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController, // ScrollController 연결
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
                                top: 10,
                                bottom: 10,
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
                                      tr("coco"),
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
                                    top: 10,
                                    left: 17,
                                    right: 17,
                                    bottom: 10,
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
                                      height: 1.3,
                                    ),
                                  ),
                                ),
                                if (index == 0)
                                  Container(
                                    margin: EdgeInsets.only(top: 10, left: 60),
                                    padding: EdgeInsets.only(
                                      top: 7.5,
                                      bottom: 7.5,
                                      left: 17,
                                      right: 17,
                                    ),
                                    child: SvgPicture.asset(
                                        'assets/images/chatBotKoKoChar.svg'),
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
                        controller: _controller,
                        decoration: InputDecoration.collapsed(
                          hintText: tr("chatbot_hintText"),
                        ),
                        onChanged: (val) {
                          setState(() {
                            inputedMessage = val;
                          });
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: inputedMessage.isEmpty
                          ? IconButton(
                              icon: SvgPicture.asset(
                                'assets/images/sendButtonNo.svg',
                                width: 36,
                              ),
                              onPressed: () async {
                                if (inputedMessage.trim() != 0) {
                                  await handleSubmitted();
                                }
                              },
                            )
                          : IconButton(
                              icon: SvgPicture.asset(
                                'assets/images/sendButtonYes.svg',
                                width: 36,
                              ),
                              onPressed: () async {
                                if (inputedMessage.trim() != 0) {
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
