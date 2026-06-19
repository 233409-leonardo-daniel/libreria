import 'package:library_leo/features/books/domain/repositories/books_repository.dart';

class RemoveFavoriteUseCase {
  final BooksRepository _repository;

  RemoveFavoriteUseCase(this._repository);

  Future<void> call(String favoriteId, String idToken) {
    return _repository.removeFavorite(favoriteId, idToken);
  }
}
