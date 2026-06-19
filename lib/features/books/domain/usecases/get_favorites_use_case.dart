import 'package:library_leo/features/books/domain/entities/favorite.dart';
import 'package:library_leo/features/books/domain/repositories/books_repository.dart';

class GetFavoritesUseCase {
  final BooksRepository _repository;

  GetFavoritesUseCase(this._repository);

  Future<List<Favorite>> call(String userId, String idToken) {
    return _repository.getFavorites(userId, idToken);
  }
}
