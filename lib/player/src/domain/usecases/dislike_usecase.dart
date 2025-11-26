import '../model/content_model.dart';
import '../repository/player_repository.dart';

class DisLikeContentUseCase {
  final PlayerRepository repository;

  DisLikeContentUseCase(this.repository);

  Future<ContentModel> call(int contentId) {
    return repository.dislikeContent(contentId);
  }
}
