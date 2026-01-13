import '../entities/progress_entry.dart';
import '../repositories/progress_repository.dart';

class GetProgressRange {
  final ProgressRepository repository;

  GetProgressRange(this.repository);

  Future<List<ProgressEntry>> call({
    required int trackId,
    required DateTime start,
    required DateTime end,
  }) {
    return repository.getProgressForRange(
      trackId: trackId,
      start: start,
      end: end,
    );
  }
}
