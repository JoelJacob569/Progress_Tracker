import '../repositories/track_repository.dart';

class DeleteTrack {
  final TrackRepository repository;

  DeleteTrack(this.repository);

  Future<void> call(int trackId) {
    return repository.deleteTrack(trackId);
  }
}
