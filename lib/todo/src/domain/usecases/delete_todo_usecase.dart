import '../repository/todo_repository.dart';

class DeleteTodoUseCase {
  final TodoRepository repository;

  DeleteTodoUseCase(this.repository);

  Future<void> call(int taskId) {
    return repository.deleteTodo(taskId);
  }
}
