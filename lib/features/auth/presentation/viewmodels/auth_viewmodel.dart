import 'package:flutter/material.dart';
import 'package:library_leo/app_state.dart';
import 'package:library_leo/features/auth/domain/repositories/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _repository;
  final AppState _appState;

  AuthViewModel(this._repository, this._appState);

  Future<bool> login(String email, String password) async {
    _appState.setLoading(true);
    _appState.clearError();

    try {
      final result = await _repository.login(email, password);
      _appState.setUserAndToken(result['user'], result['idToken']);
      _appState.setLoading(false);
      return true;
    } catch (e) {
      _appState.setLoading(false);
      _appState.setError(e.toString().replaceAll('Exception: ', ''));
      return false;
    }
  }

  Future<bool> register(String name, String email, String password, String role) async {
    _appState.setLoading(true);
    _appState.clearError();

    try {
      final result = await _repository.register(name, email, password, role);
      _appState.setUserAndToken(result['user'], result['idToken']);
      _appState.setLoading(false);
      return true;
    } catch (e) {
      _appState.setLoading(false);
      _appState.setError(e.toString().replaceAll('Exception: ', ''));
      return false;
    }
  }

  void logout() {
    _appState.logout();
  }
}
