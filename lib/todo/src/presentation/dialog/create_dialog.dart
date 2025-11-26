import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../core/todo_colors.dart';
import '../bloc/todo_bloc.dart';

class TaskBottomSheet extends StatefulWidget {
  const TaskBottomSheet({super.key});

  @override
  State<TaskBottomSheet> createState() => _TaskBottomSheetState();
}

class _TaskBottomSheetState extends State<TaskBottomSheet> {
  DateTime? _selectedDateTime;
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  bool get _isFormValid => _taskController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _updateDateController(null);
  }

  @override
  void dispose() {
    _taskController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _updateDateController(DateTime? dateTime) {
    String text;
    if (dateTime != null) {
      text = DateFormat('dd.MM.yyyy HH:mm').format(dateTime);
    } else {
      text = '';
    }
    _dateController.text = text;
  }

  Future<void> _selectDateTime() async {
    final initialDateTime = _selectedDateTime ?? DateTime.now();

    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: initialDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (date == null) return;

    if (context.mounted) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDateTime),
      );

      if (time == null) return;

      setState(() {
        _selectedDateTime = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
        _updateDateController(_selectedDateTime);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Создание задачи", style: TextStyle(fontSize: 24)),
                IconButton(
                  onPressed: () => Navigator.maybePop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _taskController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                labelText: 'Задача',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _dateController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Выберите дату и время',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                suffixIcon: const Icon(Icons.calendar_today_outlined),
              ),
              onTap: _selectDateTime,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: Colors.grey.shade200,
                    ),
                    onPressed: () => Navigator.maybePop(context),
                    child: const Text(
                      'Отмена',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: _isFormValid
                          ? AppColors.brandPrimary
                          : AppColors.brandPrimaryInActive,
                    ),
                    onPressed: _isFormValid
                        ? () {
                            context.read<TodoBloc>().add(
                              AddTodoEvent(
                                title: _taskController.text,
                                time: _selectedDateTime,
                              ),
                            );

                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Задача "${_taskController.text}" успешно создана!',
                                ),
                              ),
                            );
                          }
                        : null,
                    child: const Text(
                      'Применить',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
