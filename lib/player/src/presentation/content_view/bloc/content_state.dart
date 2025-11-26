part of 'content_cubit.dart';

class ContentState extends Equatable {
  final FetchStatus status;
  final List<ContentModel> contentList;
  final String errorMessage;

  const ContentState({
    this.status = FetchStatus.init,
    this.contentList = const [],
    this.errorMessage = '',
  });

  ContentState copyWith({
    FetchStatus? status,
    List<ContentModel>? contentList,
    String? errorMessage,
  }) {
    return ContentState(
      status: status ?? this.status,
      contentList: contentList ?? this.contentList,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [status, contentList, errorMessage];
}
