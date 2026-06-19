import 'package:library_leo/app_state.dart';
import 'package:library_leo/features/books/presentation/providers/books_provider.dart';
import 'package:library_leo/features/profile/presentation/providers/profile_provider.dart';

class ProfileDI {
  final BooksProvider booksProvider;
  final AppState appState;

  late final ProfileProvider provider;

  ProfileDI({
    required this.booksProvider,
    required this.appState,
  }) {
    provider = ProfileProvider(booksProvider, appState);
  }
}
