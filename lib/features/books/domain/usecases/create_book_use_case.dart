import 'package:library_leo/features/books/domain/entities/book.dart';
import 'package:library_leo/features/books/domain/repositories/books_repository.dart';

class CreateBookUseCase {
  final BooksRepository _repository;

  CreateBookUseCase(this._repository);

  Future<Book> call(Book book, String idToken) {
    return _repository.createBook(book, idToken);
  }
}
