import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:library_leo/app_state.dart';
import 'package:library_leo/features/auth/presentation/screens/login_screen.dart';
import 'package:library_leo/features/books/presentation/screens/book_detail_screen.dart';
import 'package:library_leo/features/profile/presentation/providers/profile_provider.dart';
import 'package:library_leo/features/profile/presentation/components/reading_progress_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _logout(BuildContext context) {
    context.read<ProfileProvider>().logout();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
            tooltip: 'Cerrar Sesión',
          ),
        ],
      ),
      body: Consumer2<AppState, ProfileProvider>(
        builder: (context, appState, profileProvider, child) {
          final user = appState.currentUser;
          if (user == null) return const Center(child: Text('No hay usuario logueado'));

          final favoriteBooks = profileProvider.favoriteBooks;
          final pendingBooks = profileProvider.pendingBooks;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // User Info Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          child: Text(
                            user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                            style: const TextStyle(fontSize: 24, color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(user.name, style: Theme.of(context).textTheme.titleLarge),
                              Text(user.email, style: Theme.of(context).textTheme.bodyMedium),
                              const SizedBox(height: 4),
                              Chip(
                                label: Text(user.role.toUpperCase()),
                                padding: EdgeInsets.zero,
                                visualDensity: VisualDensity.compact,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Pending Books Section
                Text('Lecturas Pendientes', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                if (pendingBooks.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('No tienes lecturas pendientes.'),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: pendingBooks.length,
                    itemBuilder: (context, index) {
                      final fav = pendingBooks[index];
                      final book = profileProvider.getBookForFavorite(fav.bookId);
                      if (book == null) return const SizedBox.shrink();

                      return Card(
                        margin: const EdgeInsets.only(bottom: 8.0),
                        child: ListTile(
                          leading: const Icon(Icons.book),
                          title: Text(book.name),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: ReadingProgressWidget(
                              currentPage: fav.currentPage,
                              totalPages: book.pages,
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => BookDetailScreen(bookId: book.id)),
                            );
                          },
                        ),
                      );
                    },
                  ),

                const SizedBox(height: 24),

                // Favorites Section
                Text('Mis Favoritos', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                if (favoriteBooks.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('Aún no tienes libros favoritos.'),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: favoriteBooks.length,
                    itemBuilder: (context, index) {
                      final book = favoriteBooks[index];
                      final fav = profileProvider.userFavorites.firstWhere((f) => f.bookId == book.id);

                      return Card(
                        margin: const EdgeInsets.only(bottom: 8.0),
                        child: ListTile(
                          leading: const Icon(Icons.favorite, color: Colors.red),
                          title: Text(book.name),
                          subtitle: Text(book.classification),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('${fav.rating}'),
                              const Icon(Icons.star, color: Colors.amber, size: 16),
                            ],
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => BookDetailScreen(bookId: book.id)),
                            );
                          },
                        ),
                      );
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
