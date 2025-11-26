import 'package:task_note_player/player/src/data/remote/data_sources/player_ds.dart';
import 'package:task_note_player/player/src/data/repository/player_repository.dart';
import 'package:task_note_player/player/src/domain/usecases/dislike_usecase.dart';
import 'package:task_note_player/player/src/domain/usecases/get_content_usecase.dart';
import 'package:task_note_player/player/src/domain/usecases/like_content_usecase.dart';
import 'package:task_note_player/player/src/presentation/bloc/theme_cubit.dart';
import 'package:task_note_player/todo/src/domain/usecases/delete_todo_usecase.dart';
import 'package:task_note_player/player/src/presentation/content_view/bloc/content_cubit.dart';
import 'package:task_note_player/todo/src/presentation/bloc/todo_bloc.dart';

import 'todo/src/data/local/data_sources/todo_db.dart';
import 'todo/src/data/repository/todo_repository.dart';
import 'todo/src/domain/repository/todo_repository.dart';
import 'todo/src/domain/usecases/add_todo_usecase.dart';
import 'todo/src/domain/usecases/get_todo_usecase.dart';
import 'todo/src/domain/usecases/update_todo_status_usecase.dart';
import 'todo/src/domain/usecases/update_todo_usecase.dart';

final di = Injector();

Future<void> init() async {
  final todoDatabase = TodoDatabase.instance;

  final repositoryImpl = TodoRepositoryImpl(todoDatabase);
  final contentDS = PlayerRemoteDataSourceImpl();
  final contentRepo = PlayerRepositoryImpl(contentDS);

  final getTodosUseCase = GetTodosUseCase(repositoryImpl);
  final addTodoUseCase = AddTodoUseCase(repositoryImpl);
  final updateTodoStatusUseCase = UpdateTodoStatusUseCase(repositoryImpl);
  final updateTodoDetailsUseCase = UpdateTodoDetailsUseCase(repositoryImpl);
  final deleteTodoUseCase = DeleteTodoUseCase(repositoryImpl);

  final disLikeContentUseCase = DisLikeContentUseCase(contentRepo);
  final likeContentUseCase = LikeContentUseCase(contentRepo);
  final getContentUseCase = GetContentsUseCase(contentRepo);

  final todoBloc = TodoBloc(
    getTodosUseCase,
    addTodoUseCase,
    updateTodoStatusUseCase,
    updateTodoDetailsUseCase,
    deleteTodoUseCase,
  );
  final content = ContentCubit(
    getContentUseCase,
    likeContentUseCase,
    disLikeContentUseCase,
  );
  final theme = ThemeCubit();
  di.registerLazy<TodoDatabase>(() => todoDatabase);

  di.registerLazy<TodoRepository>(() => repositoryImpl);

  di.registerLazy<GetTodosUseCase>(() => getTodosUseCase);
  di.registerLazy<AddTodoUseCase>(() => addTodoUseCase);
  di.registerLazy<UpdateTodoStatusUseCase>(() => updateTodoStatusUseCase);
  di.registerLazy<UpdateTodoDetailsUseCase>(() => updateTodoDetailsUseCase);
  di.registerLazy<DeleteTodoUseCase>(() => deleteTodoUseCase);

  di.registerLazy<TodoBloc>(() => todoBloc);
  di.registerLazy<ContentCubit>(() => content);
  di.registerLazy<ThemeCubit>(() => theme);
}

//Custom Get_It
class Injector {
  final _map = <Type, dynamic>{};

  void register<T>(T i) => _map[T] = i;

  void registerLazy<T>(T Function() f) => _map[T] = f;

  T get<T>() {
    final value = _map[T];
    if (value is Function) {
      final i = value();
      _map[T] = i;
      return i;
    }
    return value;
  }
}
