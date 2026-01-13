import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/create_track.dart';
import '../../domain/usecases/delete_track.dart';
import '../../domain/usecases/get_tracks.dart';
import 'track_event.dart';
import 'track_state.dart';

class TrackBloc extends Bloc<TrackEvent, TrackState> {
  final GetTracks getTracks;
  final CreateTrack createTrack;
  final DeleteTrack deleteTrack;

  TrackBloc({
    required this.getTracks,
    required this.createTrack,
    required this.deleteTrack,
  }) : super(TrackInitial()) {
    on<LoadTracks>(_onLoadTracks);
    on<AddTrackEvent>(_onAddTrack);
    on<DeleteTrackEvent>(_onDeleteTrack);
  }

  Future<void> _onLoadTracks(LoadTracks event, Emitter<TrackState> emit) async {
    emit(TrackLoading());
    try {
      final tracks = await getTracks();
      emit(TrackLoaded(tracks));
    } catch (e) {
      emit(TrackError('Failed to load tracks'));
    }
  }

  Future<void> _onAddTrack(
    AddTrackEvent event,
    Emitter<TrackState> emit,
  ) async {
    try {
      await createTrack(event.track);
      final tracks = await getTracks();
      emit(TrackLoaded(tracks));
    } catch (e) {
      emit(TrackError('Failed to add track'));
    }
  }

  Future<void> _onDeleteTrack(
    DeleteTrackEvent event,
    Emitter<TrackState> emit,
  ) async {
    try {
      await deleteTrack(event.trackId);
      final tracks = await getTracks();
      emit(TrackLoaded(tracks));
    } catch (e) {
      emit(TrackError('Failed to delete track'));
    }
  }
}
