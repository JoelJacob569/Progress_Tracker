import 'package:flutter/material.dart';
import 'package:progress/app.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/data/repositories/track_repository_impl.dart';
//import 'features/data/repositories/progress_repository_impl.dart';
import 'features/domain/usecases/create_track.dart';
import 'features/domain/usecases/delete_track.dart';
import 'features/domain/usecases/get_tracks.dart';
import 'features/presentation/bloc/track_bloc.dart';
import 'features/presentation/bloc/track_event.dart';

void main() {
  final trackRepository = TrackRepositoryImpl();
  //final progressRepository = ProgressRepositoryImpl();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => TrackBloc(
            getTracks: GetTracks(trackRepository),
            createTrack: CreateTrack(trackRepository),
            deleteTrack: DeleteTrack(trackRepository),
          )..add(LoadTracks()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}
