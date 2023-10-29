// ignore_for_file: unused_local_variable, avoid_print

import 'dart:convert';
import 'package:frontend/Test/model/test_model.dart';
import 'package:frontend/Test/model/writing_model.dart';
import 'package:http/http.dart' as http;
import '../components.dart';
import '../consts.dart';
import 'model/listening_model.dart';
import 'model/reading_model.dart';

Future<List<TestModel>> getAllTests() async {
  var response = await http.get(
    Uri.parse('$localhost/ielts/tests/'),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'JWT $tokenUser',
    },
  );

  if (response.statusCode == 200) {
    var items = jsonDecode(response.body);
    List<TestModel> tests = [];
    for (var item in items) {
      tests.add(TestModel.fromJson(item));
    }
    return tests;
  } else {
    throw Exception('Fail');
  }
}

Future<List<WritingModel>> getWritingTest(int idTest) async {
  var token = await getToken();
  var response = await http.get(
    Uri.parse('$localhost/ielts/tests/$idTest/writing-tasks/'),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'JWT $token',
    },
  );
  if (response.statusCode == 200) {
    var items = jsonDecode(response.body);
    List<WritingModel> tests = [];
    for (var item in items) {
      tests.add(WritingModel.fromJson(item));
    }
    return tests;
  } else {
    throw Exception('Fail');
  }
}

Future<List<ListeningModel>> getListeningTest(int idTest) async {
  var response = await http.get(
    Uri.parse('$localhost/ielts/tests/$idTest/listening-tasks/'),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'JWT $tokenUser',
    },
  );
  if (response.statusCode == 200) {
    var items = jsonDecode(response.body);

    List<ListeningModel> tests = [];
    for (var item in items) {
      tests.add(ListeningModel.fromJson(item));
    }
    return tests;
  } else {
    throw Exception('Fail');
  }
}

Future<List<ReadingModel>> getReadingTest(int idTest) async {
  var response = await http.get(
    Uri.parse('$localhost/ielts/tests/$idTest/reading-tasks/'),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'JWT $tokenUser',
    },
  );
  if (response.statusCode == 200) {
    var items = jsonDecode(response.body);
    List<ReadingModel> tests = [];
    for (var item in items) {
      tests.add(ReadingModel.fromJson(item));
    }
    return tests;
  } else {
    throw Exception('Fail');
  }
}

Future submitAnswers(
  int username,
  int title,
  Map<int, String> questions,
  Map<int, String> answers,
) async {
  List l = [];
  for (var ans in answers.entries) {
    if (ans.value != '') {
      l.add({
        "question": {
          "number": ans.key,
          "text": questions[ans.key],
        },
        "answer_text": ans.value,
      });
    }
  }
  print(l);
  var response = await http.post(
    Uri.parse('$localhost/ielts/test-answers/submit-answers/'),
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      'Authorization': 'JWT $tokenUser',
    },
    body: jsonEncode({
      "user": username,
      "test": title,
      "answers": l,
      "writing_topic": null,
      "writing_essay": null,
    }),
    encoding: Encoding.getByName("utf-8"),
  );
}

Future submitTopic(
  int username,
  int title,
  int writingTopic,
  String writingEssay,
) async {
  var response = await http.post(
    Uri.parse('$localhost/ielts/test-answers/submit-answers/'),
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      'Authorization': 'JWT $tokenUser',
    },
    body: jsonEncode({
      "user": username,
      "test": title,
      "answers": [],
      "writing_topic": writingTopic,
      "writing_essay": writingEssay,
    }),
    encoding: Encoding.getByName("utf-8"),
  );
}
