import 'package:library_leo/features/books/domain/entities/book.dart';
import 'package:library_leo/features/books/domain/repositories/books_repository.dart';

class UpdateBookUseCase {
  final BooksRepository _repository;

  UpdateBookUseCase(this._repository);

  Future<Book> call(Book book, String idToken) {
    return _repository.updateBook(book, idToken);
  }
}
