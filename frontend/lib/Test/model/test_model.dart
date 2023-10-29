
class TestModel {
  int id;
  String title;
  String category;
  // List<String> writingTasks;

  TestModel({
    required this.id,
    required this.title,
    required this.category,
    // required this.writingTasks,
  });

  factory TestModel.fromJson(json) {
    if (json == null) {
      return TestModel(
        id: 0,
        title: '',
        category: '',
        // writingTasks: [],
      );
    }
    // List<String> writing = [];
    // for (var item in json['writing_tasks']) {
    //   writing.add(item);
    // }
    // print(writing);
    return TestModel(
      id: json['id'],
      title: json['title'],
      category: json['category'],
      // writingTasks: writing,
    );
  }
}
