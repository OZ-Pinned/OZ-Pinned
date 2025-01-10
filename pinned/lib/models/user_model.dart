import 'package:flutter/material.dart';

class UserModel {
  final int id;
  final String email;
  final String name;
  final int character;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.character,
  });
}
