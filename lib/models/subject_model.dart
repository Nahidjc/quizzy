class Subject {
  final String id;
  final String userId;
  final String categoryId;
  final String name;
  final String displayName;
  final bool isActive;
  final bool isFeature;
  final DateTime createdAt;
  final DateTime modifiedAt;

  Subject({
    required this.id,
    required this.userId,
    required this.categoryId,
    required this.name,
    required this.displayName,
    required this.isActive,
    required this.isFeature,
    required this.createdAt,
    required this.modifiedAt,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json['_id'],
      userId: json['userId'],
      categoryId: json['categoryId'],
      name: json['name'],
      displayName: json['displayName'],
      isActive: json['isActive'],
      isFeature: json['isFeature'],
      createdAt: DateTime.parse(json['createdAt']),
      modifiedAt: DateTime.parse(json['modifiedAt']),
    );
  }
}
