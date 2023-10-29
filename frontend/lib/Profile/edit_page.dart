// ignore_for_file: implementation_imports, unnecessary_import, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, prefer_const_constructors, sized_box_for_whitespace, unused_import, unused_local_variable, no_logic_in_create_state

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:frontend/Login/login_page.dart';
import 'package:frontend/Profile/model/user_model.dart';
import 'package:frontend/Profile/profile_api.dart';
import 'package:frontend/Profile/profile_page.dart';
import 'package:frontend/mainPage.dart';
import 'package:frontend/pallete.dart';
import 'package:http/http.dart' as http;
import '../components.dart';
import '../consts.dart';

class EditPage extends StatefulWidget {
  final UserModel userModel;
  const EditPage({required this.userModel, super.key});

  @override
  State<EditPage> createState() => _EditPageState(userModel: userModel);
}

class _EditPageState extends State<EditPage> {
  var emailController = TextEditingController();
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var phoneNumberController = TextEditingController();
  var bandScoreController = TextEditingController();

  var formKeyEmail = GlobalKey<FormState>();
  var formKeyUsername = GlobalKey<FormState>();
  var formKeyPassword = GlobalKey<FormState>();
  var formKeyConfirmPassword = GlobalKey<FormState>();
  var formKeyFirstName = GlobalKey<FormState>();
  var formKeyLastName = GlobalKey<FormState>();
  var formKeyPhoneNumber = GlobalKey<FormState>();
  var formKeyBandScore = GlobalKey<FormState>();

  String valueLanguageProficiency = 'Beginner';
  String valueStudyPlan = 'Academic';

