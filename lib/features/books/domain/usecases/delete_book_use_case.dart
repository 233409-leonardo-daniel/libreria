import 'package:library_leo/features/books/domain/repositories/books_repository.dart';

class DeleteBookUseCase {
  final BooksRepository _repository;

  DeleteBookUseCase(this._repository);

  Future<void> call(String bookId, String idToken) {
    return _repository.deleteBook(bookId, idToken);
  }
}
