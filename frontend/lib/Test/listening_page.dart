// ignore_for_file: implementation_imports, unnecessary_import, prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, avoid_print, no_logic_in_create_state

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:frontend/Test/model/listening_model.dart';
import 'package:frontend/Test/writing_page.dart';
import 'package:frontend/components.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:audioplayers/audioplayers.dart';
import '../Profile/model/user_model.dart';
import '../Profile/profile_api.dart';
import '../pallete.dart';
import 'model/question_model.dart';
import 'test_api.dart';

class ListeningPage extends StatefulWidget {
  final int testID;
  const ListeningPage({required this.testID, super.key});

  @override
  State<ListeningPage> createState() => _ListeningPageState(testID: testID);
}

class _ListeningPageState extends State<ListeningPage> {
  final player = AudioPlayer();
  bool countdownToStart = true;
  int currentStep = 0;
  int isPlaying = 0;
  int startSecond = 5, seconds = 0, minutes = 0;
  String stringSeconds = '00', stringMinutes = '00';
  Map<int, String> multipleValue = {};
  Map<int, TextEditingController> fillBlankControllers = {};
  List<ListeningModel> tests = [];
  Map<int, String> selectedLinkingAnswers = {};
  Map<int, String> selectedLinkingAnswersCharacters = {};

  int testID;
  _ListeningPageState({required this.testID});
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
                  text: 'The listening test ${currentStep + 1} begin after',
                  startSecond: startSecond,
                )
              : tests.isNotEmpty
                  ? Stepper(
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
                                selectedLinkingAnswers[q.number]!;
                          }
                        }

                        await submitAnswers(userID, testID, questions, answers);

                        setState(() {
                          if (!isLastStep) {
                            currentStep += 1;
                            resetTimer();
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WritingPage(testID: 1),
                              ),
                            );
                          }
                        });
                      }),
                    )
                  : Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Not found listening tests!'),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WritingPage(testID: 1),
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(25),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: Colors.grey,
                              ),
                              child: Text('Go to Writing Test'),
                            ),
                          ),
                        ],
                      ),
                    ),
        ),
      ),
    );
  }

  playAudio(ListeningModel listeningModel) async {
    final player = AudioPlayer();
    await player.play(UrlSource('assets/${listeningModel.audio}'));
  }

  void getTests() async {
    List<ListeningModel> t = await getListeningTest(testID);
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
          // if (currentStep == tests.length - 1) {
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
          title: Text('Listen ${i + 1}'),
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
        // Voice
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () async {
                if (isPlaying == 0) {
                  await player.play(UrlSource('assets/${tests[index].audio}'));
                  isPlaying = 2;
                } else if (isPlaying == 1) {
                  await player.resume();
                  isPlaying = 2;
                } else {
                  await player.pause();
                  isPlaying = 1;
                }
                // isPlaying = !isPlaying;
              },
              child: CircleAvatar(
                child: Icon(
                    isPlaying == 2 ? Icons.stop_rounded : Icons.play_arrow),
              ),
            ),
          ],
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
      'Fill in the blanks with the correct answer:',
      style: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.bold,
      ),
    ));
    fb.add(SizedBox(height: 15));

    List<Widget> la = [];
    la.add(Text(
      'Match the following questions with the correct answers:',
      style: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.bold,
      ),
    ));
    la.add(SizedBox(height: 15));
    la.add(Text(
      'A',
      style: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.bold,
      ),
    ));
    la.add(SizedBox(height: 15));

    List<String> linkingCorrectAnswers = [];
    Map<int, List<String>> numbersIndex = {};

    for (var q in questions) {
      if (q.multipleChoiceModel.id != -1) {
        if (multipleValue[q.number] == null) {
          multipleValue[q.number] = '';
        }
        mc.add(
          Container(
            width: MediaQuery.of(context).size.width,
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
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(15),
            margin: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(25),
            ),
            child: addSentencesCompletionQuestion(q),
          ),
        );
      } else if (q.linkingModel.id != -1) {
        if (selectedLinkingAnswersCharacters[q.number] == null) {
          selectedLinkingAnswersCharacters[q.number] = 'A';
          selectedLinkingAnswers[q.number] = '';
        }
        linkingCorrectAnswers.add(q.linkingModel.correctAnswer);
        numbersIndex[q.number] = [
          q.number.toString(),
          q.linkingModel.correctAnswer
        ];
        la.add(
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(15),
            margin: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(25),
            ),
            child: addMatchingQuestion(q.number.toString(), q.text),
          ),
        );
      }
    }

    la.add(Text(
      'B',
      style: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.bold,
      ),
    ));
    la.add(SizedBox(height: 15));

    linkingCorrectAnswers.sort();
    // Add the other section of the link
    Map<String, String> items = {};
    for (int i = 0; i < linkingCorrectAnswers.length; i++) {
      items[String.fromCharCode(i + 65)] = linkingCorrectAnswers[i];
      la.add(
        Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(15),
          margin: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(25),
          ),
          child: addMatchingQuestion(
            String.fromCharCode(i + 65),
            linkingCorrectAnswers[i],
          ),
        ),
      );
    }

    la.add(Text(
      'Choose answers:',
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
    ));

    // Add the dropdowns of the link
    for (var item in numbersIndex.entries) {
      la.add(
        Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(15),
          margin: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            children: [
              Text('${item.key}.'),
              SizedBox(width: 15),
              Expanded(
                child: DropdownButton(
                  dropdownColor: Pallete.secondColor,
                  value: selectedLinkingAnswersCharacters[
                      int.parse(item.value[0])],
                  items: items.keys.toList().map((String value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedLinkingAnswersCharacters[
                          int.parse(item.value[0])] = newValue!;
                      selectedLinkingAnswers[int.parse(item.value[0])] =
                          items[newValue]!;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }

    List<Widget> list = [];
    if (mc.length > 2) {
      list.addAll(mc);
    }
    if (fb.length > 2) {
      list.addAll(fb);
    }
    if (la.length > 7) {
      list.addAll(la);
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: list,
      ),
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

  Widget addMatchingQuestion(String index, String q) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$index. $q', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
      ],
    );
  }
}
