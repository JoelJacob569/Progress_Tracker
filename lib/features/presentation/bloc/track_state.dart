import '../../domain/entities/track.dart';

abstract class TrackState {}

class TrackInitial extends TrackState {}

class TrackLoading extends TrackState {}

class TrackLoaded extends TrackState {
  final List<Track> tracks;
  TrackLoaded(this.tracks);
}

class TrackError extends TrackState {
  final String message;
  TrackError(this.message);
}
