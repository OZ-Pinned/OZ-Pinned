import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  final String email;
  final int character;
  final String name;
  const HomePage({
    super.key,
    required this.email,
    required this.character,
    required this.name,
  });

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      appBar: AppBar(),
      body: Column(
        children: [
          Text(widget.email),
          Text(widget.name),
          Text('${widget.character}'),
        ],
      ),
    );
  }
}
