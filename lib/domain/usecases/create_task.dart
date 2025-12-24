import 'package:dartz/dartz.dart' hide Task;
import 'package:todo_mate/core/error/failures.dart';
import 'package:todo_mate/domain/repositories/task_repository.dart';
import '../entities/task.dart';

class CreateTask {
  final TaskRepository repository;

  CreateTask(this.repository);

  Future<Either<Failure, Task>> call(Task task) async {
    return await repository.createTask(task);
  }
}
