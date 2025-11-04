class Task {
  final int? id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final bool isCompleted;
  final String category;

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    this.isCompleted = false,
    required this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startDate': startDate.millisecondsSinceEpoch,
      'endDate': endDate.millisecondsSinceEpoch,
      'isCompleted': isCompleted ? 1 : 0,
      'category': category,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      startDate: DateTime.fromMillisecondsSinceEpoch(map['startDate']),
      endDate: DateTime.fromMillisecondsSinceEpoch(map['endDate']),
      isCompleted: map['isCompleted'] == 1,
      category: map['category'],
    );
  }

  Task copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    bool? isCompleted,
    String? category,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isCompleted: isCompleted ?? this.isCompleted,
      category: category ?? this.category,
    );
  }
}