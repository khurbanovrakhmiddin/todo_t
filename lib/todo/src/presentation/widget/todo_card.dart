import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../player/src/core/parser/status_parser.dart';
import '../../../../player/src/core/parser/time_parser.dart';
import '../../core/todo_colors.dart';
import '../../domain/model/todo_model.dart';
import '../bloc/todo_bloc.dart';
import 'custom_card.dart';

enum TodoMenuOption { delete }

class TodoCard extends StatelessWidget {
  final TodoModel task;

  const TodoCard({super.key, required this.task});

  void _showMenu(BuildContext context, Offset position) async {
    final result = await showMenu<TodoMenuOption>(
      color: Colors.white,
      context: context,
      position: RelativeRect.fromRect(
        position & const Size(40, 40),
        Offset.zero & MediaQuery.sizeOf(context),
      ),
      items: [
        PopupMenuItem<TodoMenuOption>(
          value: TodoMenuOption.delete,
          child: Row(
            children: [
              Icon(Icons.delete_outline, color: Colors.black38),
              SizedBox(width: 8),
              Text(
                'Удалить',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );

    if (result == TodoMenuOption.delete) {
      if (task.id != null) {
        if (context.mounted) {
          context.read<TodoBloc>().add(DeleteTodoEvent(task.id!));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dataStringId = task.id;

    if (dataStringId == null) {
      return const SizedBox.shrink();
    }

    return LongPressDraggable<int>(
      data: dataStringId,
      feedback: CustomCard(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            task.title,
            style: const TextStyle(
              color: Colors.black,
              decoration: TextDecoration.none,
              fontSize: 16,
            ),
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: _buildTaskCardContent(context),
      ),
      child: _buildTaskCardContent(context),
    );
  }

  Widget _buildTaskCardContent(BuildContext context) {
    final status = StatusParser.getStatus(task.time);

    return CustomCard(
      child: InkWell(
        onTap: () {
          final RenderBox renderBox = context.findRenderObject() as RenderBox;
          final offset = renderBox.localToGlobal(Offset.zero);
          _showMenu(context, offset);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(Icons.bookmark, color: AppColors.red, size: 20),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            task.title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const SizedBox(width: 2),

                  Icon(Icons.calendar_today_outlined, size: 18),
                  const SizedBox(width: 4),

                  Text(
                    AppTimeParser.time(task.time),
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
                  ),

                  if (status.$2.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: status.$1,
                        ),
                        child: Text(
                          status.$2,
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
