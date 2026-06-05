import 'package:flutter/material.dart';
import 'package:library_leo/core/network/api_client.dart';
import 'package:library_leo/features/auth/domain/entities/user.dart';

class AppState extends ChangeNotifier {
  final ApiClient? _apiClient;
  bool _isLoading = false;
  User? _currentUser;
  String? _idToken;
  String? _errorMessage;

  AppState({ApiClient? apiClient}) : _apiClient = apiClient;

  bool get isLoading => _isLoading;
  User? get currentUser => _currentUser;
  String? get idToken => _idToken;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null && _idToken != null;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setUserAndToken(User user, String token) {
    _currentUser = user;
    _idToken = token;
    _errorMessage = null;
    _apiClient?.setAuthToken(token);
    notifyListeners();
  }

  void setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    _idToken = null;
    _errorMessage = null;
    _apiClient?.clearAuthToken();
    notifyListeners();
  }
}
