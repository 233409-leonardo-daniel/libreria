import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:library_leo/features/jsonplaceholder/presentation/providers/jsonplaceholder_provider.dart';
import 'package:library_leo/features/jsonplaceholder/domain/entities/jsonplaceholder.dart';

class JsonPlaceholderScreen extends StatefulWidget {
  const JsonPlaceholderScreen({super.key});

  @override
  State<JsonPlaceholderScreen> createState() => _JsonPlaceholderScreenState();
}

class _JsonPlaceholderScreenState extends State<JsonPlaceholderScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<JsonPlaceholderProvider>().loadJsonPlaceholders();
    });
  }

  // DIALOGO: Agregar una nueva publicación
  void _showAddPostDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController();
    final bodyController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.rate_review, color: Colors.amber),
              SizedBox(width: 8),
              Text('Nueva Publicación'),
            ],
          ),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Título de la reseña/tema',
                      hintText: 'Ej. ¿Qué opinan de Cien años de soledad?',
                      prefixIcon: Icon(Icons.title),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'El título es obligatorio';
                      }
                      if (val.trim().length < 3) {
                        return 'El título debe tener al menos 3 caracteres';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: bodyController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Contenido',
                      hintText: 'Escribe tu reseña, duda o recomendación aquí...',
                      alignLabelWithHint: true,
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'El contenido no puede estar vacío';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState?.validate() ?? false) {
                  final title = titleController.text.trim();
                  final body = bodyController.text.trim();

                  Navigator.of(dialogContext).pop();

                  final success = await context
                      .read<JsonPlaceholderProvider>()
                      .createJsonPlaceholder(title, body);

                  if (context.mounted) {
                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('¡Publicación creada exitosamente!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } else {
                      final error = context
                              .read<JsonPlaceholderProvider>()
                              .errorMessage ??
                          'Error al crear publicación';
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error: $error'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                }
              },
              child: const Text('Publicar'),
            ),
          ],
        );
      },
    );
  }

  // DIALOGO: Editar publicación existente (Actualizar)
  void _showEditPostDialog(BuildContext context, JsonPlaceholder post) {
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController(text: post.title);
    final bodyController = TextEditingController(text: post.body);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.edit, color: Colors.amber),
              SizedBox(width: 8),
              Text('Editar Publicación'),
            ],
          ),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Título de la reseña/tema',
                      prefixIcon: Icon(Icons.title),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'El título es obligatorio';
                      }
                      if (val.trim().length < 3) {
                        return 'El título debe tener al menos 3 caracteres';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: bodyController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Contenido',
                      alignLabelWithHint: true,
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'El contenido no puede estar vacío';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState?.validate() ?? false) {
                  final title = titleController.text.trim();
                  final body = bodyController.text.trim();

                  Navigator.of(dialogContext).pop();

                  final success = await context
                      .read<JsonPlaceholderProvider>()
                      .updateJsonPlaceholder(post.id, title, body);

                  if (context.mounted) {
                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('¡Publicación actualizada exitosamente!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } else {
                      final error = context
                              .read<JsonPlaceholderProvider>()
                              .errorMessage ??
                          'Error al actualizar';
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error: $error'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  // DIALOGO: Confirmar eliminación (Eliminar)
  void _showDeleteConfirmDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.red),
              SizedBox(width: 8),
              Text('Eliminar Publicación'),
            ],
          ),
          content: const Text(
            '¿Estás seguro de que deseas eliminar esta publicación? Esta acción no se puede deshacer.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                Navigator.of(dialogContext).pop();

                final success = await context
                    .read<JsonPlaceholderProvider>()
                    .deleteJsonPlaceholder(id);

                if (context.mounted) {
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Publicación eliminada exitosamente'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    final error = context
                            .read<JsonPlaceholderProvider>()
                            .errorMessage ??
                        'Error al eliminar';
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: $error'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Foro de Lectores'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                context.read<JsonPlaceholderProvider>().loadJsonPlaceholders(),
          ),
        ],
      ),
      body: Consumer<JsonPlaceholderProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.jsonPlaceholders.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage != null &&
              provider.jsonPlaceholders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${provider.errorMessage}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: provider.loadJsonPlaceholders,
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          if (provider.jsonPlaceholders.isEmpty) {
            return const Center(child: Text('No hay publicaciones.'));
          }

          return RefreshIndicator(
            onRefresh: provider.loadJsonPlaceholders,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.jsonPlaceholders.length,
              itemBuilder: (context, index) {
                final jsonPlaceholder = provider.jsonPlaceholders[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: CircleAvatar(
                      backgroundColor: theme.colorScheme.primaryContainer,
                      child: Text(
                        '${jsonPlaceholder.userId}',
                        style: TextStyle(
                          color: theme.colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      jsonPlaceholder.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Text(jsonPlaceholder.body),
                    ),
                    // Fila de botones de acción para editar y eliminar
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          tooltip: 'Editar publicación',
                          onPressed: () =>
                              _showEditPostDialog(context, jsonPlaceholder),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          tooltip: 'Eliminar publicación',
                          onPressed: () =>
                              _showDeleteConfirmDialog(context, jsonPlaceholder.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddPostDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
