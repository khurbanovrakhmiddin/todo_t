import '../model/todo_model.dart';
import '../repository/todo_repository.dart';

class AddTodoUseCase {
  final TodoRepository repository;

  AddTodoUseCase(this.repository);

  Future<TodoModel> call({required String title, DateTime? time}) {
    return repository.addTodo(title, time);
  }
}
