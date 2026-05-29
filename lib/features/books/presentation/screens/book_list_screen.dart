import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:library_leo/app_state.dart';
import 'package:library_leo/features/books/presentation/viewmodels/books_viewmodel.dart';
import 'package:library_leo/features/books/presentation/screens/book_detail_screen.dart';
import 'package:library_leo/features/books/presentation/screens/book_form_screen.dart';
import 'package:library_leo/features/books/presentation/widgets/book_card.dart';
import 'package:library_leo/features/profile/presentation/screens/profile_screen.dart';

class BookListScreen extends StatefulWidget {
  const BookListScreen({super.key});

  @override
  State<BookListScreen> createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BooksViewModel>().loadBooks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Libros'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<BooksViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading && viewModel.books.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.errorMessage != null && viewModel.books.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${viewModel.errorMessage}'),
                  ElevatedButton(
                    onPressed: viewModel.loadBooks,
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          if (viewModel.books.isEmpty) {
            return const Center(child: Text('No hay libros disponibles.'));
          }

          return RefreshIndicator(
            onRefresh: viewModel.loadBooks,
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: viewModel.books.length,
              itemBuilder: (context, index) {
                final book = viewModel.books[index];
                return BookCard(
                  book: book,
                  isFavorite: viewModel.isFavorite(book.id),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => BookDetailScreen(bookId: book.id),
                      ),
                    );
                  },
                  onFavoriteToggle: () {
                    viewModel.toggleFavorite(book.id);
                  },
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: Consumer<AppState>(
        builder: (context, appState, child) {
          if (appState.currentUser?.role == 'admin') {
            return FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const BookFormScreen()),
                );
              },
              child: const Icon(Icons.add),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
