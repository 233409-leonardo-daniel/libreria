import 'package:library_leo/features/books/domain/entities/favorite.dart';
import 'package:library_leo/features/books/domain/repositories/books_repository.dart';

class UpdateFavoriteUseCase {
  final BooksRepository _repository;

  UpdateFavoriteUseCase(this._repository);

  Future<void> call(Favorite favorite, String idToken) {
    return _repository.updateFavorite(favorite, idToken);
  }
}
