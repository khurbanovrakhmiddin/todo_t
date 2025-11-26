import '../model/content_model.dart';

abstract class PlayerRepository {
  Future<List<ContentModel>> getContents();
  Future<ContentModel> likeContent(int contentId);
  Future<ContentModel> dislikeContent(int contentId);
}
