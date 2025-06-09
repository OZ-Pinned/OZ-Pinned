import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class messageBox extends StatelessWidget {
  final String message;

  const messageBox({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 2,
        bottom: 0,
        left: 12,
        right: 12,
      ),
      decoration: BoxDecoration(
        color: Color(0xffEDEDED),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(19.5),
          topRight: Radius.circular(19.5),
          bottomRight: Radius.circular(0),
          bottomLeft: Radius.circular(19.5),
        ),
        border: Border.all(
          color: Color(0xffDADADA),
        ),
      ),
      constraints: BoxConstraints(
        maxWidth: 250,
      ),
      child: Text(
        message,
        style: TextStyle(
          fontFamily: 'LeeSeoYun',
          fontSize: 24,
        ),
        textAlign: TextAlign.center,
      ).tr(),
    );
  }
}
