import 'package:library_leo/features/books/domain/entities/book.dart';
import 'package:library_leo/features/books/domain/entities/favorite.dart';

abstract class BooksRepository {
  Future<List<Book>> getBooks(String idToken);
  Future<Book> createBook(Book book, String idToken);
  Future<Book> updateBook(Book book, String idToken);
  Future<void> deleteBook(String bookId, String idToken);
  
  Future<List<Favorite>> getFavorites(String userId, String idToken);
  Future<Favorite> addFavorite(Favorite favorite, String idToken);
  Future<void> removeFavorite(String favoriteId, String idToken);
  Future<void> updateFavorite(Favorite favorite, String idToken);
}
