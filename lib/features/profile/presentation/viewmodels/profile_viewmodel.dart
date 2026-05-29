import 'package:flutter/material.dart';
import 'package:library_leo/app_state.dart';
import 'package:library_leo/features/books/domain/entities/book.dart';
import 'package:library_leo/features/books/domain/entities/favorite.dart';
import 'package:library_leo/features/books/presentation/viewmodels/books_viewmodel.dart';

class ProfileViewModel extends ChangeNotifier {
  final BooksViewModel _booksViewModel;
  final AppState _appState;

  ProfileViewModel(this._booksViewModel, this._appState);

  List<Favorite> get userFavorites => _booksViewModel.favorites;
  
  List<Book> get favoriteBooks {
    return _booksViewModel.books.where((b) => _booksViewModel.isFavorite(b.id)).toList();
  }

  List<Favorite> get pendingBooks {
    return userFavorites.where((f) {
      final book = _booksViewModel.books.firstWhere((b) => b.id == f.bookId, orElse: () => Book(id: '', idPublisher: '', name: '', classification: '', pages: 1, createdAt: DateTime.now()));
      return f.currentPage > 0 && f.currentPage < book.pages;
    }).toList();
  }

  Book? getBookForFavorite(String bookId) {
    try {
      return _booksViewModel.books.firstWhere((b) => b.id == bookId);
    } catch (e) {
      return null;
    }
  }

  void logout() {
    _appState.logout();
  }
}
