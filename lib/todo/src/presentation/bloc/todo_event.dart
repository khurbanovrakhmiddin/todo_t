part of 'todo_bloc.dart';

abstract class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object> get props => [];
}

class LoadTodosEvent extends TodoEvent {}

class AddTodoEvent extends TodoEvent {
  final String title;
  final DateTime? time;

  const AddTodoEvent({required this.title, this.time});

  @override
  List<Object> get props => [title, time ?? ''];
}

class UpdateTodoStatusEvent extends TodoEvent {
  final int taskId;
  final TodoStatus newStatus;

  const UpdateTodoStatusEvent({required this.taskId, required this.newStatus});

  @override
  List<Object> get props => [taskId, newStatus];
}

class UpdateTodoDetailsEvent extends TodoEvent {
  final int taskId;
  final String newTitle;
  final DateTime? newTime;

  const UpdateTodoDetailsEvent({
    required this.taskId,
    required this.newTitle,
    this.newTime,
  });

  @override
  List<Object> get props => [taskId, newTitle, newTime ?? ''];
}

class DeleteTodoEvent extends TodoEvent {
  final int taskId;

  const DeleteTodoEvent(this.taskId);

  @override
  List<Object> get props => [taskId];
}
