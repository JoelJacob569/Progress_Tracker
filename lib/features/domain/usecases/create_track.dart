import '../entities/track.dart';
import '../repositories/track_repository.dart';

class CreateTrack {
  final TrackRepository repository;

  CreateTrack(this.repository);

  Future<int> call(Track track) {
    return repository.createTrack(track);
  }
}
