class Difficulty {
  late final int id;
  late final String name;
  late final int pts;

  Difficulty({
    required this.id,
    required this.name,
    required this.pts
  });

  Difficulty.fromMap(Map<String, Object?> map) {
    id = map['id']! as int;
    name = map['name'].toString();
    pts = map['pts'] as int;
  }
}