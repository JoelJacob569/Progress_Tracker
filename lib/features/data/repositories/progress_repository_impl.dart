import 'package:sqflite/sqflite.dart';
import '../../domain/entities/progress_entry.dart';
import '../../domain/repositories/progress_repository.dart';
import '../data_sources/local_database.dart';
import '../models/progress_entry_model.dart';

class ProgressRepositoryImpl implements ProgressRepository {
  @override
  Future<void> markDayDone({
    required int trackId,
    required DateTime date,
    String? note,
  }) async {
    final db = await LocalDatabase.database;
    final model = ProgressEntryModel(
      trackId: trackId,
      date: DateTime(date.year, date.month, date.day),
      isDone: true,
      note: note,
    );

    await db.insert(
      'progress_entries',
      model.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> unmarkDay({required int trackId, required DateTime date}) async {
    final db = await LocalDatabase.database;
    await db.delete(
      'progress_entries',
      where: 'track_id = ? AND date = ?',
      whereArgs: [
        trackId,
        DateTime(date.year, date.month, date.day).toIso8601String(),
      ],
    );
  }

  @override
  Future<List<ProgressEntry>> getProgressForRange({
    required int trackId,
    required DateTime start,
    required DateTime end,
  }) async {
    final db = await LocalDatabase.database;

    final result = await db.query(
      'progress_entries',
      where: 'track_id = ? AND date BETWEEN ? AND ?',
      whereArgs: [trackId, start.toIso8601String(), end.toIso8601String()],
    );

    return result.map((e) => ProgressEntryModel.fromMap(e)).toList();
  }
}
