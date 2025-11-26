import '../../domain/model/todo_model.dart';
import '../../domain/repository/todo_repository.dart';
import '../local/data_sources/todo_db.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoDatabase _db;

  const TodoRepositoryImpl(this._db);

  @override
  Future<List<TodoModel>> getTodos() async {
    final maps = await _db.getTodos();
    return maps;
  }

  @override
  Future<TodoModel> addTodo(String title, DateTime? time) async {
    if (title.trim().isEmpty) {
      throw Exception("Tititle ne mojet bit pustim");
    }

    final newTodo = TodoModel.create(title: title.trim(), time: time);
    final id = await _db.insertTodo(newTodo);
    return newTodo.copyWith(id: id);
  }

  @override
  Future<bool> updateTodoStatus(TodoModel todo) async {
    final res = await _db.updateTodoStatus(todo);

    if (res == 1) return true;
    return false;
  }

  @override
  Future<void> updateTodoDetails(
    int taskId,
    String newTitle,
    DateTime? newTime,
  ) async {
    final modelToUpdate = TodoModel(
      id: taskId,
      title: newTitle,
      status: TodoStatus.toDo,
      time: newTime,
    );

    await _db.updateTodo(modelToUpdate);
  }

  @override
  Future<void> deleteTodo(int taskId) async {
    await _db.deleteTodo(taskId);
  }
}
