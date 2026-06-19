import 'package:library_leo/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository _repository;

  RegisterUseCase(this._repository);

  Future<Map<String, dynamic>> call(String name, String email, String password, String role) {
    return _repository.register(name, email, password, role);
  }
}
