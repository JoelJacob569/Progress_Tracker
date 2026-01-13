import '../../domain/entities/track.dart';
import '../../domain/repositories/track_repository.dart';
import '../data_sources/local_database.dart';
import '../models/track_model.dart';

class TrackRepositoryImpl implements TrackRepository {
  @override
  Future<int> createTrack(Track track) async {
    final db = await LocalDatabase.database;
    final model = TrackModel(
      name: track.name,
      startDate: track.startDate,
      endDate: track.endDate,
      createdAt: track.createdAt,
    );
    return db.insert('tracks', model.toMap());
  }

  @override
  Future<List<Track>> getAllTracks() async {
    final db = await LocalDatabase.database;
    final result = await db.query('tracks', orderBy: 'created_at DESC');

    return result.map((e) => TrackModel.fromMap(e)).toList();
  }

  @override
  Future<void> updateTrackName(int trackId, String newName) async {
    final db = await LocalDatabase.database;
    await db.update(
      'tracks',
      {'name': newName},
      where: 'id = ?',
      whereArgs: [trackId],
    );
  }

  @override
  Future<void> deleteTrack(int trackId) async {
    final db = await LocalDatabase.database;
    await db.delete(
      'progress_entries',
      where: 'track_id = ?',
      whereArgs: [trackId],
    );
    await db.delete('tracks', where: 'id = ?', whereArgs: [trackId]);
  }
}
