class SubmitTestModel {
  int id;
  int user;
  int test;
  String title;
  double band;
  double readingBand;
  double listeningBand;
  double writingBand;

  SubmitTestModel({
    required this.id,
    required this.user,
    required this.test,
    required this.title,
    required this.band,
    required this.readingBand,
    required this.listeningBand,
    required this.writingBand,
  });

  factory SubmitTestModel.fromJson(json) {
    if (json == null) {
      return SubmitTestModel(
        id: -1,
        user: 0,
        test: 0,
        title: '',
        band: 7.5,
        readingBand: 7.5,
        listeningBand: 7.5,
        writingBand: 7.5,
      );
    }
    return SubmitTestModel(
      id: json['id'],
      user: json['user'],
      test: json['test'],
      title: json['title'],
      band: json['band'],
      readingBand: json['reading_band'],
      listeningBand: json['listening_band'],
      writingBand: json['writing_band'],
    );
  }
}
