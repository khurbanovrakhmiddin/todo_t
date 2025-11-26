import '../model/todo_model.dart';

abstract class TodoRepository {
  Future<List<TodoModel>> getTodos();

  Future<TodoModel> addTodo(String title, DateTime? time);

  Future<bool> updateTodoStatus(TodoModel todo);

  Future<void> updateTodoDetails(
    int taskId,
    String newTitle,
    DateTime? newTime,
  );

  Future<void> deleteTodo(int taskId);
}
