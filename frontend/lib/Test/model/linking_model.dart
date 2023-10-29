class LinkingModel {
  int id;
  String correctAnswer;

  LinkingModel({
    required this.id,
    required this.correctAnswer,
  });

  factory LinkingModel.fromJson(json) {
    if (json == null) {
      return LinkingModel(
        id: -1,
        correctAnswer: '',
      );
    }
    return LinkingModel(
      id: json['id'],
      correctAnswer: json['correct_answer'],
    );
  }
}
