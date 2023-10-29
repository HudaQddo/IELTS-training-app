import 'package:frontend/Test/model/question_model.dart';

class ReadingModel {
  int id;
  int test;
  String title;
  String text;
  int difficultyLevel;
  List<QuestionModel> questions;

  ReadingModel({
    required this.id,
    required this.test,
    required this.title,
    required this.text,
    required this.difficultyLevel,
    required this.questions,
  });

  factory ReadingModel.fromJson(json) {
    if (json == null) {
      return ReadingModel(
        id: 0,
        test: 0,
        title: '',
        text: '',
        difficultyLevel: 0,
        questions: [],
      );
    }
    List<QuestionModel> q = [];
    for (var item in json['questions']) {
      q.add(QuestionModel.fromJson(item));
    }
    return ReadingModel(
      id: json['id'],
      test: json['test'],
      title: json['title'],
      text: json['text'],
      difficultyLevel: json['difficulty_level'],
      questions: q,
    );
  }
}
