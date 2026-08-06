import 'package:flutter/material.dart';
import 'package:library_leo/features/jsonplaceholder/domain/entities/jsonplaceholder.dart';
import 'package:library_leo/features/jsonplaceholder/domain/usecases/create_jsonplaceholder.dart';
import 'package:library_leo/features/jsonplaceholder/domain/usecases/get_jsonplaceholder.dart';
import 'package:library_leo/features/jsonplaceholder/domain/usecases/update_jsonplaceholder.dart';
import 'package:library_leo/features/jsonplaceholder/domain/usecases/delete_jsonplaceholder.dart';

class JsonPlaceholderProvider extends ChangeNotifier {
  final GetJsonPlaceholderUseCase _getJsonPlaceholdersUseCase;
  final CreateJsonPlaceholderUseCase _createJsonPlaceholderUseCase;
  final UpdateJsonPlaceholderUseCase _updateJsonPlaceholderUseCase;
  final DeleteJsonPlaceholderUseCase _deleteJsonPlaceholderUseCase;

  List<JsonPlaceholder> _jsonPlaceholders = [];
  bool _isLoading = false;
  String? _errorMessage;

  JsonPlaceholderProvider(
    this._getJsonPlaceholdersUseCase,
    this._createJsonPlaceholderUseCase,
    this._updateJsonPlaceholderUseCase,
    this._deleteJsonPlaceholderUseCase,
  );

  List<JsonPlaceholder> get jsonPlaceholders => _jsonPlaceholders;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  Future<void> loadJsonPlaceholders() async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final fetchedPosts = await _getJsonPlaceholdersUseCase.execute();
      _jsonPlaceholders = fetchedPosts..sort((a, b) => b.id.compareTo(a.id));
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> createJsonPlaceholder(String title, String body) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final newPostPlaceholder = JsonPlaceholder(
        id: 0,
        userId: 1,
        title: title,
        body: body,
      );

      final createdJsonPlaceholder =
          await _createJsonPlaceholderUseCase.execute(newPostPlaceholder);

      final maxId = _jsonPlaceholders.isEmpty
          ? 100
          : _jsonPlaceholders.map((p) => p.id).reduce((a, b) => a > b ? a : b);
      final finalJsonPlaceholder =
          createdJsonPlaceholder.copyWith(id: maxId + 1);

      _jsonPlaceholders.insert(0, finalJsonPlaceholder);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateJsonPlaceholder(int id, String title, String body) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final index = _jsonPlaceholders.indexWhere((p) => p.id == id);
      if (index == -1) {
        throw Exception('Post no encontrado');
      }

      final postToUpdate = _jsonPlaceholders[index].copyWith(
        title: title,
        body: body,
      );

      final updatedPost = await _updateJsonPlaceholderUseCase.execute(postToUpdate);
      
      _jsonPlaceholders[index] = updatedPost;
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> deleteJsonPlaceholder(int id) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      await _deleteJsonPlaceholderUseCase.execute(id);
      
      _jsonPlaceholders.removeWhere((p) => p.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
      return false;
    } finally {
      _setLoading(false);
    }
  }
}
