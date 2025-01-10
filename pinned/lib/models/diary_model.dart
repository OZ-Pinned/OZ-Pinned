import 'package:flutter/material.dart';

class DiaryModel {
  final int id;
  final String email;
  final String title;
  final String diary;
  final String image;
  final DateTime createdAt;

  DiaryModel(
      {required this.id,
      required this.email,
      required this.title,
      required this.diary,
      required this.image,
      required this.createdAt});
}
