// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:frontend/Test/model/test_model.dart';
import 'package:frontend/Test/test_api.dart';
import 'package:frontend/components.dart';

import 'Test/test_page.dart';
import 'pallete.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<TestModel> testModel = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: addNavigationBar(context, 'Home Page'),
      body: SafeArea(
        child: FutureBuilder<List<TestModel>>(
          future: getAllTests(),
          initialData: testModel,
          builder: ((context, snapshot) {
            List<TestModel> data = snapshot.data as List<TestModel>;
            return Container(
              padding: EdgeInsets.all(25),
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      addCard(data[index * 2]),
                      if(index * 2 + 1 < data.length)addCard(data[index * 2 + 1]),
                    ],
                  );
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

  Widget addCard(TestModel model) {
    return Container(
      height: 175,
      width: 175,
      padding: EdgeInsets.all(25),
      margin: EdgeInsets.all(10),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            model.title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              color: Pallete.mainColor,
            ),
          ),
          Container(
            width: 100,
            height: 35,
            child: addButton(
              context: context,
              text: 'Start Test',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TestPage(testID: model.id),
                  ),
                );
              },
              fullColor: true,
            ),
          ),
        ],
      ),
    );
  }
}
