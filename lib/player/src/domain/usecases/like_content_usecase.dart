import '../model/content_model.dart';
import '../repository/player_repository.dart';

class LikeContentUseCase {
  final PlayerRepository repository;

  LikeContentUseCase(this.repository);

  Future<ContentModel> call(int contentId) {
    return repository.likeContent(contentId);
  }
}
