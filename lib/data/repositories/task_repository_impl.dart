import 'package:dartz/dartz.dart' hide Task;
import 'package:todo_mate/core/error/failures.dart';

import '../../domain/repositories/task_repository.dart';
import '../../domain/entities/task.dart';
import '../datasources/task_remote_datasource.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource remoteDataSource;

  TaskRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Task>>> getTasks(String userId) async {
    try {
      final tasks = await remoteDataSource.getTasks(userId);
      return Right(tasks);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Task>> createTask(Task task) async {
    try {
      final taskModel = TaskModel.fromEntity(task);
      final createdTask = await remoteDataSource.createTask(taskModel);
      return Right(createdTask);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Task>> updateTask(Task task) async {
    try {
      final taskModel = TaskModel.fromEntity(task);
      final updatedTask = await remoteDataSource.updateTask(taskModel);
      return Right(updatedTask);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTask(String taskId) async {
    try {
      await remoteDataSource.deleteTask(taskId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Task>> toggleTaskStatus(String taskId) async {
    try {
      final task = await remoteDataSource.toggleTaskStatus(taskId);
      return Right(task);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<Either<Failure, List<Task>>> watchTasks(String userId) {
    try {
      return remoteDataSource
          .watchTasks(userId)
          .map((tasks) => Right<Failure, List<Task>>(tasks));
    } catch (e) {
      return Stream.value(Left(ServerFailure(e.toString())));
    }
  }
}
