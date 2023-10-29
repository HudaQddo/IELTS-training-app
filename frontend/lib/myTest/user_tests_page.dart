// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_unnecessary_containers, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:frontend/myTest/models/submit_test_model.dart';
import 'package:frontend/myTest/user_test_info_page.dart';
import 'package:frontend/components.dart';
import 'package:frontend/pallete.dart';

import 'my_test_api.dart';

class UserTestsPage extends StatefulWidget {
  const UserTestsPage({super.key});

  @override
  State<UserTestsPage> createState() => _UserTestsPageState();
}

class _UserTestsPageState extends State<UserTestsPage> {
  List<SubmitTestModel> submitTestModel = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: addNavigationBar(context, 'User Tests'),
      body: SafeArea(
        child: FutureBuilder<List<SubmitTestModel>>(
          future: getAllSubmitTests(),
          initialData: submitTestModel,
          builder: ((context, snapshot) {
            List<SubmitTestModel> data = snapshot.data as List<SubmitTestModel>;
            if (data.isEmpty) {
              return Center(child: Text('No tests submitted yet!'));
            }
            return Container(
              padding: EdgeInsets.all(25),
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return addCard(data[index]);
                },
                separatorBuilder: (context, index) {
                  return SizedBox(height: 15);
                },
                itemCount: (data.length / 2).ceil(),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget addCard(SubmitTestModel submitTestModel) {
    return Container(
      height: 200,
      width: double.infinity,
      padding: EdgeInsets.all(25),
      margin: EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Pallete.fifthColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Pallete.mainColor,
            blurRadius: 2,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            width: 125,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  submitTestModel.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Pallete.mainColor,
                  ),
                  maxLines: 3,
                ),
                Container(
                  width: 100,
                  child: addButton(
                    context: context,
                    text: 'Show',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserTestInfoPage(
                              submitTestModel: submitTestModel),
                        ),
                      );
                    },
                    fullColor: true,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Average Rate: ${submitTestModel.band}',
                  style: TextStyle(
                    color: Pallete.mainColor,
                  ),
                ),
                Container(
                  height: 1,
                  width: 75,
                  color: Pallete.mainColor,
                ),
                Text(
                  'Reading Rate: ${submitTestModel.readingBand}',
                  style: TextStyle(
                    color: Pallete.mainColor,
                  ),
                ),
                Text(
                  'Listening Rate: ${submitTestModel.listeningBand}',
                  style: TextStyle(
                    color: Pallete.mainColor,
                  ),
                ),
                Text(
                  'Writing Rate: ${submitTestModel.writingBand}',
                  style: TextStyle(
                    color: Pallete.mainColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
