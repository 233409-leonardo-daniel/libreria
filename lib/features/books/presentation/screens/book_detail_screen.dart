import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:library_leo/app_state.dart';
import 'package:library_leo/features/books/presentation/viewmodels/books_viewmodel.dart';
import 'package:library_leo/features/books/presentation/screens/book_form_screen.dart';
import 'package:library_leo/features/books/presentation/widgets/rating_widget.dart';

class BookDetailScreen extends StatefulWidget {
  final String bookId;

  const BookDetailScreen({super.key, required this.bookId});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  late TextEditingController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = TextEditingController();
    _initPageController();
  }

  void _initPageController() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read<BooksViewModel>();
      final favorite = viewModel.getFavorite(widget.bookId);
      if (favorite != null) {
        _pageController.text = favorite.currentPage.toString();
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _updateProgress(BooksViewModel viewModel, String favoriteId) {
    final page = int.tryParse(_pageController.text.trim());
    if (page != null) {
      viewModel.updateFavoriteProgress(favoriteId, page);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Progreso de lectura actualizado')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<BooksViewModel, AppState>(
      builder: (context, booksViewModel, appState, child) {
        final book = booksViewModel.books.firstWhere((b) => b.id == widget.bookId, orElse: () => throw Exception('Book not found'));
        final isFavorite = booksViewModel.isFavorite(book.id);
        final favorite = booksViewModel.getFavorite(book.id);
        final isAdmin = appState.currentUser?.role == 'admin';

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 250.0,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    book.name,
                    style: const TextStyle(shadows: [Shadow(color: Colors.black54, blurRadius: 4)]),
                  ),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        child: Icon(Icons.book, size: 100, color: Theme.of(context).colorScheme.primary),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.black87],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  IconButton(
                    icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: isFavorite ? Colors.red : Colors.white),
                    onPressed: () => booksViewModel.toggleFavorite(book.id),
                  ),
                  if (isAdmin)
                    PopupMenuButton<String>(
                      onSelected: (value) async {
                        if (value == 'edit') {
                          Navigator.of(context).push(MaterialPageRoute(builder: (_) => BookFormScreen(bookToEdit: book)));
                        } else if (value == 'delete') {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Eliminar libro'),
                              content: const Text('¿Estás seguro de eliminar este libro?'),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
                                TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Eliminar', style: TextStyle(color: Colors.red))),
                              ],
                            ),
                          );
                          if (confirm == true) {
                            final success = await booksViewModel.deleteBook(book.id);
                            if (!context.mounted) return;
                            if (success) Navigator.pop(context);
                          }
                        }
                      },
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(value: 'edit', child: Text('Editar')),
                        const PopupMenuItem<String>(value: 'delete', child: Text('Eliminar')),
                      ],
                    ),
                ],
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildInfoCard(context, book.classification, book.pages.toString(), book.idPublisher),
                    const SizedBox(height: 24),
                    if (isFavorite && favorite != null) ...[
                      const Divider(),
                      const SizedBox(height: 16),
                      Text('Tu Calificación', style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Center(
                        child: RatingWidget(
                          rating: favorite.rating,
                          onRatingChanged: (newRating) {
                            booksViewModel.updateFavoriteRating(favorite.id, newRating);
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text('Progreso de Lectura', style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _pageController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Página actual',
                                suffixText: '/ ${book.pages}',
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: () => _updateProgress(booksViewModel, favorite.id),
                            child: const Text('Guardar'),
                          ),
                        ],
                      ),
                    ],
                  ]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoCard(BuildContext context, String classification, String pages, String publisher) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInfoRow(context, Icons.category, 'Clasificación', classification),
            const Divider(),
            _buildInfoRow(context, Icons.pages, 'Páginas', pages),
            const Divider(),
            _buildInfoRow(context, Icons.business, 'Editorial/Autor', publisher),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.secondary),
          const SizedBox(width: 16),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const Spacer(),
          Text(value, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}
