import 'package:collection/collection.dart';
import 'package:common_models/common_models.dart';
import 'package:sonify_storage/sonify_storage.dart';

import '../../audio/util/delete_unused_local_audio.dart';
import '../model/user_audio.dart';
import '../util/compare_audio_titles.dart';
import '../util/user_audio_mapper.dart';
import 'user_audio_local_repository.dart';

class UserAudioLocalRepositoryImpl with ResultWrap implements UserAudioLocalRepository {
  UserAudioLocalRepositoryImpl(
    this._userAudioEntityDao,
    this._userAudioMapper,
    this._deleteUnusedLocalAudio,
  );

  final UserAudioEntityDao _userAudioEntityDao;
  final UserAudioMapper _userAudioMapper;
  final DeleteUnusedLocalAudio _deleteUnusedLocalAudio;

  @override
  Future<Result<List<UserAudio>>> getAll({
    required String userId,
    String? searchQuery,
  }) {
    return wrapWithResult(() async {
      final audioEntities = await _userAudioEntityDao.getAll(
        userId: userId,
        searchQuery: searchQuery,
      );

      return audioEntities
          .sorted((a, b) {
            final aTitle = a.audio?.title?.toLowerCase() ?? '';
            final bTitle = b.audio?.title?.toLowerCase() ?? '';

            return compareAudioTitles(aTitle, bTitle);
          })
          .map(_userAudioMapper.entityToModel)
          .toList();
    });
  }

  @override
  Future<Result<UserAudio>> create(UserAudio userAudio) async {
    return wrapWithResult(() async {
      final mappedEntity = _userAudioMapper.modelToEntity(userAudio);

      final insertedEntity = await _userAudioEntityDao.insert(mappedEntity);

      return _userAudioMapper.entityToModel(insertedEntity);
    });
  }

  @override
  Future<Result<int>> deleteByAudioIds(List<String> ids) async {
    final audioIdsRes = await wrapWithResult(() => _userAudioEntityDao.getAudioIdsByIds(ids));
    if (audioIdsRes.isErr) {
      return Result.err();
    }

    final deleteResult = await wrapWithResult(() => _userAudioEntityDao.deleteByAudioIds(ids));

    final deleteUnusedAudiosRes = await _deleteUnusedLocalAudio.deleteByIds(audioIdsRes.dataOrThrow);
    if (deleteUnusedAudiosRes.isErr) {
      return Result.err();
    }

    return deleteResult;
  }

  @override
  Future<Result<List<String>>> getAllAudioIdsByUserId(String userId) {
    return wrapWithResult(() => _userAudioEntityDao.getAllAudioIdsByUserId(userId));
  }

  @override
  Future<Result<UserAudio?>> getByUserIdAndAudioId({
    required String userId,
    required String audioId,
  }) {
    return wrapWithResult(() async {
      final res = await _userAudioEntityDao.getByUserIdAndAudioId(userId: userId, audioId: audioId);

      return res != null ? _userAudioMapper.entityToModel(res) : null;
    });
  }

  @override
  Future<EmptyResult> deleteById(String id) async {
    final audioIdRes = await wrapWithResult(() => _userAudioEntityDao.getAudioIdById(id));
    if (audioIdRes.isErr || audioIdRes.dataOrNull == null) {
      return EmptyResult.err();
    }

    final deleteRes = await wrapWithEmptyResult(() => _userAudioEntityDao.deleteById(id));

    final deleteUnusedAudioRes = await _deleteUnusedLocalAudio.deleteById(audioIdRes.dataOrThrow!);
    if (deleteUnusedAudioRes.isErr) {
      return EmptyResult.err();
    }

    return deleteRes;
  }

  @override
  Future<EmptyResult> deleteAllByUserId(String userId) async {
    final allAudioIdsRes = await wrapWithResult(() => _userAudioEntityDao.getAllAudioIdsByUserId(userId));
    if (allAudioIdsRes.isErr) {
      return EmptyResult.err();
    }

    final futures = allAudioIdsRes.dataOrThrow.map((audioId) async {
      final deleteRes = await wrapWithEmptyResult(
        () => _userAudioEntityDao.deleteByUserIdAndAudioId(
          audioId: audioId,
          userId: userId,
        ),
      );

      if (deleteRes.isErr) {
        return EmptyResult.err();
      }

      return _deleteUnusedLocalAudio.deleteById(audioId);
    });

    final results = await Future.wait(futures);

    return results.every((res) => res.isSuccess) ? EmptyResult.success() : EmptyResult.err();
  }

  @override
  Future<Result<int>> getCountByUserId(String userId) {
    return wrapWithResult(() => _userAudioEntityDao.getCountByUserId(userId));
  }

  @override
  Future<Result<List<UserAudio>>> createMany(List<UserAudio> userAudios) {
    return wrapWithResult(() async {
      final entities = userAudios.map(_userAudioMapper.modelToEntity).toList();

      final insertedEntities = await _userAudioEntityDao.insertMany(entities);

      return insertedEntities.map(_userAudioMapper.entityToModel).toList();
    });
  }

  @override
  Future<Result<bool>> existsByUserIdAndAudioId({
    required String userId,
    required String audioId,
  }) {
    return wrapWithResult(
      () => _userAudioEntityDao.existsByUserIdAndAudioId(
        userId: userId,
        audioId: audioId,
      ),
    );
  }
}
