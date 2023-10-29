class WritingModel {
  int id;
  String title;
  String topic;

  WritingModel({
    required this.id,
    required this.title,
    required this.topic,
  });

  factory WritingModel.fromJson(json) {
    if (json == null) {
      return WritingModel(
        id: 0,
        title: '',
        topic: '',
      );
    }
    return WritingModel(
      id: json['id'],
      title: json['title'],
      topic: json['topic'],
    );
  }
}
