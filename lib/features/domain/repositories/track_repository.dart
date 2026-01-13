import '../entities/track.dart';

abstract class TrackRepository {
  Future<int> createTrack(Track track);
  Future<List<Track>> getAllTracks();
  Future<void> updateTrackName(int trackId, String newName);
  Future<void> deleteTrack(int trackId);
}
