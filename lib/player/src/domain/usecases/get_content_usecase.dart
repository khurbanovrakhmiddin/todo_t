import '../model/content_model.dart';
import '../repository/player_repository.dart';

class GetContentsUseCase {
  final PlayerRepository repository;

  GetContentsUseCase(this.repository);

  Future<List<ContentModel>> call() {
    return repository.getContents();
  }
}
