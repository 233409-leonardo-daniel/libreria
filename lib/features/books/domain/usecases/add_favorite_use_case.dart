import 'package:library_leo/features/books/domain/entities/favorite.dart';
import 'package:library_leo/features/books/domain/repositories/books_repository.dart';

class AddFavoriteUseCase {
  final BooksRepository _repository;

  AddFavoriteUseCase(this._repository);

  Future<Favorite> call(Favorite favorite, String idToken) {
    return _repository.addFavorite(favorite, idToken);
  }
}
