import '../../domain/entities/track.dart';

class TrackModel extends Track {
  TrackModel({
    super.id,
    required super.name,
    required super.startDate,
    required super.endDate,
    required super.createdAt,
  });

  factory TrackModel.fromMap(Map<String, dynamic> map) {
    return TrackModel(
      id: map['id'],
      name: map['name'],
      startDate: DateTime.parse(map['start_date']),
      endDate: DateTime.parse(map['end_date']),
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}
