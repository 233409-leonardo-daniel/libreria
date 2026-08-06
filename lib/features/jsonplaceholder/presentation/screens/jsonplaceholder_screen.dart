import 'package:flutter/material.dart';
import 'package:library_leo/features/jsonplaceholder/presentation/providers/jsonplaceholder_provider.dart';
import 'package:provider/provider.dart';

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
                      hintText:
                          'Escribe tu reseña, duda o recomendación aquí...',
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
                          'Error desconocido';
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

  @override
  Widget build(BuildContext context) {
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
                  child: ListTile(
                    title: Text(jsonPlaceholder.title),
                    subtitle: Text(jsonPlaceholder.body),
                    leading: CircleAvatar(
                      child: Text('${jsonPlaceholder.userId}'),
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
