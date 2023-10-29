class ShortAnswerModel{
  int id;
  String correctAnswer;

  ShortAnswerModel({
    required this.id,
    required this.correctAnswer,
  });

  factory ShortAnswerModel.fromJson(json) {
    if (json == null) {
      return ShortAnswerModel(
        id: -1,
        correctAnswer: '',
      );
    }
    return ShortAnswerModel(
      id: json['id'],
      correctAnswer: json['correct_answer'],
    );
  }
}