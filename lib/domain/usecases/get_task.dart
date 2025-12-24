import 'package:dartz/dartz.dart' hide Task;
import 'package:todo_mate/core/error/failures.dart';
import 'package:todo_mate/domain/repositories/task_repository.dart';
import '../entities/task.dart';

class GetTasks {
  final TaskRepository repository;

  GetTasks(this.repository);

  Future<Either<Failure, List<Task>>> call(String userId) async {
    return await repository.getTasks(userId);
  }
}
