import 'package:kaizen/entities/Difficulty.dart';
import 'package:kaizen/entities/Task.dart';

class Todo {
  int? id;
  late Task task;
  late Difficulty difficulty;
  late DateTime createdAt;
  late bool isDone;
  String? description;

  Todo({
    this.id,
    required this.task,
    required this.difficulty,
    required this.createdAt,
    required this.isDone,
    this.description
  });

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      'createdAt': createdAt,
      'isDone': isDone? 'TRUE':'FALSE',
      'taskId': task.id!,
      'difficultyId': difficulty.id!
    };
    if (id != null) {
      map['id'] = id;
    }
    if (description != null) {
      map['description'] = description;
    }
    return map;
  }

  Todo.fromMap(Map<String, Object?> map) {
    id = map['id'] as int?;
    description = map['description']?.toString();
    isDone = map['isDone'] == 'TRUE';
    createdAt = DateTime.tryParse(map['createdAt'].toString())!;
    task = Task(
        id: map['taskId']! as int,
        createdAt: DateTime.tryParse(map['task_createdAt'].toString())!,
        isFavorite: map['isFavorite'] == 'TRUE',
        name: map['task'].toString(),
        deletedAt: map['task_createdAt'] == null? null : DateTime.tryParse(map['task_createdAt'].toString())
    );
    difficulty = Difficulty(
        id: map['difficultyId']! as int,
        name: map['difficulty']!.toString(),
        pts: map['pts'] as int
    );
  }
}