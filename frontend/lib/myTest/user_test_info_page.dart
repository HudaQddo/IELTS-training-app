// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_unnecessary_containers, sized_box_for_whitespace, no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:frontend/components.dart';
import 'package:frontend/myTest/models/submit_test_model.dart';
import 'package:frontend/myTest/user_test_question_page.dart';
import 'package:frontend/pallete.dart';

import 'my_test_api.dart';

class UserTestInfoPage extends StatefulWidget {
  final SubmitTestModel submitTestModel;
  const UserTestInfoPage({required this.submitTestModel, super.key});

  @override
  State<UserTestInfoPage> createState() => _UserTestInfoPageState(
        submitTestModel: submitTestModel,
      );
}

class _UserTestInfoPageState extends State<UserTestInfoPage> {
  String typeSection = 'Reading';
  int numberQuestions = 40, startNumber = 1;
  bool trueOrFalse = false;
  List<Map<int, List<String>>> allAnswers = [];
  String essayDef = '';

  SubmitTestModel submitTestModel;
  _UserTestInfoPageState({
    required this.submitTestModel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: addNavigationBar(context, 'User Test Info'),
      body: SafeArea(
        child: typeSection == 'Writing'
            ? FutureBuilder<String>(
                future: getWriting(submitTestModel.test),
                initialData: essayDef,
                builder: ((context, snapshot) {
                  String data = '';
                  if (snapshot.data != null) {
                    data = snapshot.data as String;
                  }
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.arrow_back,
                                color: Colors.grey,
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              submitTestModel.title,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                                color: Pallete.mainColor,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              color: Colors.grey.shade400,
                              height: 2,
                              width: 100,
                            ),
                          ],
                        ),
                        SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  typeSection = 'Reading';
                                  numberQuestions = 40;
                                  startNumber = 1;
                                });
                              },
                              child: Text(
                                'Reading Section',
                                style: TextStyle(
                                  fontSize: typeSection == 'Reading' ? 18 : 14,
                                  color: typeSection == 'Reading'
                                      ? Pallete.secondColor
                                      : Colors.grey,
                                  fontWeight: typeSection == 'Reading'
                                      ? FontWeight.bold
                                      : null,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  typeSection = 'Listening';
                                  numberQuestions = 40;
                                  startNumber = 41;
                                });
                              },
                              child: Text(
                                'Listening Section',
                                style: TextStyle(
                                  fontSize:
                                      typeSection == 'Listening' ? 18 : 14,
                                  color: typeSection == 'Listening'
                                      ? Pallete.secondColor
                                      : Colors.grey,
                                  fontWeight: typeSection == 'Listening'
                                      ? FontWeight.bold
                                      : null,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  typeSection = 'Writing';
                                  numberQuestions = 1;
                                  startNumber = 81;
                                });
                              },
                              child: Text(
                                'Writing Section',
                                style: TextStyle(
                                  fontSize: typeSection == 'Writing' ? 18 : 14,
                                  color: typeSection == 'Writing'
                                      ? Pallete.secondColor
                                      : Colors.grey,
                                  fontWeight: typeSection == 'Writing'
                                      ? FontWeight.bold
                                      : null,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 25),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 25),
                          child: Text(
                            'Writing Essay:',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                              color: Pallete.mainColor,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(25),
                          child: Text(data == '' ? 'No Essay!' : data),
                        ),
                        SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              width: 150,
                              child: addButton(
                                context: context,
                                text: 'Read Only Test',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          UserTestQuestionPage(
                                              testID: submitTestModel.test,
                                              testTitle: submitTestModel.title),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                }),
              )
            : FutureBuilder<List<Map<int, List<String>>>>(
                future: getAllAnswers(submitTestModel.test),
                initialData: allAnswers,
                builder: ((context, snapshot) {
                  List<Map<int, List<String>>> data =
                      snapshot.data as List<Map<int, List<String>>>;
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.arrow_back,
                                color: Colors.grey,
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              submitTestModel.title,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                                color: Pallete.mainColor,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              color: Colors.grey.shade400,
                              height: 2,
                              width: 100,
                            ),
                          ],
                        ),
                        SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  typeSection = 'Reading';
                                  numberQuestions = 40;
                                  startNumber = 1;
                                });
                              },
                              child: Text(
                                'Reading Section',
                                style: TextStyle(
                                  fontSize: typeSection == 'Reading' ? 18 : 14,
                                  color: typeSection == 'Reading'
                                      ? Pallete.secondColor
                                      : Colors.grey,
                                  fontWeight: typeSection == 'Reading'
                                      ? FontWeight.bold
                                      : null,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  typeSection = 'Listening';
                                  numberQuestions = 40;
                                  startNumber = 41;
                                });
                              },
                              child: Text(
                                'Listening Section',
                                style: TextStyle(
                                  fontSize:
                                      typeSection == 'Listening' ? 18 : 14,
                                  color: typeSection == 'Listening'
                                      ? Pallete.secondColor
                                      : Colors.grey,
                                  fontWeight: typeSection == 'Listening'
                                      ? FontWeight.bold
                                      : null,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  typeSection = 'Writing';
                                  numberQuestions = 1;
                                  startNumber = 81;
                                });
                              },
                              child: Text(
                                'Writing Section',
                                style: TextStyle(
                                  fontSize: typeSection == 'Writing' ? 18 : 14,
                                  color: typeSection == 'Writing'
                                      ? Pallete.secondColor
                                      : Colors.grey,
                                  fontWeight: typeSection == 'Writing'
                                      ? FontWeight.bold
                                      : null,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 25),
                        Column(
                          children: addAnswers(
                              typeSection == 'Reading' ? data[0] : data[1]),
                        ),
                        SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              width: 150,
                              child: addButton(
                                context: context,
                                text: 'Read Only Test',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          UserTestQuestionPage(
                                              testID: submitTestModel.test,
                                              testTitle: submitTestModel.title),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                }),
              ),
      ),
    );
  }

  List<Widget> addAnswers(Map<int, List<String>> answers) {
    answers = Map.fromEntries(
        answers.entries.toList()..sort((e1, e2) => e1.key.compareTo(e2.key)));
    List<Widget> ans = [];
    for (var item in answers.entries) {
      ans.add(Container(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
                child: Text(
              '${item.key}. ${item.value[1]}',
              maxLines: 3,
            )),
            Icon(
              item.value[0] == item.value[1] ? Icons.done : Icons.close,
              color: item.value[0] == item.value[1] ? Colors.green : Colors.red,
            )
          ],
        ),
      ));
    }
    if (ans.isEmpty) {
      ans.add(Container(
        height: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('No Answers')],
        ),
      ));
    }
    return ans;
  }
}
