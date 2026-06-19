import 'package:flutter/material.dart';
import 'package:library_leo/app_state.dart';
import 'package:library_leo/features/books/domain/entities/book.dart';
import 'package:library_leo/features/books/domain/entities/favorite.dart';
import 'package:library_leo/features/books/domain/usecases/get_books_use_case.dart';
import 'package:library_leo/features/books/domain/usecases/create_book_use_case.dart';
import 'package:library_leo/features/books/domain/usecases/update_book_use_case.dart';
import 'package:library_leo/features/books/domain/usecases/delete_book_use_case.dart';
import 'package:library_leo/features/books/domain/usecases/get_favorites_use_case.dart';
import 'package:library_leo/features/books/domain/usecases/add_favorite_use_case.dart';
import 'package:library_leo/features/books/domain/usecases/remove_favorite_use_case.dart';
import 'package:library_leo/features/books/domain/usecases/update_favorite_use_case.dart';

class BooksProvider extends ChangeNotifier {
  final GetBooksUseCase _getBooksUseCase;
  final CreateBookUseCase _createBookUseCase;
  final UpdateBookUseCase _updateBookUseCase;
  final DeleteBookUseCase _deleteBookUseCase;
  final GetFavoritesUseCase _getFavoritesUseCase;
  final AddFavoriteUseCase _addFavoriteUseCase;
  final RemoveFavoriteUseCase _removeFavoriteUseCase;
  final UpdateFavoriteUseCase _updateFavoriteUseCase;
  final AppState _appState;

  List<Book> _books = [];
  List<Favorite> _favorites = [];
  bool _isLoading = false;
  String? _errorMessage;

  BooksProvider(
    this._getBooksUseCase,
    this._createBookUseCase,
    this._updateBookUseCase,
    this._deleteBookUseCase,
    this._getFavoritesUseCase,
    this._addFavoriteUseCase,
    this._removeFavoriteUseCase,
    this._updateFavoriteUseCase,
    this._appState,
  );

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
      _books = await _getBooksUseCase(_appState.idToken!);
      if (_appState.currentUser != null) {
        _favorites = await _getFavoritesUseCase(_appState.currentUser!.id, _appState.idToken!);
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
      final newBook = await _createBookUseCase(book, _appState.idToken!);
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
      await _updateBookUseCase(book, _appState.idToken!);
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
      await _deleteBookUseCase(bookId, _appState.idToken!);
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
        await _removeFavoriteUseCase(existingFavorite.id, _appState.idToken!);
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
        final addedFavorite = await _addFavoriteUseCase(newFavorite, _appState.idToken!);
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
        await _updateFavoriteUseCase(updatedFav, _appState.idToken!);
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
        await _updateFavoriteUseCase(updatedFav, _appState.idToken!);
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
