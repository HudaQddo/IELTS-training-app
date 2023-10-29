// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/Login/welcome_page.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  int seconds = 30;
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            padding: EdgeInsets.all(75),
            child: Image.network('assets/images/logo_project_2.png'),
          ),
        ),
      ),
    );
  }

  void startTimer() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        seconds -= 1;
        if (seconds == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WelcomePage(),
            ),
          );
        }
      });
    });
  }
}
