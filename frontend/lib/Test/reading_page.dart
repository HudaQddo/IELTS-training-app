// ignore_for_file: avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, prefer_const_constructors, sized_box_for_whitespace, avoid_print, no_logic_in_create_state, use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/Test/listening_page.dart';
import 'package:frontend/Test/test_api.dart';
import 'package:frontend/components.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../Profile/model/user_model.dart';
import '../Profile/profile_api.dart';
import 'model/question_model.dart';
import 'model/reading_model.dart';

class ReadingPage extends StatefulWidget {
  final int testID;
  const ReadingPage({required this.testID, super.key});

  @override
  State<ReadingPage> createState() => _ReadingPageState(testID: testID);
}

class _ReadingPageState extends State<ReadingPage> {
  bool countdownToStart = true;
  int currentStep = 0;
  bool isPlaying = false;
  int startSecond = 5, seconds = 0, minutes = 0;
  String stringSeconds = '00', stringMinutes = '00';
  Map<int, String> multipleValue = {};
  Map<int, TextEditingController> fillBlankControllers = {};
  Map<int, TextEditingController> shortAnswerControllers = {};
  List<ReadingModel> tests = [];
  int testID;
  _ReadingPageState({required this.testID});
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
                  text: 'The reading test ${currentStep + 1} begin after',
                  startSecond: startSecond,
                )
              : Stepper(
                  type: StepperType.horizontal,
                  steps: getSteps(tests.length),
                  currentStep: currentStep,
                  onStepContinue: (() async {
                    final isLastStep = currentStep == tests.length - 1;

                    UserModel model = await getProfile();
                    int userID = model.id;

                    Map<int, String> answers = {};
                    Map<int, String> questions = {};
                    for (QuestionModel q in tests[currentStep].questions) {
                      questions[q.number] = q.text;
                      if (q.multipleChoiceModel.id != -1) {
                        answers[q.number] = multipleValue[q.number]!;
                      } else if (q.fillBlankModel.id != -1) {
                        answers[q.number] =
                            fillBlankControllers[q.number]!.text;
                      } else {
                        answers[q.number] =
                            shortAnswerControllers[q.number]!.text;
                      }
                    }

                    await submitAnswers(userID, testID, questions, answers);

                    if (!isLastStep) {
                      setState(() {
                        currentStep += 1;
                        resetTimer();
                      });
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListeningPage(testID: testID),
                        ),
                      );
                    }
                  }),
                ),
        ),
      ),
    );
  }

  void getTests() async {
    List<ReadingModel> t = await getReadingTest(testID);
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
        if (minutes == 30) {
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: Text('Time is over'),
              content: Text('This test finished'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    final isLastStep = currentStep == tests.length - 1;
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
          title: Text('Read ${i + 1}'),
          content: getContentStep(i),
        ),
      );
    }
    return l;
  }

  Widget getContentStep(int index) {
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
        // Text
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                index == 0
                    ? 'first text:'
                    : index == 1
                        ? 'second text:'
                        : 'third text:',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 15),
              Text(tests[index].text),
            ],
          ),
        ),
        SizedBox(height: 25),
        getQuestions(tests[index].questions),
      ],
    );
  }

  Widget getQuestions(List<QuestionModel> questions) {
    List<Widget> mc = [];

    mc.add(Text(
      'Choose the correct answer:',
      style: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.bold,
      ),
    ));
    mc.add(SizedBox(height: 15));

    List<Widget> fb = [];
    fb.add(Text(
      'Complete the sentences:',
      style: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.bold,
      ),
    ));
    fb.add(SizedBox(height: 15));

    List<Widget> sa = [];
    sa.add(Text(
      'Answer the questions below:',
      style: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.bold,
      ),
    ));
    sa.add(SizedBox(height: 15));

    for (var q in questions) {
      if (q.multipleChoiceModel.id != -1) {
        if (multipleValue[q.number] == null) {
          multipleValue[q.number] = '';
        }
        mc.add(
          Container(
            padding: EdgeInsets.all(15),
            margin: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(25),
            ),
            child: addMultipleChoiceQuestion(q),
          ),
        );
      } else if (q.fillBlankModel.id != -1) {
        if (fillBlankControllers[q.number] == null) {
          fillBlankControllers[q.number] = TextEditingController();
        }
        fb.add(
          Container(
            padding: EdgeInsets.all(15),
            margin: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(25),
            ),
            child: addSentencesCompletionQuestion(q),
          ),
        );
      } else if (q.shortAnswerModel.id != -1) {
        if (shortAnswerControllers[q.number] == null) {
          shortAnswerControllers[q.number] = TextEditingController();
        }
        sa.add(
          Container(
            padding: EdgeInsets.all(15),
            margin: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(25),
            ),
            child: addShortAnswerQuestion(q),
          ),
        );
      }
    }

    List<Widget> list = [];
    if (mc.length > 2) {
      list.addAll(mc);
    }
    if (fb.length > 2) {
      list.addAll(fb);
    }
    if (sa.length > 2) {
      list.addAll(sa);
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: list,
      ),
    );
  }

  Widget addShortAnswerQuestion(QuestionModel q) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${q.number}. ${q.text}',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        TextFormField(
          controller: shortAnswerControllers[q.number],
          decoration: InputDecoration(hintText: 'Your answer'),
        ),
        SizedBox(height: 25),
      ],
    );
  }

  Widget addMultipleChoiceQuestion(QuestionModel q) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${q.number}. ${q.text}',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     Container(
        //       width: 200,
        //       height: 2,
        //       color: Colors.grey,
        //     ),
        //   ],
        // ),
        // SizedBox(height: 10),
        Row(
          children: [
            Radio(
              value: q.multipleChoiceModel.answerOne,
              groupValue: multipleValue[q.number],
              onChanged: (value) {
                setState(() {
                  multipleValue[q.number] = value!;
                });
              },
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                q.multipleChoiceModel.answerOne,
                maxLines: 3,
              ),
            ),
          ],
        ),
        SizedBox(height: 5),
        Row(
          children: [
            Radio(
              value: q.multipleChoiceModel.answerTwo,
              groupValue: multipleValue[q.number],
              onChanged: (value) {
                setState(() {
                  multipleValue[q.number] = value!;
                });
              },
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                q.multipleChoiceModel.answerTwo,
                maxLines: 3,
              ),
            ),
          ],
        ),
        if (q.multipleChoiceModel.answerThree.isNotEmpty) SizedBox(height: 5),
        if (q.multipleChoiceModel.answerThree.isNotEmpty)
          Row(
            children: [
              Radio(
                value: q.multipleChoiceModel.answerThree,
                groupValue: multipleValue[q.number],
                onChanged: (value) {
                  setState(() {
                    multipleValue[q.number] = value!;
                  });
                },
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  q.multipleChoiceModel.answerThree,
                  maxLines: 3,
                ),
              ),
            ],
          ),
        if (q.multipleChoiceModel.answerFour.isNotEmpty) SizedBox(height: 5),
        if (q.multipleChoiceModel.answerFour.isNotEmpty)
          Row(
            children: [
              Radio(
                value: q.multipleChoiceModel.answerFour,
                groupValue: multipleValue[q.number],
                onChanged: (value) {
                  setState(() {
                    multipleValue[q.number] = value!;
                  });
                },
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  q.multipleChoiceModel.answerFour,
                  maxLines: 3,
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget addSentencesCompletionQuestion(QuestionModel q) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${q.number}. ${q.text}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5),
        TextFormField(
          controller: fillBlankControllers[q.number],
          decoration: InputDecoration(
            hintText: 'Your answer',
          ),
        ),
        SizedBox(height: 25),
      ],
    );
  }
}
