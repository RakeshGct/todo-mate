import 'dart:async';
import 'package:dartz/dartz.dart' show Either;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_mate/presentation/bloc/task/task_event.dart';
import '../../../domain/entities/task.dart';
import '../../../domain/repositories/task_repository.dart';
import '../../../domain/usecases/create_task.dart';
import '../../../domain/usecases/delete_task.dart';
import '../../../domain/usecases/toggle_task_status.dart';
import '../../../domain/usecases/update_task.dart';
import '../../../core/error/failures.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final CreateTask createTask;
  final UpdateTask updateTask;
  final DeleteTask deleteTask;
  final ToggleTaskStatus toggleTaskStatus;
  final TaskRepository taskRepository;
  StreamSubscription? _taskSubscription;

  TaskBloc({
    required this.createTask,
    required this.updateTask,
    required this.deleteTask,
    required this.toggleTaskStatus,
    required this.taskRepository,
  }) : super(TaskInitial()) {
    on<TaskLoadRequested>(_onLoadRequested);
    on<TaskCreateRequested>(_onCreateRequested);
    on<TaskUpdateRequested>(_onUpdateRequested);
    on<TaskDeleteRequested>(_onDeleteRequested);
    on<TaskToggleStatusRequested>(_onToggleStatusRequested);
    on<TaskFilterChanged>(_onFilterChanged);
    on<TasksUpdated>(_onTasksUpdated);
  }

  Future<void> _onLoadRequested(
    TaskLoadRequested event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoading());

    _taskSubscription?.cancel();
    _taskSubscription = taskRepository.watchTasks(event.userId).listen((
      Either<Failure, List<Task>> result,
    ) {
      result.fold(
        (failure) => add(TasksUpdated([], failure.message)),
        (tasks) => add(TasksUpdated(tasks, null)),
      );
    });
  }

  void _onTasksUpdated(TasksUpdated event, Emitter<TaskState> emit) {
    if (event.error != null) {
      emit(TaskError(event.error!));
    } else {
      final currentState = state;
      List<Task> filteredTasks = event.tasks.cast<Task>();

      if (currentState is TaskLoaded) {
        filteredTasks = _applyFilters(
          event.tasks.cast<Task>(),
          currentState.filterPriority,
          currentState.filterStatus,
        );
      }

      emit(
        TaskLoaded(
          tasks: event.tasks.cast<Task>(),
          filteredTasks: filteredTasks,
          filterPriority: currentState is TaskLoaded
              ? currentState.filterPriority
              : null,
          filterStatus: currentState is TaskLoaded
              ? currentState.filterStatus
              : null,
        ),
      );
    }
  }

  Future<void> _onCreateRequested(
    TaskCreateRequested event,
    Emitter<TaskState> emit,
  ) async {
    final result = await createTask(event.task);
    result.fold(
      (failure) => emit(TaskOperationFailure(failure.message)),
      (_) => emit(const TaskOperationSuccess('Task created successfully')),
    );
  }

  Future<void> _onUpdateRequested(
    TaskUpdateRequested event,
    Emitter<TaskState> emit,
  ) async {
    final result = await updateTask(event.task);
    result.fold(
      (failure) => emit(TaskOperationFailure(failure.message)),
      (_) => emit(const TaskOperationSuccess('Task updated successfully')),
    );
  }

  Future<void> _onDeleteRequested(
    TaskDeleteRequested event,
    Emitter<TaskState> emit,
  ) async {
    final result = await deleteTask(event.taskId);
    result.fold(
      (failure) => emit(TaskOperationFailure(failure.message)),
      (_) => emit(const TaskOperationSuccess('Task deleted successfully')),
    );
  }

  Future<void> _onToggleStatusRequested(
    TaskToggleStatusRequested event,
    Emitter<TaskState> emit,
  ) async {
    final result = await toggleTaskStatus(event.taskId);
    result.fold(
      (failure) => emit(TaskOperationFailure(failure.message)),
      (_) => null,
    );
  }

  void _onFilterChanged(TaskFilterChanged event, Emitter<TaskState> emit) {
    if (state is TaskLoaded) {
      final currentState = state as TaskLoaded;
      final filteredTasks = _applyFilters(
        currentState.tasks,
        event.priority,
        event.status,
      );

      emit(
        TaskLoaded(
          tasks: currentState.tasks,
          filteredTasks: filteredTasks,
          filterPriority: event.priority,
          filterStatus: event.status,
        ),
      );
    }
  }

  List<Task> _applyFilters(
    List<Task> tasks,
    TaskPriority? priority,
    bool? status,
  ) {
    var filtered = tasks;

    if (priority != null) {
      filtered = filtered.where((task) => task.priority == priority).toList();
    }

    if (status != null) {
      filtered = filtered.where((task) => task.isCompleted == status).toList();
    }

    filtered.sort((a, b) => a.dueDate.compareTo(b.dueDate));

    return filtered;
  }

  @override
  Future<void> close() {
    _taskSubscription?.cancel();
    return super.close();
  }
}
