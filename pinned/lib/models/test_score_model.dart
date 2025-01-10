import 'package:flutter/material.dart';

class TestScoreModel {
  final int id;
  final String email;
  final int score;
  final DateTime createdAt;

  TestScoreModel(
      {required this.id,
      required this.email,
      required this.score,
      required this.createdAt});
}
