import 'package:library_leo/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  /// Inicia sesión y devuelve el token de autenticación (idToken) y el usuario
  Future<Map<String, dynamic>> login(String email, String password);

  /// Registra un nuevo usuario y devuelve el token de autenticación y el usuario
  Future<Map<String, dynamic>> register(String name, String email, String password, String role);

  /// Obtiene el perfil del usuario desde Firestore
  Future<User?> getUserProfile(String userId, String idToken);
}
