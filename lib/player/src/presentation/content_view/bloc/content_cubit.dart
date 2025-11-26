import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/model/content_model.dart';
import '../../../domain/usecases/dislike_usecase.dart';
import '../../../domain/usecases/get_content_usecase.dart';
import '../../../domain/usecases/like_content_usecase.dart';
import '../../player/controller/player_cubit.dart';

part 'content_state.dart';

class ContentCubit extends Cubit<ContentState> {
  final GetContentsUseCase getContentsUseCase;
  final LikeContentUseCase likeContentUseCase;
  final DisLikeContentUseCase dislikeContentUseCase;

  ContentCubit(
    this.getContentsUseCase,
    this.likeContentUseCase,
    this.dislikeContentUseCase,
  ) : super(const ContentState());

  Future<void> loadContent() async {
    emit(state.copyWith(status: FetchStatus.fetch, contentList: []));
    try {
      final resultList = await getContentsUseCase.call();
      emit(
        state.copyWith(status: FetchStatus.success, contentList: resultList),
      );
    } catch (e) {
      emit(
        state.copyWith(status: FetchStatus.fail, errorMessage: e.toString()),
      );
    }
  }

  Future<void> likeContent(int contentId) async {
    try {
      final updatedContent = await likeContentUseCase.call(contentId);

      _updateContentInState(updatedContent);
    } catch (_) {}
  }

  Future<void> dislikeContent(int contentId) async {
    try {
      final updatedContent = await dislikeContentUseCase.call(contentId);

      _updateContentInState(updatedContent);
    } catch (_) {}
  }

  void _updateContentInState(ContentModel updatedContent) {
    final List<ContentModel> currentList = List.from(state.contentList);

    final index = currentList.indexWhere((c) => c.id == updatedContent.id);

    if (index != -1) {
      currentList[index] = updatedContent;

      emit(state.copyWith(contentList: currentList));
    }
  }
}
