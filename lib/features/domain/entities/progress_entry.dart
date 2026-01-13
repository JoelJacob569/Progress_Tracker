class ProgressEntry {
  final int? id;
  final int trackId;
  final DateTime date;
  final bool isDone;
  final String? note;

  ProgressEntry({
    this.id,
    required this.trackId,
    required this.date,
    required this.isDone,
    this.note,
  });
}
