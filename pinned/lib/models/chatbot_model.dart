import 'package:flutter/material.dart';

enum Sender { user, ai }

class ChatbotModel {
  final int id;
  final String email;
  final Enum sender;
  final String text;
  final DateTime createdAt;

  ChatbotModel(
      {required this.id,
      required this.email,
      required this.sender,
      required this.text,
      required this.createdAt});
}
