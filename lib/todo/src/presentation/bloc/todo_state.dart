part of 'todo_bloc.dart';

class TodoState extends Equatable {
  final List<TodoModel> allTasks;
  final bool isLoading;
  final String? error;

  const TodoState({required this.allTasks, this.isLoading = false, this.error});

  factory TodoState.initial() =>
      const TodoState(allTasks: [], isLoading: false);

  TodoState copyWith({
    List<TodoModel>? allTasks,
    bool? isLoading,
    String? error,
  }) {
    return TodoState(
      allTasks: allTasks ?? this.allTasks,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [allTasks, isLoading, error];
}
