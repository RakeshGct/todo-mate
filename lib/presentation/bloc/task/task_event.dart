import 'package:equatable/equatable.dart';
import '../../../domain/entities/task.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class TaskLoadRequested extends TaskEvent {
  final String userId;

  const TaskLoadRequested(this.userId);

  @override
  List<Object?> get props => [userId];
}

class TaskCreateRequested extends TaskEvent {
  final Task task;

  const TaskCreateRequested(this.task);

  @override
  List<Object?> get props => [task];
}

class TaskUpdateRequested extends TaskEvent {
  final Task task;

  const TaskUpdateRequested(this.task);

  @override
  List<Object?> get props => [task];
}

class TaskDeleteRequested extends TaskEvent {
  final String taskId;

  const TaskDeleteRequested(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

class TaskToggleStatusRequested extends TaskEvent {
  final String taskId;

  const TaskToggleStatusRequested(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

class TaskFilterChanged extends TaskEvent {
  final TaskPriority? priority;
  final bool? status;

  const TaskFilterChanged({this.priority, this.status});

  @override
  List<Object?> get props => [priority, status];
}

class TasksUpdated extends TaskEvent {
  final List<Task> tasks;
  final String? error;

  const TasksUpdated(this.tasks, this.error);

  @override
  List<Object?> get props => [tasks, error];
}
