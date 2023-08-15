

class Task {
  String title;
  bool done;
  DateTime? reminder;

  Task(this.title, {this.done = false, this.reminder});

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'done': done,
      'reminder': reminder?.toIso8601String(),
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      json['title'],
      done: json['done'],
      reminder: json['reminder'] != null ? DateTime.parse(json['reminder']) : null,
    );
  }
}
