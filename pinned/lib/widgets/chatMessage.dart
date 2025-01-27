// chat_message_widgets.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';

class UserMessage extends StatelessWidget {
  final String textMessage;

  const UserMessage({super.key, required this.textMessage});

  @override
  Widget build(BuildContext context) {
    return Container(
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
        textMessage,
        style: TextStyle(
          fontSize: 16,
          height: 1.2,
          color: Color(0xffFFFFFF),
        ),
      ),
    );
  }
}

class AIMessage extends StatelessWidget {
  final String textMessage;
  final int index;

  const AIMessage({super.key, required this.textMessage, required this.index});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SvgPicture.asset(
              'assets/images/chatBotKoKo.svg',
              width: 45,
              height: 45,
            ),
            SizedBox(width: 7), // 추가 여백
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
            textMessage,
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
            child: SvgPicture.asset('assets/images/chatBotKoKoChar.svg'),
          ),
      ],
    );
  }
}
