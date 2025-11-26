import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/todo_colors.dart';
import '../../domain/model/todo_model.dart';
import '../bloc/todo_bloc.dart';
import '../dialog/create_dialog.dart';
import '../widget/category_group_tile.dart';

class MainTodoPage extends StatefulWidget {
  const MainTodoPage({super.key});

  @override
  State<MainTodoPage> createState() => _MainTodoPageState();
}

class _MainTodoPageState extends State<MainTodoPage> {
  void _showTaskBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return const TaskBottomSheet();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Todo'),
        backgroundColor: Colors.white,
        actions: [
          MaterialButton(
            minWidth: 48,
            height: 48,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            color: AppColors.brandPrimary,
            onPressed: _showTaskBottomSheet,
            child: const Icon(Icons.add, color: Colors.white),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.error != null) {
            return Center(child: Text('Ошибка: ${state.error}'));
          }

          List<TodoModel> getTasksByStatus(TodoStatus status) {
            return state.allTasks
                .where((task) => task.status == status)
                .toList();
          }

          void updateTodoStatus(int taskId, TodoStatus newStatus) {
            context.read<TodoBloc>().add(
              UpdateTodoStatusEvent(taskId: taskId, newStatus: newStatus),
            );
          }

          return SafeArea(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: TodoStatus.values.map((status) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: CategoryGroupTile(
                      key: ValueKey(status),
                      status: status,
                      tasks: getTasksByStatus(status),
                      onTaskDrop: updateTodoStatus,
                    ),
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}
