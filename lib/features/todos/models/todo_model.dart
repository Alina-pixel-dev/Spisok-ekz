class Todo {
  final int? id;
  final String title;
  final String description;
  final bool isCompleted;
  final int categoryId;

  Todo({
    this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.categoryId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'is_completed': isCompleted ? 1 : 0,
      'category_id': categoryId,
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      isCompleted: map['is_completed'] == 1,
      categoryId: map['category_id'],
    );
  }
}