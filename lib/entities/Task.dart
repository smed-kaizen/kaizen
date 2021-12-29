class Task {
  int? id;
  late String name;
  late DateTime createdAt;
  late bool isFavorite;
  DateTime? deletedAt;

  Task({
    this.id,
    required this.name,
    createdAt,
    isFavorite,
    this.deletedAt
  }): createdAt = createdAt ?? DateTime.now(),
        isFavorite = isFavorite ?? false;

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      'name': name,
      'createdAt': createdAt,
      'isFavorite': isFavorite? 'TRUE':'FALSE',
    };
    if (id != null) {
      map['id'] = id;
    }
    if (deletedAt != null) {
      map['deletedAt'] = deletedAt;
    }
    return map;
  }

  Task.fromMap(Map<String, Object?> map) {
    id = map['id'] as int?;
    name = map['name'].toString();
    isFavorite = map['isFavorite'] == 'TRUE';
    createdAt = DateTime.tryParse(map['createdAt'].toString())!;
    deletedAt = DateTime.tryParse(map['deletedAt'].toString());
  }
}