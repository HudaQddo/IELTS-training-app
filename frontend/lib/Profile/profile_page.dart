// ignore_for_file: prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, prefer_const_constructors, sort_child_properties_last, sized_box_for_whitespace, unused_local_variable

import 'package:flutter/material.dart';
import 'package:frontend/Profile/edit_page.dart';
import 'package:frontend/Profile/model/user_model.dart';
import 'package:frontend/Profile/profile_api.dart';
import 'package:frontend/components.dart';
import 'package:frontend/pallete.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserModel userModel = UserModel(
    id: 0,
    username: '',
    email: '',
    firstname: '',
    lastname: '',
    password: '',
    phoneNumber: '',
    bandScore: 0,
    languageProficiency: '',
    studyPlan: '',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: addNavigationBar(context, 'Profile'),
      body: SafeArea(
        child: FutureBuilder<UserModel>(
            future: getProfile(),
            initialData: userModel,
            builder: ((context, snapshot) {
              UserModel data = snapshot.data as UserModel;
              return Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Stack(
                          alignment: AlignmentDirectional.topCenter,
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 40),
                              height: 200,
                              decoration: BoxDecoration(
                                color: Pallete.mainColor,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(150),
                                  bottomRight: Radius.circular(150),
                                ),
                              ),
                            ),
                            // Full Name
                            Container(
                              padding: EdgeInsets.all(50),
                              child: Text(
                                '${data.firstname} ${data.lastname}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 3,
                                ),
                              ),
                            ),
                          ],
                        ),
                        // User Icon
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                              color: Pallete.secondColor,
                              width: 2,
                            ),
                          ),
                          child: CircleAvatar(
                            child: Icon(
                              Icons.person,
                              size: 50,
                              color: Pallete.mainColor,
                            ),
                            backgroundColor: Colors.white,
                            radius: 50,
                          ),
                        )
                      ],
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Email
                            addRow(data.email, Icons.mail),
                            SizedBox(height: 10),
                            addLine(),
                            // Username
                            addRow(data.username, Icons.text_format),
                            SizedBox(height: 10),
                            addLine(),
                            // Band Score
                            addRow(
                                '${data.bandScore.toString()} - average of score',
                                Icons.rate_review),
                            SizedBox(height: 10),
                            addLine(),
                            // Language Proficiency
                            addRow(data.languageProficiency, Icons.language),
                            SizedBox(height: 10),
                            addLine(),
                            // Study Plan
                            addRow(data.studyPlan, Icons.menu_book),
                            SizedBox(height: 10),
                            addLine(),
                            // Phone Number
                            addRow(data.phoneNumber, Icons.phone),
                            SizedBox(height: 10),
                            addLine(),
                            // Edit Profile
                            SizedBox(height: 25),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width - 100,
                                  child: addButton(
                                    context: context,
                                    text: 'Edit Profile',
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditPage(userModel: data),
                                        ),
                                      );
                                    },
                                    fullColor: true,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            })),
      ),
    );
  }

  addLine() {
    return Container(
      height: 2,
      color: Colors.grey.shade400,
    );
  }

  addRow(text, icon) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25, horizontal: 50),
      child: Row(
        children: [
          Icon(icon),
          SizedBox(width: 25),
          Text(text),
        ],
      ),
    );
  }
}
