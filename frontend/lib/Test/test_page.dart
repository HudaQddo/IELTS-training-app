// ignore_for_file: prefer_const_constructors, prefer_typing_uninitialized_variables, no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:frontend/components.dart';

import '../pallete.dart';
import 'reading_page.dart';

class TestPage extends StatefulWidget {
  final testID;
  const TestPage({required this.testID,super.key});

  @override
  State<TestPage> createState() => _TestPageState(testID: testID);
}

class _TestPageState extends State<TestPage> {
  int testID;
  _TestPageState({required this.testID});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: addNavigationBar(context, ''),
      body: SafeArea(
        child: Center(
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReadingPage(testID: testID),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
              decoration: BoxDecoration(
                color: Pallete.mainColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                'Start Test',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
