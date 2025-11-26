import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../todo/src/domain/usecases/add_todo_usecase.dart';
import '../../../../todo/src/domain/usecases/delete_todo_usecase.dart';
import '../../../../todo/src/domain/usecases/get_todo_usecase.dart';
import '../../../../todo/src/domain/usecases/update_todo_status_usecase.dart';
import '../../../../todo/src/domain/usecases/update_todo_usecase.dart';
import '../../domain/model/todo_model.dart';

part 'todo_event.dart';

part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final GetTodosUseCase _getTodosUseCase;
  final AddTodoUseCase _addTodoUseCase;
  final UpdateTodoStatusUseCase _updateTodoStatusUseCase;
  final UpdateTodoDetailsUseCase _updateTodoDetailsUseCase;
  final DeleteTodoUseCase _deleteTodoUseCase;

  TodoBloc(
    this._getTodosUseCase,
    this._addTodoUseCase,
    this._updateTodoStatusUseCase,
    this._updateTodoDetailsUseCase,
    this._deleteTodoUseCase,
  ) : super(TodoState.initial()) {
    on<LoadTodosEvent>(_onLoadTodos);
    on<AddTodoEvent>(_onAddTodo);
    on<UpdateTodoStatusEvent>(_onUpdateTodoStatus);
    on<UpdateTodoDetailsEvent>(_onUpdateTodoDetails);
    on<DeleteTodoEvent>(_onDeleteTodo);

    add(LoadTodosEvent());
  }

  void _onLoadTodos(LoadTodosEvent event, Emitter<TodoState> emit) async {
    try {
      emit(state.copyWith(isLoading: true, error: null));

      final tasks = await _getTodosUseCase.call();

      emit(state.copyWith(allTasks: tasks, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: 'Ne udalos zagruzit: $e'));
    }
  }

  void _onAddTodo(AddTodoEvent event, Emitter<TodoState> emit) async {
    if (event.title.trim().isEmpty) return;

    try {
      final newTodoWithId = await _addTodoUseCase.call(
        title: event.title.trim(),
        time: event.time,
      );

      final newTasks = [...state.allTasks, newTodoWithId];

      emit(state.copyWith(allTasks: newTasks));
    } catch (e) {
      emit(state.copyWith(error: 'Ne udalos sozdat'));
    }
  }

  void _onUpdateTodoStatus(
    UpdateTodoStatusEvent event,
    Emitter<TodoState> emit,
  ) async {
    final updatedTasks = state.allTasks.map((task) {
      if (task.id == event.taskId) {
        return task.copyWith(status: event.newStatus);
      }
      return task;
    }).toList();

    emit(state.copyWith(allTasks: updatedTasks));

    try {
      final model = state.allTasks
          .where((e) => e.id == event.taskId)
          .firstOrNull;
      final res = await _updateTodoStatusUseCase.call(
        todo: model,
        taskId: event.taskId,
        newStatus: event.newStatus,
      );

      if (res) {
        final updatedList = state.allTasks.map((task) {
          if (task.id == event.taskId) {
            return task.copyWith(status: event.newStatus);
          }
          return task;
        }).toList();
        emit(state.copyWith(allTasks: updatedList));
      }
    } catch (e) {
      emit(state.copyWith(error: 'Ne udalos soxranit statis'));
    }
  }

  void _onUpdateTodoDetails(
    UpdateTodoDetailsEvent event,
    Emitter<TodoState> emit,
  ) async {
    final updatedTasks = state.allTasks.map((task) {
      if (task.id == event.taskId) {
        return task.copyWith(title: event.newTitle, time: event.newTime);
      }
      return task;
    }).toList();

    emit(state.copyWith(allTasks: updatedTasks));

    try {
      await _updateTodoDetailsUseCase.call(
        taskId: event.taskId,
        newTitle: event.newTitle,
        newTime: event.newTime,
      );
    } catch (e) {
      emit(state.copyWith(error: 'Ne udalos soxranit'));
    }
  }

  void _onDeleteTodo(DeleteTodoEvent event, Emitter<TodoState> emit) async {
    final updatedTasks = state.allTasks
        .where((task) => task.id != event.taskId)
        .toList();

    emit(state.copyWith(allTasks: updatedTasks));

    try {
      await _deleteTodoUseCase.call(event.taskId);
    } catch (e) {
      emit(state.copyWith(error: 'Ne udalos udalit'));
    }
  }
}
