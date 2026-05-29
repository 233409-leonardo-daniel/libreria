import 'package:library_leo/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:library_leo/features/auth/domain/entities/user.dart';
import 'package:library_leo/features/auth/domain/repositories/auth_repository.dart';
import 'package:library_leo/core/utils/firestore_helpers.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    final authData = await remoteDataSource.signInWithPassword(email, password);
    final userId = authData['localId'];
    final idToken = authData['idToken'];

    final userProfile = await getUserProfile(userId, idToken);
    
    if (userProfile == null) {
      throw Exception('Perfil de usuario no encontrado en Firestore');
    }

    return {
      'user': userProfile,
      'idToken': idToken,
    };
  }

  @override
  Future<Map<String, dynamic>> register(String name, String email, String password, String role) async {
    // 1. Create auth user
    final authData = await remoteDataSource.signUp(email, password);
    final userId = authData['localId'];
    final idToken = authData['idToken'];

    // 2. Create firestore document
    final user = User(id: userId, name: name, email: email, role: role);
    await remoteDataSource.createUserDocument(userId, user.toJson(), idToken);

    return {
      'user': user,
      'idToken': idToken,
    };
  }

  @override
  Future<User?> getUserProfile(String userId, String idToken) async {
    final doc = await remoteDataSource.getUserDocument(userId, idToken);
    if (doc == null || !doc.containsKey('fields')) return null;

    final parsedData = FirestoreHelpers.parseFields(doc['fields']);
    return User.fromJson(parsedData, userId);
  }
}
