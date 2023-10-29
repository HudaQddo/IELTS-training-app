// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, no_logic_in_create_state, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:frontend/Test/model/listening_model.dart';
import 'package:frontend/Test/test_api.dart';
import 'package:frontend/components.dart';
import '../Test/model/question_model.dart';
import '../Test/model/reading_model.dart';
import '../Test/model/writing_model.dart';
import '../pallete.dart';

class UserTestQuestionPage extends StatefulWidget {
  final int testID;
  final String testTitle;
  const UserTestQuestionPage(
      {required this.testID, required this.testTitle, super.key});

  @override
  State<UserTestQuestionPage> createState() =>
      _UserTestQuestionPageState(testID: testID, testTitle: testTitle);
}

class _UserTestQuestionPageState extends State<UserTestQuestionPage> {
  String typeSection = 'Reading';
  int numberQuestions = 40, startNumber = 1;

  int testID;
  String testTitle;
  _UserTestQuestionPageState({
    required this.testID,
    required this.testTitle,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: addNavigationBar(context, 'Read Only Test'),
      body: SafeArea(
        child: FutureBuilder(
          future: typeSection == 'Reading'
              ? getReadingTest(testID)
              : typeSection == 'Listening'
                  ? getListeningTest(testID)
                  : getWritingTest(testID),
          initialData: [],
          builder: ((context, snapshot) {
            List data = [];
            if (typeSection == 'Reading') {
              data = snapshot.data as List<ReadingModel>;
            } else if (typeSection == 'Listening') {
              data = snapshot.data as List<ListeningModel>;
            } else {
              data = snapshot.data as List<WritingModel>;
            }

            return Container(
              padding: EdgeInsets.all(25),
              child: SingleChildScrollView(
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
                          testTitle,
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
                              fontSize: typeSection == 'Listening' ? 18 : 14,
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
                      children: addQuestion(data),
                    ),
                    // SizedBox(height: 25),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   children: [
                    //     Container(
                    //       width: 150,
                    //       child: addButton(
                    //         context: context,
                    //         text: 'Read Only Test',
                    //         onTap: () {
                    //           Navigator.push(
                    //             context,
                    //             MaterialPageRoute(
                    //               builder: (context) => UserTestQuestionPage(
                    //                   testID: submitTestModel.id),
                    //             ),
                    //           );
                    //         },
                    //       ),
                    //     ),
                    //   ],
                    // )
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  List<Widget> addQuestion(List tests) {
    List<Widget> ans = [];
    if (typeSection == 'Reading') {
      for (int i = 0; i < tests.length; i++) {
        ans.add(getReadingQuestion(tests[i], i));
      }
    } else if (typeSection == 'Listening') {
      for (int i = 0; i < tests.length; i++) {
        ans.add(getListeningQuestion(tests[i], i));
      }
    } else {
      for (int i = 0; i < tests.length; i++) {
        ans.add(getWritingQuestion(tests[i], i));
      }
    }
    return ans;
  }

  Widget getReadingQuestion(ReadingModel test, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 25),
        // Text
        Text(
          index == 0
              ? 'first text:'
              : index == 1
                  ? 'second text:'
                  : 'third text:',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            color: Pallete.mainColor,
          ),
        ),
        SizedBox(height: 25),
        getQuestions(test.questions),
      ],
    );
  }

  Widget getListeningQuestion(ListeningModel test, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 25),
        // Text
        Text(
          index == 0
              ? 'first text:'
              : index == 1
                  ? 'second text:'
                  : 'third text:',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            color: Pallete.mainColor,
          ),
        ),
        SizedBox(height: 25),
        getQuestions(test.questions),
      ],
    );
  }

  Widget getWritingQuestion(WritingModel test, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 25),
        // Text
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
        SizedBox(height: 25),
        Text(test.topic),
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

    List<Widget> sa = [];
    sa.add(Text(
      'Answer the questions below with no more than one word:',
      style: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.bold,
      ),
    ));
    sa.add(SizedBox(height: 15));

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

    for (var q in questions) {
      if (q.multipleChoiceModel.id != -1) {
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
      } else if (q.shortAnswerModel.id != -1) {
        sa.add(
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(15),
            margin: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(25),
            ),
            child: addShortAnswerQuestion(q),
          ),
        );
      } else if (q.linkingModel.id != -1) {
        linkingCorrectAnswers.add(q.linkingModel.correctAnswer);
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
    linkingCorrectAnswers.sort();
    la.add(Text(
      'B',
      style: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.bold,
      ),
    ));
    la.add(SizedBox(height: 15));
    // Add the other section of the link
    List<String> items = ['I don\'t know'];
    for (int i = 0; i < linkingCorrectAnswers.length; i++) {
      items.add(String.fromCharCode(i + 65));
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
    if (la.length > 4) {
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

  Widget addShortAnswerQuestion(QuestionModel q) {
    return Text(
      '${q.number}. ${q.text}',
      style: TextStyle(fontWeight: FontWeight.bold),
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
    return Text(
      '${q.number}. ${q.text}',
      style: TextStyle(
        fontWeight: FontWeight.bold,
      ),
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