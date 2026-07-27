class Task {
  final String id;
  final String title;
  final String type;
  final bool isDone;
  Task({
    required this.id,
    required this.title,
    required this.type,
    this.isDone = false,
  });
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'type': type,
    'isDone': isDone,
  };
  factory Task.fromJson(Map<String, dynamic> json) =>
      Task(id: json['id'], title: json['title'], type: json['type']);
}
