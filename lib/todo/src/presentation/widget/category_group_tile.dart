import 'package:flutter/material.dart';
import 'package:task_note_player/todo/src/presentation/widget/todo_card.dart';

import '../../domain/model/todo_model.dart';

class CategoryGroupTile extends StatefulWidget {
  final TodoStatus status;
  final List<TodoModel> tasks;
  final Function(int taskId, TodoStatus newStatus) onTaskDrop;

  const CategoryGroupTile({
    super.key,
    required this.status,
    required this.tasks,
    required this.onTaskDrop,
  });

  @override
  State<CategoryGroupTile> createState() => _CategoryGroupTileState();
}

class _CategoryGroupTileState extends State<CategoryGroupTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController expandController;
  late final Animation<double> animation;

  bool _isExpanded = true;

  @override
  void initState() {
    super.initState();
    expandController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    animation = CurvedAnimation(
      parent: expandController,
      curve: Curves.fastOutSlowIn,
    );
    expandController.forward();
  }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    if (context.mounted) {
      setState(() {
        _isExpanded = !_isExpanded;
        if (_isExpanded) {
          expandController.forward();
        } else {
          expandController.reverse();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: DragTarget<int>(
        onWillAcceptWithDetails: (data) => true,
        onMove: (s) {},
        onAcceptWithDetails: (details) {
          widget.onTaskDrop(details.data, widget.status);
        },
        builder: (context, candidateData, rejectedData) {
          bool isDraggingOver = candidateData.isNotEmpty;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              MaterialButton(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(8),
                ),
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                onPressed: _toggleExpansion,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.status.title,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const Spacer(),
                    Text(
                      widget.tasks.length.toString(),
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 12),
                    RotationTransition(
                      turns: Tween(
                        begin: 0.0,
                        end: _isExpanded ? 0.0 : -0.5,
                      ).animate(expandController),
                      child: const Icon(Icons.keyboard_arrow_down, size: 28),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),
              SizeTransition(
                axisAlignment: 1.0,
                sizeFactor: animation,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 400,
                    minHeight: 0,
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: widget.tasks.length,
                    itemBuilder: (context, index) {
                      return TodoCard(task: widget.tasks[index]);
                    },
                  ),
                ),
              ),

              if (isDraggingOver)
                Container(
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: widget.status.color.withAlpha((255.0 * 0.3).round()),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Перетащите сюда ${widget.status.title}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
