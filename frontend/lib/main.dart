// ignore_for_file: prefer_const_constructors, unused_import

import 'package:flutter/material.dart';
import 'package:frontend/Login/login_page.dart';
import 'package:frontend/Login/signup_page.dart';
import 'package:frontend/Login/start_page.dart';
import 'package:frontend/Login/welcome_page.dart';
import 'package:frontend/Profile/profile_page.dart';
import 'package:frontend/Test/listening_page.dart';
import 'package:frontend/Test/reading_page.dart';
import 'package:frontend/Test/writing_page.dart';
import 'package:frontend/components.dart';
import 'package:frontend/consts.dart';
import 'package:frontend/mainPage.dart';
import 'myTest/user_test_info_page.dart';
import 'myTest/user_tests_page.dart';

void main() async {
  tokenUser = await getToken();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Train Me',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}
