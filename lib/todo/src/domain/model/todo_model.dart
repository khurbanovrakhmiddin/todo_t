import 'package:flutter/material.dart';

import 'package:equatable/equatable.dart';

class TodoModel extends Equatable {
  final int? id;
  final String title;
  final TodoStatus status;
  final DateTime? time;

  const TodoModel({
    this.id,
    required this.title,
    required this.status,
    this.time,
  }) : assert(id != null);

  const TodoModel.create({
    required this.title,
    this.status = TodoStatus.toDo,
    this.time,
  }) : id = null;

  factory TodoModel.fromJson(Map<String, dynamic> map) {
    final int? idValue = map['id'] as int?;

    return TodoModel(
      id: idValue,
      title: map['title'] as String,
      status: TodoStatus.values.firstWhere(
        (e) => e.toString() == 'TodoStatus.${map['status']}',
        orElse: () => TodoStatus.toDo,
      ),
      time: map['time'] != null && map['time'] is int
          ? DateTime.fromMillisecondsSinceEpoch(map['time'] as int)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'title': title,
      'status': status.name,
      'time': time?.millisecondsSinceEpoch,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  TodoModel copyWith({
    int? id,
    String? title,
    TodoStatus? status,
    DateTime? time,
  }) {
    return TodoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      status: status ?? this.status,
      time: time ?? this.time,
    );
  }

  @override
  List<Object?> get props => [id, title, status, time];
}

enum TodoStatus {
  toDo('К выполнению', Colors.blue),
  inProgress('В работе', Colors.orange),
  inReview('На проверке', Colors.purple),
  done('Выполнено', Colors.green);

  final String title;
  final Color color;

  const TodoStatus(this.title, this.color);
}
