class Progress {
  late int exp;
  late int maxPts;

  Progress({
    required this.exp,
    required this.maxPts
  });

  Progress.fromMap(Map<String, Object?> map) {
    exp = map['exp'] as int;
    maxPts = map['maxPts'] as int;
  }
}