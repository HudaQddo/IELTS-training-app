class MultipleChoiceModel {
  int id;
  String answerOne;
  String answerTwo;
  String answerThree;
  String answerFour;
  String correctAnswer;

  MultipleChoiceModel({
    required this.id,
    required this.answerOne,
    required this.answerTwo,
    required this.answerThree,
    required this.answerFour,
    required this.correctAnswer,
  });

  factory MultipleChoiceModel.fromJson(json) {
    if (json == null) {
      return MultipleChoiceModel(
        id: -1,
        answerOne: '',
        answerTwo: '',
        answerThree: '',
        answerFour: '',
        correctAnswer: '',
      );
    }
    return MultipleChoiceModel(
      id: json['id'],
      answerOne: json['answer_one'],
      answerTwo: json['answer_two'],
      answerThree: json['answer_three'] ?? '',
      answerFour: json['answer_four'] ?? '',
      correctAnswer: json['correct_answer'],
    );
  }
}
