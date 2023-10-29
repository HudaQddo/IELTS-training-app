// ignore_for_file: implementation_imports, unnecessary_import, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, prefer_const_constructors, sized_box_for_whitespace, unused_import, avoid_print, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:frontend/Login/signup_page.dart';
import 'package:frontend/components.dart';
import 'package:frontend/pallete.dart';
import 'package:http/http.dart' as http;
import '../consts.dart';
import '../mainPage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();
  var formKeyUsername = GlobalKey<FormState>();
  var formKeyPassword = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(50),
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Pallete.mainColor,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(60),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        'Sign in and get started',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Username
                      Container(
                        padding: EdgeInsets.only(left: 20, bottom: 10),
                        child: Text(
                          'Username',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      addForm(
                        text: 'Username',
                        textInputType: TextInputType.emailAddress,
                        controller: usernameController,
                        formkey: formKeyUsername,
                        onChanged: (value) {
                          setState(() {
                            if (formKeyUsername.currentState!.validate()) {}
                          });
                        },
                        onSubmit: (value) {
                          setState(() {
                            if (formKeyUsername.currentState!.validate()) {}
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Username must not empty';
                          }
                        },
                      ),
                      SizedBox(height: 20),
                      // Password
                      Container(
                        padding: EdgeInsets.only(left: 20, bottom: 10),
                        child: Text(
                          'Password',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      addForm(
                        text: '8 charachters',
                        textInputType: TextInputType.emailAddress,
                        controller: passwordController,
                        formkey: formKeyPassword,
                        obscureText: true,
                        onChanged: (value) {
                          setState(() {
                            if (formKeyPassword.currentState!.validate()) {}
                          });
                        },
                        onSubmit: (value) {
                          setState(() {
                            if (formKeyPassword.currentState!.validate()) {}
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password must not be empty';
                          }
                        },
                      ),
                      SizedBox(height: 20),
                      // Sign in
                      addButton(
                        context: context,
                        text: 'Sign In',
                        onTap: () async {
                          if (formKeyUsername.currentState!.validate() &&
                              formKeyPassword.currentState!.validate()) {
                            bool bol = await login();
                            if (bol) {
                              setUser(usernameController.text,
                                  passwordController.text);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MainPage(),
                                ),
                              );
                            } else {
                              _showMyDialog();
                            }
                          }
                        },
                        fullColor: true,
                      ),
                      SizedBox(height: 10),
                      // OR
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('or'),
                        ],
                      ),
                      SizedBox(height: 10),
                      // // Forgot Password
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     Text('Forgot Password'),
                      //   ],
                      // ),
                      // SizedBox(height: 50),
                      // Sign up
                      addButton(
                        context: context,
                        text: 'Sign Up',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignupPage(),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> login() async {
    var response = await http.post(
      Uri.parse('$localhost/ielts/profiles/login/'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: {
        "username": usernameController.text,
        "password": passwordController.text,
      },
      encoding: Encoding.getByName("utf-8"),
    );
    setUser(usernameController.text, passwordController.text);
    tokenUser = await getToken();
    return jsonDecode(response.body)['id'] != null;
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Login Error'),
          content: SingleChildScrollView(
            child: Text('The username does not match the password'),
          ),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
