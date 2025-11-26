import '../../domain/model/content_model.dart';
import '../../domain/repository/player_repository.dart';
import '../remote/data_sources/player_ds.dart';

class PlayerRepositoryImpl implements PlayerRepository {
  final PlayerRemoteDataSource remoteDataSource;

  PlayerRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<ContentModel>> getContents() {
    return remoteDataSource.getContents();
  }

  @override
  Future<ContentModel> likeContent(int contentId) {
    return remoteDataSource.likeContent(contentId);
  }

  @override
  Future<ContentModel> dislikeContent(int contentId) {
    return remoteDataSource.dislikeContent(contentId);
  }
}
