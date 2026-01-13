import '../repositories/track_repository.dart';

class UpdateTrackName {
  final TrackRepository repository;

  UpdateTrackName(this.repository);

  Future<void> call(int trackId, String newName) {
    return repository.updateTrackName(trackId, newName);
  }
}
