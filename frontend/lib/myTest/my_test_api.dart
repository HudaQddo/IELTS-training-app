import 'dart:convert';
import 'package:http/http.dart' as http;
import '../consts.dart';
import 'models/submit_test_model.dart';

Future<List<SubmitTestModel>> getAllSubmitTests() async {
  var response = await http.get(
    Uri.parse('$localhost/ielts/test-answers/tests/'),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'JWT $tokenUser',
    },
  );
  if (response.statusCode == 200) {
    var items = jsonDecode(response.body);
    List<SubmitTestModel> submitTests = [];
    for (var item in items) {
      submitTests.add(SubmitTestModel.fromJson(item));
    }
    return submitTests;
  } else {
    throw Exception('Fail');
  }
}

Future<List<Map<int, List<String>>>> getAllAnswers(int testID) async {
  var response = await http.get(
    Uri.parse('$localhost/ielts/test-answers/tests/$testID/'),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'JWT $tokenUser',
    },
  );
  if (response.statusCode == 200) {
    var items = jsonDecode(response.body);
    // print(items);
    Map<int, List<String>> readingAnswers = {};
    Map<int, List<String>> listeningAnswers = {};
    for (var item in items) {
      if (item['question']['reading_task'] != null) {
        readingAnswers[item['question']['number']] = [
          item['answer_text'],
          item['question']['mc_answers'] != null
              ? item['question']['mc_answers']['correct_answer']
              : item['question']['fitb_answers'] != null
                  ? item['question']['fitb_answers']['correct_answer']
                  : item['question']['sha_answers']['correct_answer']
        ];
      } else {
        listeningAnswers[item['question']['number']] = [
          item['answer_text'],
          item['question']['mc_answers'] != null
              ? item['question']['mc_answers']['correct_answer']
              : item['question']['fitb_answers'] != null
                  ? item['question']['fitb_answers']['correct_answer']
                  : item['question']['lk_answers']['correct_answer']
        ];
      }
    }

    return [readingAnswers, listeningAnswers];
  } else {
    throw Exception('Fail');
  }
}

Future<String> getWriting(int testID) async {
  var response = await http.get(
    Uri.parse('$localhost/ielts/test-answers/tests/'),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'JWT $tokenUser',
    },
  );
  if (response.statusCode == 200) {
    var items = jsonDecode(response.body);
    String essay = '';
    for (var item in items) {
      if (item['test'] == testID) {
        essay = item['writing_essay'];
        break;
      }
    }
    return essay;
  } else {
    throw Exception('Fail');
  }
}
