import '../repositories/progress_repository.dart';

class MarkDayDone {
  final ProgressRepository repository;

  MarkDayDone(this.repository);

  Future<void> call({
    required int trackId,
    required DateTime date,
    String? note,
  }) {
    return repository.markDayDone(trackId: trackId, date: date, note: note);
  }
}
