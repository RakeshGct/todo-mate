import 'package:dartz/dartz.dart' hide Task;
import 'package:todo_mate/core/error/failures.dart';
import '../entities/task.dart';

abstract class TaskRepository {
  Future<Either<Failure, List<Task>>> getTasks(String userId);
  Future<Either<Failure, Task>> createTask(Task task);
  Future<Either<Failure, Task>> updateTask(Task task);
  Future<Either<Failure, void>> deleteTask(String taskId);
  Future<Either<Failure, Task>> toggleTaskStatus(String taskId);
  Stream<Either<Failure, List<Task>>> watchTasks(String userId);
}
