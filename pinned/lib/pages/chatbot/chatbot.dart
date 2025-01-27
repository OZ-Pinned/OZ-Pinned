import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:pinned/widgets/chatMessage.dart';
import 'package:pinned/apis/chatbotAPI.dart';

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

  Future<void> _getMessage() async {
    setState(() {
      chatedMessage.add({'User': inputedMessage});
      _controller.clear();
    });
    try {
      final response = await chatbotAPI.handleSubmitted(
          widget.email, inputedMessage, widget.name);
      final data = json.decode(response!.body);

      print(data);

      setState(() {
        chatedMessage.add({'AI': data['res']});
        inputedMessage = "";
      });
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 1000),
        curve: Curves.easeOut,
      );

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 1000),
        curve: Curves.easeOut,
      );
    } catch (e) {
      print('Error loading series: $e');
    }
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
                          ? UserMessage(textMessage: message.values.first)
                          : AIMessage(
                              textMessage: message.values.first,
                              index: index,
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
                      child: IconButton(
                        icon: inputedMessage.isEmpty
                            ? SvgPicture.asset(
                                'assets/images/sendButtonNo.svg',
                                width: 36,
                              )
                            : SvgPicture.asset(
                                'assets/images/sendButtonYes.svg',
                                width: 36,
                              ),
                        onPressed: () async {
                          if (inputedMessage.trim() != 0) {
                            await _getMessage();
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
