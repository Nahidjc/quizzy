class QuizLevel {
  String id;
  String name;
  String displayName;

  QuizLevel({
    required this.id,
    required this.name,
    required this.displayName,
  });

  factory QuizLevel.fromJson(Map<String, dynamic> json) {
    return QuizLevel(
      id: json['id'],
      name: json['name'],
      displayName: json['displayName'],
    );
  }
}

class QuizLevelResponse {
  List<QuizLevel> data;

  QuizLevelResponse({
    required this.data,
  });

  factory QuizLevelResponse.fromJson(Map<String, dynamic> json) {
    var levelListData = json['data'] as List<dynamic>;
    List<QuizLevel> levels =
        levelListData.map((data) => QuizLevel.fromJson(data)).toList();

    return QuizLevelResponse(
      data: levels,
    );
  }
}
