import 'package:flutter/material.dart';
import 'package:library_leo/app_state.dart';
import 'package:library_leo/features/auth/domain/usecases/login_use_case.dart';
import 'package:library_leo/features/auth/domain/usecases/register_use_case.dart';

class AuthProvider extends ChangeNotifier {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final AppState _appState;

  AuthProvider(this._loginUseCase, this._registerUseCase, this._appState);

  Future<bool> login(String email, String password) async {
    _appState.setLoading(true);
    _appState.clearError();

    try {
      final result = await _loginUseCase(email, password);
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
      final result = await _registerUseCase(name, email, password, role);
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
