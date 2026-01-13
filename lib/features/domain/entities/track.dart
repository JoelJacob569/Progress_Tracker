class Track {
  final int? id; // null before saving to DB
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime createdAt;

  Track({
    this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
  });
}
