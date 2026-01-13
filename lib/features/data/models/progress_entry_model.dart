import '../../domain/entities/progress_entry.dart';

class ProgressEntryModel extends ProgressEntry {
  ProgressEntryModel({
    super.id,
    required super.trackId,
    required super.date,
    required super.isDone,
    super.note,
  });

  factory ProgressEntryModel.fromMap(Map<String, dynamic> map) {
    return ProgressEntryModel(
      id: map['id'],
      trackId: map['track_id'],
      date: DateTime.parse(map['date']),
      isDone: map['is_done'] == 1,
      note: map['note'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'track_id': trackId,
      'date': date.toIso8601String(),
      'is_done': isDone ? 1 : 0,
      'note': note,
    };
  }
}
