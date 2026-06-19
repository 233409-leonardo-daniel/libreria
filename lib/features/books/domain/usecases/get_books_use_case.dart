import 'package:library_leo/features/books/domain/entities/book.dart';
import 'package:library_leo/features/books/domain/repositories/books_repository.dart';

class GetBooksUseCase {
  final BooksRepository _repository;

  GetBooksUseCase(this._repository);

  Future<List<Book>> call(String idToken) {
    return _repository.getBooks(idToken);
  }
}
