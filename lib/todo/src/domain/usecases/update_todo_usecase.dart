import '../repository/todo_repository.dart';

class UpdateTodoDetailsUseCase {
  final TodoRepository repository;

  UpdateTodoDetailsUseCase(this.repository);

  Future<void> call({
    required int taskId,
    required String newTitle,
    DateTime? newTime,
  }) {
    return repository.updateTodoDetails(taskId, newTitle, newTime);
  }
}
