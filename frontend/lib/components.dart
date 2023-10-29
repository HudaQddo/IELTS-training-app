// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_web_libraries_in_flutter, sized_box_for_whitespace, avoid_unnecessary_containers, avoid_print

import 'dart:convert';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:frontend/Test/model/test_model.dart';
import 'package:frontend/Test/test_page.dart';
import 'package:frontend/mainPage.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'Profile/profile_page.dart';
import 'consts.dart';
import 'myTest/user_tests_page.dart';
import 'pallete.dart';
import 'package:http/http.dart' as http;

addNavigationBar(context, activePage) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
    height: 55,
    decoration: BoxDecoration(
      color: Pallete.mainColor,
      borderRadius: BorderRadius.circular(15),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        addIcon(context, Icons.book, activePage, 'User Tests'),
        addIcon(context, Icons.home, activePage, 'Home Page'),
        addIcon(context, Icons.person, activePage, 'Profile'),
      ],
    ),
  );
}

addIcon(context, icon, activePage, text) {
  return InkWell(
    onTap: () {
      if (text == 'Profile') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfilePage(),
          ),
        );
      } else if (text == 'Home Page') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MainPage(),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserTestsPage(),
          ),
        );
      }
    },
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (text == activePage)
          Container(
            height: 3,
            width: 20,
            color: Colors.white,
          ),
        if (text == activePage) SizedBox(height: 5),
        Icon(
          icon,
          color: Colors.white,
          size: text == activePage ? 35 : null,
        ),
      ],
    ),
  );
}

addForm({
  required String text,
  required TextInputType textInputType,
  required TextEditingController controller,
  required GlobalKey<FormState> formkey,
  bool obscureText = false,
  FunctionStringCallback? onChanged,
  FunctionStringCallback? onSubmit,
  var validator,
  bool readOnly = false,
}) {
  return Form(
    key: formkey,
    child: TextFormField(
      readOnly: readOnly,
      controller: controller,
      keyboardType: textInputType,
      obscureText: obscureText,
      onChanged: onChanged,
      onFieldSubmitted: onSubmit,
      validator: validator,
      decoration: InputDecoration(
        // contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        // labelText: text,
        hintText: text,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(
            width: 2,
            color: Colors.grey.shade300,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(
            width: 2,
            color: Pallete.secondColor,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(
            width: 2,
            color: Colors.red,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(
            width: 2,
            color: Colors.red,
          ),
        ),
      ),
    ),
  );
}

addButton({
  required context,
  required text,
  required onTap,
  fullColor = false,
}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      decoration: BoxDecoration(
        gradient: fullColor
            ? LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Pallete.mainColor,
                  Pallete.secondColor,
                ],
              )
            : null,
        border: fullColor
            ? null
            : Border.all(
                color: Pallete.mainColor,
                width: 1.5,
              ),
        borderRadius: BorderRadius.circular(100),
        // color: fullColor ? null : Colors.white,
        // boxShadow: fullColor ? null : [
        //   BoxShadow(
        //     color: Pallete.mainColor,
        //     blurRadius: 4,
        //   ),
        // ],
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: fullColor ? Colors.white : Pallete.mainColor,
          ),
        ),
      ),
    ),
  );
}

addTimer({
  required String text,
  required int startSecond,
}) {
  return Container(
    width: double.infinity,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        SizedBox(height: 50),
        CircularPercentIndicator(
          radius: 100.0,
          lineWidth: 13.0,
          // animation: true,
          percent: 1 - startSecond / 10,
          center: Text(
            "$startSecond",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
          circularStrokeCap: CircularStrokeCap.round,
          progressColor: Pallete.mainColor,
        ),
      ],
    ),
  );
}

addTitle(text) {
  return Text(
    text,
    style: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
  );
}

addCardTest(context, TestModel model) {
  return InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TestPage(testID: model.id),
        ),
      );
    },
    child: Container(
      width: 200,
      height: 200,
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
          color: Pallete.secondColor, borderRadius: BorderRadius.circular(25)),
      child: Center(child: Text(model.title)),
    ),
  );
}

Future<String> getToken() async {
  var response = await http.post(
    Uri.parse('$localhost/auth/jwt/create/'),
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    },
    body: {
      "username": usernameLocal,
      "password": passwordLocal,
    },
    encoding: Encoding.getByName("utf-8"),
  );
  var responseData = jsonDecode(response.body);
  return responseData['access'];
}
