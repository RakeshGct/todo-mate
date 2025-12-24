import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task_model.dart';

abstract class TaskRemoteDataSource {
  Future<List<TaskModel>> getTasks(String userId);
  Future<TaskModel> createTask(TaskModel task);
  Future<TaskModel> updateTask(TaskModel task);
  Future<void> deleteTask(String taskId);
  Future<TaskModel> toggleTaskStatus(String taskId);
  Stream<List<TaskModel>> watchTasks(String userId);
}

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final FirebaseFirestore firestore;
  static const String tasksCollection = 'tasks';

  TaskRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<TaskModel>> getTasks(String userId) async {
    try {
      final snapshot = await firestore
          .collection(tasksCollection)
          .where('userId', isEqualTo: userId)
          .get();

      return snapshot.docs.map((doc) => TaskModel.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to fetch tasks: $e');
    }
  }

  @override
  Future<TaskModel> createTask(TaskModel task) async {
    try {
      final docRef = await firestore
          .collection(tasksCollection)
          .add(task.toFirestore());

      final doc = await docRef.get();
      return TaskModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to create task: $e');
    }
  }

  @override
  Future<TaskModel> updateTask(TaskModel task) async {
    try {
      await firestore
          .collection(tasksCollection)
          .doc(task.id)
          .update(task.toFirestore());

      final doc = await firestore
          .collection(tasksCollection)
          .doc(task.id)
          .get();

      return TaskModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to update task: $e');
    }
  }

  @override
  Future<void> deleteTask(String taskId) async {
    try {
      await firestore.collection(tasksCollection).doc(taskId).delete();
    } catch (e) {
      throw Exception('Failed to delete task: $e');
    }
  }

  @override
  Future<TaskModel> toggleTaskStatus(String taskId) async {
    try {
      final doc = await firestore.collection(tasksCollection).doc(taskId).get();

      if (!doc.exists) {
        throw Exception('Task not found');
      }

      final task = TaskModel.fromFirestore(doc);
      final updatedTask = TaskModel.fromEntity(
        task.copyWith(isCompleted: !task.isCompleted),
      );

      await firestore.collection(tasksCollection).doc(taskId).update({
        'isCompleted': updatedTask.isCompleted,
      });

      return updatedTask;
    } catch (e) {
      throw Exception('Failed to toggle task status: $e');
    }
  }

  @override
  Stream<List<TaskModel>> watchTasks(String userId) {
    return firestore
        .collection(tasksCollection)
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => TaskModel.fromFirestore(doc)).toList(),
        );
  }
}
