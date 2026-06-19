import 'package:library_leo/app_state.dart';
import 'package:library_leo/core/network/api_client.dart';
import 'package:library_leo/features/books/data/datasources/books_remote_datasource.dart';
import 'package:library_leo/features/books/data/repositories/books_repository_impl.dart';
import 'package:library_leo/features/books/domain/repositories/books_repository.dart';
import 'package:library_leo/features/books/domain/usecases/get_books_use_case.dart';
import 'package:library_leo/features/books/domain/usecases/create_book_use_case.dart';
import 'package:library_leo/features/books/domain/usecases/update_book_use_case.dart';
import 'package:library_leo/features/books/domain/usecases/delete_book_use_case.dart';
import 'package:library_leo/features/books/domain/usecases/get_favorites_use_case.dart';
import 'package:library_leo/features/books/domain/usecases/add_favorite_use_case.dart';
import 'package:library_leo/features/books/domain/usecases/remove_favorite_use_case.dart';
import 'package:library_leo/features/books/domain/usecases/update_favorite_use_case.dart';
import 'package:library_leo/features/books/presentation/providers/books_provider.dart';

class BooksDI {
  final ApiClient apiClient;
  final AppState appState;

  late final BooksRemoteDataSource remoteDataSource;
  late final BooksRepository repository;
  
  late final GetBooksUseCase getBooksUseCase;
  late final CreateBookUseCase createBookUseCase;
  late final UpdateBookUseCase updateBookUseCase;
  late final DeleteBookUseCase deleteBookUseCase;
  late final GetFavoritesUseCase getFavoritesUseCase;
  late final AddFavoriteUseCase addFavoriteUseCase;
  late final RemoveFavoriteUseCase removeFavoriteUseCase;
  late final UpdateFavoriteUseCase updateFavoriteUseCase;
  
  late final BooksProvider provider;

  BooksDI({
    required this.apiClient,
    required this.appState,
  }) {
    remoteDataSource = BooksRemoteDataSource(apiClient);
    repository = BooksRepositoryImpl(remoteDataSource);
    
    getBooksUseCase = GetBooksUseCase(repository);
    createBookUseCase = CreateBookUseCase(repository);
    updateBookUseCase = UpdateBookUseCase(repository);
    deleteBookUseCase = DeleteBookUseCase(repository);
    getFavoritesUseCase = GetFavoritesUseCase(repository);
    addFavoriteUseCase = AddFavoriteUseCase(repository);
    removeFavoriteUseCase = RemoveFavoriteUseCase(repository);
    updateFavoriteUseCase = UpdateFavoriteUseCase(repository);

    provider = BooksProvider(
      getBooksUseCase,
      createBookUseCase,
      updateBookUseCase,
      deleteBookUseCase,
      getFavoritesUseCase,
      addFavoriteUseCase,
      removeFavoriteUseCase,
      updateFavoriteUseCase,
      appState,
    );
  }
}
