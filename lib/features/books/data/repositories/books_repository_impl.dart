import 'package:library_leo/features/books/data/datasources/books_remote_datasource.dart';
import 'package:library_leo/features/books/domain/entities/book.dart';
import 'package:library_leo/features/books/domain/entities/favorite.dart';
import 'package:library_leo/features/books/domain/repositories/books_repository.dart';
import 'package:library_leo/core/utils/firestore_helpers.dart';

class BooksRepositoryImpl implements BooksRepository {
  final BooksRemoteDataSource remoteDataSource;

  BooksRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Book>> getBooks(String idToken) async {
    final documents = await remoteDataSource.getBooks(idToken);
    return documents.map((doc) {
      final parsedData = FirestoreHelpers.parseFields(doc['fields'] ?? {});
      final docId = FirestoreHelpers.extractIdFromPath(doc['name']);
      return Book.fromFirestore(parsedData, docId);
    }).toList();
  }

  @override
  Future<Book> createBook(Book book, String idToken) async {
    final doc = await remoteDataSource.createBook(book.toFirestoreFields(), idToken);
    final parsedData = FirestoreHelpers.parseFields(doc['fields'] ?? {});
    final docId = FirestoreHelpers.extractIdFromPath(doc['name']);
    return Book.fromFirestore(parsedData, docId);
  }

  @override
  Future<Book> updateBook(Book book, String idToken) async {
    final doc = await remoteDataSource.updateBook(book.id, book.toFirestoreFields(), idToken);
    final parsedData = FirestoreHelpers.parseFields(doc['fields'] ?? {});
    return Book.fromFirestore(parsedData, book.id);
  }

  @override
  Future<void> deleteBook(String bookId, String idToken) async {
    await remoteDataSource.deleteBook(bookId, idToken);
  }

  @override
  Future<List<Favorite>> getFavorites(String userId, String idToken) async {
    final documents = await remoteDataSource.getFavorites(idToken);
    
    // Filter locally by userId since REST API query requires complex setup
    final List<Favorite> allFavorites = documents.map((doc) {
      final parsedData = FirestoreHelpers.parseFields(doc['fields'] ?? {});
      final docId = FirestoreHelpers.extractIdFromPath(doc['name']);
      return Favorite.fromFirestore(parsedData, docId);
    }).toList();

    return allFavorites.where((fav) => fav.userId == userId).toList();
  }

  @override
  Future<Favorite> addFavorite(Favorite favorite, String idToken) async {
    final doc = await remoteDataSource.addFavorite(favorite.toFirestoreFields(), idToken);
    final parsedData = FirestoreHelpers.parseFields(doc['fields'] ?? {});
    final docId = FirestoreHelpers.extractIdFromPath(doc['name']);
    return Favorite.fromFirestore(parsedData, docId);
  }

  @override
  Future<void> removeFavorite(String favoriteId, String idToken) async {
    await remoteDataSource.removeFavorite(favoriteId, idToken);
  }

  @override
  Future<void> updateFavorite(Favorite favorite, String idToken) async {
    await remoteDataSource.updateFavorite(favorite.id, favorite.toFirestoreFields(), idToken);
  }
}
