import '../entities/progress_entry.dart';

abstract class ProgressRepository {
  Future<void> markDayDone({
    required int trackId,
    required DateTime date,
    String? note,
  });

  Future<void> unmarkDay({required int trackId, required DateTime date});

  Future<List<ProgressEntry>> getProgressForRange({
    required int trackId,
    required DateTime start,
    required DateTime end,
  });
}
