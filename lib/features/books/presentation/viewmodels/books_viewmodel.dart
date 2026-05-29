import 'package:flutter/material.dart';
import 'package:library_leo/app_state.dart';
import 'package:library_leo/features/books/domain/entities/book.dart';
import 'package:library_leo/features/books/domain/entities/favorite.dart';
import 'package:library_leo/features/books/domain/repositories/books_repository.dart';

class BooksViewModel extends ChangeNotifier {
  final BooksRepository _repository;
  final AppState _appState;

  List<Book> _books = [];
  List<Favorite> _favorites = [];
  bool _isLoading = false;
  String? _errorMessage;

  BooksViewModel(this._repository, this._appState);

  List<Book> get books => _books;
  List<Favorite> get favorites => _favorites;
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

  Future<void> loadBooks() async {
    if (_appState.idToken == null) return;
    _setLoading(true);
    _errorMessage = null;

    try {
      _books = await _repository.getBooks(_appState.idToken!);
      if (_appState.currentUser != null) {
        _favorites = await _repository.getFavorites(_appState.currentUser!.id, _appState.idToken!);
      }
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> createBook(Book book) async {
    if (_appState.idToken == null || _appState.currentUser?.role != 'admin') return false;
    _setLoading(true);
    _errorMessage = null;

    try {
      final newBook = await _repository.createBook(book, _appState.idToken!);
      _books.add(newBook);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateBook(Book book) async {
    if (_appState.idToken == null || _appState.currentUser?.role != 'admin') return false;
    _setLoading(true);
    _errorMessage = null;

    try {
      await _repository.updateBook(book, _appState.idToken!);
      final index = _books.indexWhere((b) => b.id == book.id);
      if (index != -1) {
        _books[index] = book;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> deleteBook(String bookId) async {
    if (_appState.idToken == null || _appState.currentUser?.role != 'admin') return false;
    _setLoading(true);
    _errorMessage = null;

    try {
      await _repository.deleteBook(bookId, _appState.idToken!);
      _books.removeWhere((b) => b.id == bookId);
      // Also remove favorites associated with this book
      _favorites.removeWhere((f) => f.bookId == bookId);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // --- Favorites Logic ---

  bool isFavorite(String bookId) {
    return _favorites.any((f) => f.bookId == bookId);
  }

  Favorite? getFavorite(String bookId) {
    try {
      return _favorites.firstWhere((f) => f.bookId == bookId);
    } catch (e) {
      return null;
    }
  }

  Future<bool> toggleFavorite(String bookId) async {
    if (_appState.idToken == null || _appState.currentUser == null) return false;
    _setLoading(true);

    try {
      final existingFavorite = getFavorite(bookId);
      if (existingFavorite != null) {
        // Remove favorite
        await _repository.removeFavorite(existingFavorite.id, _appState.idToken!);
        _favorites.removeWhere((f) => f.id == existingFavorite.id);
      } else {
        // Add favorite
        final newFavorite = Favorite(
          id: '',
          userId: _appState.currentUser!.id,
          bookId: bookId,
          rating: 0,
          currentPage: 0,
        );
        final addedFavorite = await _repository.addFavorite(newFavorite, _appState.idToken!);
        _favorites.add(addedFavorite);
      }
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateFavoriteRating(String favoriteId, int rating) async {
    if (_appState.idToken == null) return false;
    
    try {
      final index = _favorites.indexWhere((f) => f.id == favoriteId);
      if (index != -1) {
        final updatedFav = _favorites[index].copyWith(rating: rating);
        await _repository.updateFavorite(updatedFav, _appState.idToken!);
        _favorites[index] = updatedFav;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
      return false;
    }
  }

  Future<bool> updateFavoriteProgress(String favoriteId, int currentPage) async {
    if (_appState.idToken == null) return false;
    
    try {
      final index = _favorites.indexWhere((f) => f.id == favoriteId);
      if (index != -1) {
        final updatedFav = _favorites[index].copyWith(currentPage: currentPage);
        await _repository.updateFavorite(updatedFav, _appState.idToken!);
        _favorites[index] = updatedFav;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
      return false;
    }
  }
}
