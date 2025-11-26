import '../model/todo_model.dart';
import '../repository/todo_repository.dart';

class UpdateTodoStatusUseCase {
  final TodoRepository repository;

  UpdateTodoStatusUseCase(this.repository);

  Future<bool> call({
    required int taskId,
    required TodoModel? todo,
    required TodoStatus newStatus,
  }) {
    if (todo == null) {
      return Future.value(false);
    }

    return repository.updateTodoStatus(todo.copyWith(status: newStatus));
  }
}
