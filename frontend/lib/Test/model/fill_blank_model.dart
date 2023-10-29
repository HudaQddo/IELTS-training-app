class FillBlankModel {
  int id;
  String correctAnswer;

  FillBlankModel({
    required this.id,
    required this.correctAnswer,
  });

  factory FillBlankModel.fromJson(json) {
    if (json == null) {
      return FillBlankModel(
        id: -1,
        correctAnswer: '',
      );
    }
    return FillBlankModel(
      id: json['id'],
      correctAnswer: json['correct_answer'],
    );
  }
}
