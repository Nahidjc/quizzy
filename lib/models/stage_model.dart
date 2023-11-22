class StageData {
  String id;
  String levelName;
  int cost;
  bool isAccessible;

  StageData({
    required this.id,
    required this.levelName,
    required this.cost,
    required this.isAccessible,
  });

  factory StageData.fromJson(Map<String, dynamic> json) {
    return StageData(
      id: json['id'],
      levelName: json['levelName'],
      cost: json['cost'] as int? ?? 0,
      isAccessible: json['isAccessible'],
    );
  }
}

class StageDataResponse {
  List<StageData> data;

  StageDataResponse({
    required this.data,
  });

  factory StageDataResponse.fromJson(Map<String, dynamic> json) {
    var dataList = json['data'] as List<dynamic>;
    List<StageData> stages =
        dataList.map((data) => StageData.fromJson(data)).toList();
    return StageDataResponse(
      data: stages,
    );
  }
}
