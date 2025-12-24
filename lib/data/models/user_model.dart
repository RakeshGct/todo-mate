import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({required super.id, required super.email});

  factory UserModel.fromFirebaseUser(firebase_auth.User firebaseUser) {
    return UserModel(id: firebaseUser.uid, email: firebaseUser.email ?? '');
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(id: user.id, email: user.email);
  }
}
