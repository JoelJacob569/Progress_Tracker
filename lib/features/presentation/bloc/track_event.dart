import '../../domain/entities/track.dart';

abstract class TrackEvent {}

class LoadTracks extends TrackEvent {}

class AddTrackEvent extends TrackEvent {
  final Track track;
  AddTrackEvent(this.track);
}

class DeleteTrackEvent extends TrackEvent {
  final int trackId;
  DeleteTrackEvent(this.trackId);
}
