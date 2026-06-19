import 'package:flutter/material.dart';
import 'package:library_leo/app_state.dart';
import 'package:library_leo/features/books/domain/entities/book.dart';
import 'package:library_leo/features/books/domain/entities/favorite.dart';
import 'package:library_leo/features/books/presentation/providers/books_provider.dart';

class ProfileProvider extends ChangeNotifier {
  final BooksProvider _booksProvider;
  final AppState _appState;

  ProfileProvider(this._booksProvider, this._appState);

  List<Favorite> get userFavorites => _booksProvider.favorites;
  
  List<Book> get favoriteBooks {
    return _booksProvider.books.where((b) => _booksProvider.isFavorite(b.id)).toList();
  }

  List<Favorite> get pendingBooks {
    return userFavorites.where((f) {
      final book = _booksProvider.books.firstWhere((b) => b.id == f.bookId, orElse: () => Book(id: '', idPublisher: '', name: '', classification: '', pages: 1, createdAt: DateTime.now()));
      return f.currentPage > 0 && f.currentPage < book.pages;
    }).toList();
  }

  Book? getBookForFavorite(String bookId) {
    try {
      return _booksProvider.books.firstWhere((b) => b.id == bookId);
    } catch (e) {
      return null;
    }
  }

  void logout() {
    _appState.logout();
  }
}
