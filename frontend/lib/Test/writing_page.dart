// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, sized_box_for_whitespace, no_logic_in_create_state

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/Test/model/writing_model.dart';
import 'package:frontend/Test/test_api.dart';
import 'package:frontend/components.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../Profile/model/user_model.dart';
import '../Profile/profile_api.dart';

class WritingPage extends StatefulWidget {
  final int testID;
  const WritingPage({required this.testID, super.key});

  @override
  State<WritingPage> createState() => _WritingPageState(testID: testID);
}

class _WritingPageState extends State<WritingPage> {
  TextEditingController essayController = TextEditingController();

  bool countdownToStart = true;
  int currentStep = 0;
  bool isPlaying = false;
  int startSecond = 5, seconds = 0, minutes = 0;
  String stringSeconds = '00', stringMinutes = '00';

  List<WritingModel> tests = [];
  int testID;
  _WritingPageState({required this.testID});
  @override
  void initState() {
    super.initState();
    getTests();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: countdownToStart
              ? addTimer(
                  text: 'The writing test ${currentStep + 1} begin after',
                  startSecond: startSecond,
                )
              : Stepper(
                  type: StepperType.horizontal,
                  steps: getSteps(tests.length),
                  currentStep: currentStep,
                  onStepContinue: (() async {
                    final isLastStep =
                        currentStep == getSteps(tests.length).length - 1;
                    if (!isLastStep) {
                      setState(() {
                        currentStep += 1;
                        resetTimer();
                      });
                    } else {
                      UserModel model = await getProfile();
                      int userID = model.id;
                      submitTopic(userID, testID, tests[currentStep].id, essayController.text);
                    }
                  }),
                ),
        ),
      ),
    );
  }

  void getTests() async {
    List<WritingModel> t = await getWritingTest(testID);
    setState(() {
      tests = t;
    });
  }

  void resetTimer() {
    setState(() {
      startSecond = 5;
      countdownToStart = true;
      seconds = 0;
      minutes = 0;
      stringSeconds = '00';
      stringMinutes = '00';
    });
  }

  void startTimer() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        // print(
        //     'countdownToStart: $countdownToStart , start: $startSecond , sec: $seconds , min: $minutes');
        if (minutes == 30) {
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: Text('Time is over'),
              content: Text('This test finished'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    final isLastStep =
                        currentStep == getSteps(tests.length).length - 1;
                    setState(() {
                      if (!isLastStep) {
                        currentStep += 1;
                        resetTimer();
                        startTimer();
                      }
                    });
                    Navigator.pop(context, 'OK');
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          );
          timer.cancel();
          // if (currentStep == getSteps().length - 1) {
          //   timer.cancel();
          // } else {
          //   resetTimer();
          // }
          return;
        }
        if (startSecond > 0) {
          startSecond--;
          return;
        }
        if (startSecond == 0 && countdownToStart) {
          countdownToStart = false;
        }
        seconds++;
        stringSeconds = seconds.toString();
        if (stringSeconds.length == 1) {
          stringSeconds = '0$stringSeconds';
        }
        if (seconds == 60) {
          seconds = 0;
          minutes++;
          stringSeconds = '00';
          stringMinutes = minutes.toString();
          if (stringMinutes.length == 1) {
            stringMinutes = '0$stringMinutes';
          }
        }
      });
    });
  }

  List<Step> getSteps(int length) {
    List<Step> l = [];
    for (int i = 0; i < length; i++) {
      l.add(
        Step(
          isActive: currentStep >= i,
          title: Text('Write ${i + 1}'),
          content: getContentStep(i),
        ),
      );
    }
    return l;
  }

  getContentStep(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timer
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularPercentIndicator(
              radius: 50.0,
              lineWidth: 8.0,
              // animation: true,
              percent: (minutes * 60 + seconds) / 1800,
              header: Text('Test time 30 minutes'),
              center: Text("$stringMinutes:$stringSeconds"),
              circularStrokeCap: CircularStrokeCap.round,
              progressColor: (minutes * 60 + seconds) / 1800 < 0.5
                  ? Colors.green
                  : (minutes * 60 + seconds) / 1800 < 0.8
                      ? Colors.orange
                      : Colors.red,
            ),
          ],
        ),
        SizedBox(height: 25),
        // Question
        Text(tests[index].topic),
        SizedBox(height: 25),
        // Essay
        TextFormField(
          controller: essayController,
          maxLines: 10,
          maxLength: countdownToStart ? essayController.text.length : null,
          // readOnly: readOnly,
          decoration: InputDecoration(
            hintText: 'Enter your essay here',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
