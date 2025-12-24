part of 'task_bloc.dart';

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object?> get props => [];
}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<Task> tasks;
  final List<Task> filteredTasks;
  final TaskPriority? filterPriority;
  final bool? filterStatus;

  const TaskLoaded({
    required this.tasks,
    required this.filteredTasks,
    this.filterPriority,
    this.filterStatus,
  });

  @override
  List<Object?> get props => [
    tasks,
    filteredTasks,
    filterPriority,
    filterStatus,
  ];
}

class TaskError extends TaskState {
  final String message;

  const TaskError(this.message);

  @override
  List<Object?> get props => [message];
}

class TaskOperationSuccess extends TaskState {
  final String message;

  const TaskOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class TaskOperationFailure extends TaskState {
  final String message;

  const TaskOperationFailure(this.message);

  @override
  List<Object?> get props => [message];
}
