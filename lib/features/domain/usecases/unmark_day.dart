import '../repositories/progress_repository.dart';

class UnmarkDay {
  final ProgressRepository repository;

  UnmarkDay(this.repository);

  Future<void> call({required int trackId, required DateTime date}) {
    return repository.unmarkDay(trackId: trackId, date: date);
  }
}
