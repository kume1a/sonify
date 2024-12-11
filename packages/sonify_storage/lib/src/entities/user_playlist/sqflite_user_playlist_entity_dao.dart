import 'package:sqflite/sqflite.dart';

import '../../db/db_batch.dart';
import '../../db/sqlite_helpers.dart';
import '../../db/tables.dart';
import '../../shared/constant.dart';
import '../../shared/util.dart';
import '../../shared/wrapped.dart';
import 'user_playlist_entity.dart';
import 'user_playlist_entity_dao.dart';
import 'user_playlist_entity_mapper.dart';

class SqfliteUserPlaylistEntityDao implements UserPlaylistEntityDao {
  SqfliteUserPlaylistEntityDao(
    this._db,
    this._userPlaylistEntityMapper,
  );

  final Database _db;
  final UserPlaylistEntityMapper _userPlaylistEntityMapper;

  @override
  Future<String> insert(
    UserPlaylistEntity entity, {
    DbBatchProvider? batchProvider,
  }) async {
    final insertEntity = entity.copyWith(
      id: Wrapped(entity.id ?? newDBId()),
    );

    final entityMap = _userPlaylistEntityMapper.entityToMap(insertEntity);

    if (batchProvider != null) {
      batchProvider.get.insert(
        UserPlaylist_.tn,
        entityMap,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } else {
      await _db.insert(
        UserPlaylist_.tn,
        entityMap,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    return insertEntity.id ?? kInvalidId;
  }

  @override
  Future<int> deleteByIds(List<String> ids) async {
    return _db.delete(
      UserPlaylist_.tn,
      where: '${PlaylistAudio_.id} IN ${sqlListPlaceholders(ids.length)}',
      whereArgs: ids,
    );
  }

  @override
  Future<List<UserPlaylistEntity>> getAllByUserId(String userId) async {
    final res = await _db.rawQuery(
      '''
        SELECT
          ${UserPlaylist_.tn}.${UserPlaylist_.id},
          ${UserPlaylist_.tn}.${UserPlaylist_.createdAtMillis},
          ${UserPlaylist_.tn}.${UserPlaylist_.userId},
          ${UserPlaylist_.tn}.${UserPlaylist_.playlistId},
          ${UserPlaylist_.tn}.${UserPlaylist_.isSpotifySavedPlaylist},
          ${Playlist_.tn}.${Playlist_.id} AS ${Playlist_.joinedId},
          ${Playlist_.tn}.${Playlist_.createdAtMillis} AS ${Playlist_.joinedCreatedAtMillis},
          ${Playlist_.tn}.${Playlist_.name} AS ${Playlist_.joinedName},
          ${Playlist_.tn}.${Playlist_.thumbnailPath} AS ${Playlist_.joinedThumbnailPath},
          ${Playlist_.tn}.${Playlist_.thumbnailUrl} AS ${Playlist_.joinedThumbnailUrl},
          ${Playlist_.tn}.${Playlist_.spotifyId} AS ${Playlist_.joinedSpotifyId},
          ${Playlist_.tn}.${Playlist_.audioImportStatus} AS ${Playlist_.joinedAudioImportStatus},
          ${Playlist_.tn}.${Playlist_.audioCount} AS ${Playlist_.joinedAudioCount},
          ${Playlist_.tn}.${Playlist_.totalAudioCount} AS ${Playlist_.joinedTotalAudioCount}
        FROM ${UserPlaylist_.tn}
        LEFT JOIN ${Playlist_.tn} ON ${UserPlaylist_.tn}.${UserPlaylist_.playlistId} = ${Playlist_.tn}.${Playlist_.id}
        WHERE ${UserPlaylist_.tn}.${UserPlaylist_.userId} = ?;
      ''',
      [userId],
    );

    return res.map(_userPlaylistEntityMapper.mapToEntity).toList();
  }

  @override
  Future<List<String>> getAllIdsByUserId(String userId) {
    final res = _db.query(
      UserPlaylist_.tn,
      columns: [UserPlaylist_.id],
      where: '${UserPlaylist_.userId} = ?',
      whereArgs: [userId],
    );

    return res.then((value) => value.map((e) => e[UserPlaylist_.id] as String).toList());
  }

  @override
  Future<UserPlaylistEntity?> getById(String id) async {
    final res = await _db.rawQuery(
      '''
        SELECT
          ${UserPlaylist_.tn}.*,
          ${Playlist_.tn}.${Playlist_.id} AS ${Playlist_.joinedId},
          ${Playlist_.tn}.${Playlist_.createdAtMillis} AS ${Playlist_.joinedCreatedAtMillis},
          ${Playlist_.tn}.${Playlist_.name} AS ${Playlist_.joinedName},
          ${Playlist_.tn}.${Playlist_.thumbnailPath} AS ${Playlist_.joinedThumbnailPath},
          ${Playlist_.tn}.${Playlist_.thumbnailUrl} AS ${Playlist_.joinedThumbnailUrl},
          ${Playlist_.tn}.${Playlist_.spotifyId} AS ${Playlist_.joinedSpotifyId},
          ${Playlist_.tn}.${Playlist_.audioImportStatus} AS ${Playlist_.joinedAudioImportStatus},
          ${Playlist_.tn}.${Playlist_.audioCount} AS ${Playlist_.joinedAudioCount},
          ${Playlist_.tn}.${Playlist_.totalAudioCount} AS ${Playlist_.joinedTotalAudioCount}
        FROM ${UserPlaylist_.tn}
        LEFT JOIN ${Playlist_.tn} ON ${UserPlaylist_.tn}.${UserPlaylist_.playlistId} = ${Playlist_.tn}.${Playlist_.id}
        WHERE ${UserPlaylist_.tn}.${UserPlaylist_.id} = ?;
      ''',
      [id],
    );

    return res.map(_userPlaylistEntityMapper.mapToEntity).firstOrNull;
  }

  @override
  Future<void> deleteById(String id) {
    return _db.delete(
      UserPlaylist_.tn,
      where: '${UserPlaylist_.id} = ?',
      whereArgs: [id],
    );
  }
}
