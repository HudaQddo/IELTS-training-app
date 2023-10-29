import 'package:frontend/Test/model/question_model.dart';

class ListeningModel {
  int id;
  int test;
  String title;
  String audio;
  int difficultyLevel;
  List<QuestionModel> questions;

  ListeningModel({
    required this.id,
    required this.test,
    required this.title,
    required this.audio,
    required this.difficultyLevel,
    required this.questions,
  });

  factory ListeningModel.fromJson(json) {
    if (json == null) {
      return ListeningModel(
        id: 0,
        test: 0,
        title: '',
        audio: '',
        difficultyLevel: 0,
        questions: [],
      );
    }
    List<QuestionModel> q = [];
    for (var item in json['questions']) {
      // print(item);
      q.add(QuestionModel.fromJson(item));
    }
    return ListeningModel(
      id: json['id'],
      test: json['test'],
      title: json['title'],
      audio: json['audio'],
      difficultyLevel: json['difficulty_level'],
      questions: q,
    );
  }
}
