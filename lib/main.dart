import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_note_player/player/src/presentation/bloc/theme_cubit.dart';
import 'package:task_note_player/player/src/presentation/content_view/bloc/content_cubit.dart';
import 'package:task_note_player/todo/src/presentation/bloc/todo_bloc.dart';

import 'app.dart';
import 'di_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => di.get<TodoBloc>()),
        BlocProvider(create: (context) => di.get<ThemeCubit>()),
        BlocProvider(
          create: (context) => di.get<ContentCubit>()..loadContent(),
        ),
      ],
      child: const App(),
    ),
  );
}
