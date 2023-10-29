import 'package:frontend/Test/model/fill_blank_model.dart';
import 'package:frontend/Test/model/linking_model.dart';
import 'package:frontend/Test/model/multiple_choice_model.dart';
import 'package:frontend/Test/model/short_answer_model.dart';

class QuestionModel {
  int id;
  int number;
  String text;
  int readingTask;
  int listeningTask;
  MultipleChoiceModel multipleChoiceModel;
  FillBlankModel fillBlankModel;
  ShortAnswerModel shortAnswerModel;
  LinkingModel linkingModel;

  QuestionModel({
    required this.id,
    required this.number,
    required this.text,
    required this.readingTask,
    required this.listeningTask,
    required this.multipleChoiceModel,
    required this.fillBlankModel,
    required this.shortAnswerModel,
    required this.linkingModel,
  });

  factory QuestionModel.fromJson(json) {
    if (json == null) {
      return QuestionModel(
        id: 0,
        number: 0,
        text: '',
        readingTask: 0,
        listeningTask: 0,
        multipleChoiceModel: MultipleChoiceModel(
          id: 0,
          answerOne: 'answerOne',
          answerTwo: 'answerTwo',
          answerThree: 'answerThree',
          answerFour: 'answerFour',
          correctAnswer: 'correctAnswer',
        ),
        fillBlankModel: FillBlankModel(
          id: 0,
          correctAnswer: 'correctAnswer',
        ),
        shortAnswerModel: ShortAnswerModel(
          id: 0,
          correctAnswer: 'correctAnswer',
        ),
        linkingModel: LinkingModel(
          id: 0,
          correctAnswer: 'correctAnswer',
        ),
      );
    }
    return QuestionModel(
      id: json['id'],
      number: json['number'],
      text: json['text'],
      readingTask: json['reading_task'] ?? -1,
      listeningTask: json['listening_task'] ?? -1,
      multipleChoiceModel: MultipleChoiceModel.fromJson(json['mc_answers']),
      fillBlankModel: FillBlankModel.fromJson(json['fitb_answers']),
      shortAnswerModel: ShortAnswerModel.fromJson(json['sha_answers']),
      linkingModel: LinkingModel.fromJson(json['lk_answers'])
    );
  }
}
