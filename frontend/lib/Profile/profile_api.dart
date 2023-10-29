// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../components.dart';
import '../consts.dart';
import 'model/user_model.dart';

Future<UserModel> getProfile() async {
  var token = await getToken();
  var response = await http.get(
    Uri.parse('$localhost/ielts/profiles/profile/'),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'JWT $token',
    },
  );

  if (response.statusCode == 200) {
    var item = jsonDecode(response.body);

    UserModel user = UserModel.fromJson(item);
    return user;
  } else {
    throw Exception('Fail');
  }
}

Future editProfile(UserModel userModel) async {
  var token = await getToken();
  var response = await http.put(
    Uri.parse('$localhost/ielts/profiles/profile-edit/'),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'JWT $token',
    },
    body: jsonEncode({
        "username": userModel.username,
        "email_address": userModel.email,
        "password": userModel.password,
        "firstname": userModel.firstname,
        "lastname": userModel.lastname,
        "phone_number": userModel.phoneNumber,
        "ielts_band_score": userModel.bandScore,
        "language_proficiency": userModel.languageProficiency,
        "study_plan": userModel.studyPlan == 'Academic' ? 'A' : 'G'
      },),
  );
  // print(response.body);
}
