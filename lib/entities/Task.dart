class Task {
  int? id;
  late String name;
  late DateTime createdAt;
  late bool isFavorite;
  DateTime? deletedAt;

  Task({
    this.id,
    required this.name,
    required this.createdAt,
    required this.isFavorite,
    this.deletedAt
  });

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