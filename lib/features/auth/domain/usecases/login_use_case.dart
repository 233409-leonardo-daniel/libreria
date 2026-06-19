import 'package:library_leo/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<Map<String, dynamic>> call(String email, String password) {
    return _repository.login(email, password);
  }
}