  bool editPass = false;
  UserModel userModel;
  _EditPageState({required this.userModel});
  @override
  void initState() {
    super.initState();
    setInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: addNavigationBar(context, ''),
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
                        'Edit Profile',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        'Edit your information',
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
                      // Email
                      Container(
                        padding: EdgeInsets.only(left: 20, bottom: 10),
                        child: Text(
                          'Email',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      addForm(
                        text: 'eg: email@gmail.com',
                        textInputType: TextInputType.emailAddress,
                        controller: emailController,
                        formkey: formKeyEmail,
                        onChanged: (value) {
                          setState(() {
                            if (formKeyEmail.currentState!.validate()) {}
                          });
                        },
                        onSubmit: (value) {
                          setState(() {
                            if (formKeyEmail.currentState!.validate()) {}
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email must not empty';
                          } else if (!value.endsWith('@gmail.com') ||
                              value.length <= 10) {
                            return 'Invalid email format';
                          }
                        },
                      ),
                      SizedBox(height: 20),
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
                        textInputType: TextInputType.text,
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
                      // Full Name
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // First Name
                              Container(
                                padding: EdgeInsets.only(left: 20, bottom: 10),
                                child: Text(
                                  'First Name',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                width:
                                    MediaQuery.of(context).size.width / 2 - 60,
                                child: addForm(
                                  text: 'First Name',
                                  textInputType: TextInputType.text,
                                  controller: firstNameController,
                                  formkey: formKeyFirstName,
                                  onChanged: (value) {
                                    setState(() {
                                      if (formKeyFirstName.currentState!
                                          .validate()) {}
                                    });
                                  },
                                  onSubmit: (value) {
                                    setState(() {
                                      if (formKeyFirstName.currentState!
                                          .validate()) {}
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'First name must not empty';
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Last Name
                              Container(
                                padding: EdgeInsets.only(left: 20, bottom: 10),
                                child: Text(
                                  'Last Name',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                width:
                                    MediaQuery.of(context).size.width / 2 - 60,
                                child: addForm(
                                  text: 'Last Name',
                                  textInputType: TextInputType.text,
                                  controller: lastNameController,
                                  formkey: formKeyLastName,
                                  onChanged: (value) {
                                    setState(() {
                                      if (formKeyLastName.currentState!
                                          .validate()) {}
                                    });
                                  },
                                  onSubmit: (value) {
                                    setState(() {
                                      if (formKeyLastName.currentState!
                                          .validate()) {}
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Last name must not empty';
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Checkbox(
                            value: editPass,
                            onChanged: (value) {
                              setState(() {
                                editPass = value!;
                              });
                            },
                          ),
                          Text('Edit Password'),
                        ],
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
                        text: 'At least 8 characters',
                        textInputType: TextInputType.visiblePassword,
                        controller: passwordController,
                        formkey: formKeyPassword,
                        obscureText: true,
                        readOnly: !editPass,
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
                          } else if (value.length < 8) {
                            return 'Password is too short';
                          }
                        },
                      ),
                      SizedBox(height: 20),
                      // Confirm Password
                      Container(
                        padding: EdgeInsets.only(left: 20, bottom: 10),
                        child: Text(
                          'Confirm Password',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      addForm(
                        text: 'Confirm Password',
                        textInputType: TextInputType.visiblePassword,
                        controller: confirmPasswordController,
                        formkey: formKeyConfirmPassword,
                        obscureText: true,
                        readOnly: !editPass,
                        onChanged: (value) {
                          setState(() {
                            if (formKeyConfirmPassword.currentState!
                                .validate()) {}
                          });
                        },
                        onSubmit: (value) {
                          setState(() {
                            if (formKeyConfirmPassword.currentState!
                                .validate()) {}
                          });
                        },
                        validator: (value) {
                          if (value != passwordController.text) {
                            return 'Password dose not match';
                          }
                        },
                      ),
                      SizedBox(height: 20),
                      // Phone Number & Band Score
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Phone Number
                              Container(
                                padding: EdgeInsets.only(left: 20, bottom: 10),
                                child: Text(
                                  'Phone Number',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                width:
                                    MediaQuery.of(context).size.width / 2 - 60,
                                child: addForm(
                                  text: 'Phone Number',
                                  textInputType: TextInputType.phone,
                                  controller: phoneNumberController,
                                  formkey: formKeyPhoneNumber,
                                  onChanged: (value) {
                                    setState(() {
                                      if (formKeyPhoneNumber.currentState!
                                          .validate()) {}
                                    });
                                  },
                                  onSubmit: (value) {
                                    setState(() {
                                      if (formKeyPhoneNumber.currentState!
                                          .validate()) {}
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Phone Number can\'t be empty';
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Band Score
                              Container(
                                padding: EdgeInsets.only(left: 20, bottom: 10),
                                child: Text(
                                  'Band Score',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                width:
                                    MediaQuery.of(context).size.width / 2 - 60,
                                child: addForm(
                                  text: 'Band Score',
                                  textInputType: TextInputType.text,
                                  controller: bandScoreController,
                                  formkey: formKeyBandScore,
                                  onChanged: (value) {
                                    setState(() {
                                      if (formKeyBandScore.currentState!
                                          .validate()) {}
                                    });
                                  },
                                  onSubmit: (value) {
                                    setState(() {
                                      if (formKeyBandScore.currentState!
                                          .validate()) {}
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Band Score can\'t be empty';
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      // Language Proficiency
                      Container(
                        padding: EdgeInsets.only(left: 20, bottom: 10),
                        child: Text(
                          'Language Proficiency',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 20, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: valueLanguageProficiency == 'Beginner',
                                  onChanged: (value) {
                                    setState(() {
                                      valueLanguageProficiency = 'Beginner';
                                    });
                                  },
                                ),
                                Text('Beginner'),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value: valueLanguageProficiency ==
                                      'Intermediate',
                                  onChanged: (value) {
                                    setState(() {
                                      valueLanguageProficiency = 'Intermediate';
                                    });
                                  },
                                ),
                                Text('Intermediate'),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value: valueLanguageProficiency == 'Advanced',
                                  onChanged: (value) {
                                    setState(() {
                                      valueLanguageProficiency = 'Advanced';
                                    });
                                  },
                                ),
                                Text('Advanced'),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      // Study Plan
                      Container(
                        padding: EdgeInsets.only(left: 20, bottom: 10),
                        child: Text(
                          'Study Plan',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 20, bottom: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Checkbox(
                                    value: valueStudyPlan == 'Academic',
                                    onChanged: (value) {
                                      setState(() {
                                        valueStudyPlan = 'Academic';
                                      });
                                    },
                                  ),
                                  Text('Academic'),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Checkbox(
                                    value: valueStudyPlan == 'General',
                                    onChanged: (value) {
                                      setState(() {
                                        valueStudyPlan = 'General';
                                      });
                                    },
                                  ),
                                  Text('General'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      // Save
                      addButton(
                        context: context,
                        text: 'Save',
                        onTap: () {
                          setState(() {
                            if (formKeyEmail.currentState!.validate() &&
                                formKeyUsername.currentState!.validate() &&
                                formKeyFirstName.currentState!.validate() &&
                                formKeyLastName.currentState!.validate() &&
                                (!editPass ||
                                    (formKeyPassword.currentState!.validate() &&
                                        formKeyConfirmPassword.currentState!
                                            .validate())) &&
                                formKeyPhoneNumber.currentState!.validate() &&
                                formKeyBandScore.currentState!.validate()) {
                              UserModel user = UserModel(
                                id: userModel.id,
                                username: usernameController.text,
                                email: emailController.text,
                                firstname: firstNameController.text,
                                lastname: lastNameController.text,
                                password: editPass
                                    ? passwordController.text
                                    : userModel.password,
                                phoneNumber: phoneNumberController.text,
                                bandScore: double.parse(bandScoreController.text),
                                languageProficiency:
                                    valueLanguageProficiency.toLowerCase(),
                                studyPlan: valueStudyPlan,
                              );
                              editProfile(user);

                              setUser(user.username, user.password);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProfilePage(),
                                ),
                              );
                            }
                          });
                        },
                        fullColor: true,
                      ),
                      SizedBox(height: 20),
                      // Cancel
                      addButton(
                        context: context,
                        text: 'Cancel',
                        onTap: () {
                          Navigator.pop(context);
                        },
                        // fullColor: true,
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

  Future createUser() async {
    var response = await http.post(
      Uri.parse('$localhost/ielts/profiles/register/'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: {
        "username": usernameController.text,
        "email_address": emailController.text,
        "password": passwordController.text,
        "firstname": firstNameController.text,
        "lastname": lastNameController.text,
        "phone_number": phoneNumberController.text,
        "ielts_band_score": bandScoreController.text,
        "language_proficiency": valueLanguageProficiency.toLowerCase(),
        "study_plan": valueStudyPlan == 'Academic' ? 'A' : 'G'
      },
      encoding: Encoding.getByName("utf-8"),
    );
    // print(response.statusCode);
    // print(response.body);
    // setUser(username, password);
    // await setToken();
    // await getBucket();
  }

  void setInfo() async {
    usernameController.text = userModel.username;
    emailController.text = userModel.email;
    firstNameController.text = userModel.firstname;
    lastNameController.text = userModel.lastname;
    phoneNumberController.text = userModel.phoneNumber;
    bandScoreController.text = userModel.bandScore.toString();
    setState(() {
      valueLanguageProficiency = userModel.languageProficiency;
      valueLanguageProficiency = valueLanguageProficiency[0].toUpperCase() +
          valueLanguageProficiency.substring(1);
      valueStudyPlan = userModel.studyPlan;
    });
  }
}
