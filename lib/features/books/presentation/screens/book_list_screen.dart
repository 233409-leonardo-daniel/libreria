import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:library_leo/app_state.dart';
import 'package:library_leo/features/books/presentation/providers/books_provider.dart';
import 'package:library_leo/features/books/presentation/screens/book_detail_screen.dart';
import 'package:library_leo/features/books/presentation/screens/book_form_screen.dart';
import 'package:library_leo/features/books/presentation/components/book_card.dart';
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
      context.read<BooksProvider>().loadBooks();
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
      body: Consumer<BooksProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.books.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage != null && provider.books.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${provider.errorMessage}'),
                  ElevatedButton(
                    onPressed: provider.loadBooks,
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          if (provider.books.isEmpty) {
            return const Center(child: Text('No hay libros disponibles.'));
          }

          return RefreshIndicator(
            onRefresh: provider.loadBooks,
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: provider.books.length,
              itemBuilder: (context, index) {
                final book = provider.books[index];
                return BookCard(
                  book: book,
                  isFavorite: provider.isFavorite(book.id),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => BookDetailScreen(bookId: book.id),
                      ),
                    );
                  },
                  onFavoriteToggle: () {
                    provider.toggleFavorite(book.id);
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
