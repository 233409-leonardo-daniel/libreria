import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:library_leo/core/utils/validators.dart';
import 'package:library_leo/features/books/domain/entities/book.dart';
import 'package:library_leo/features/books/presentation/providers/books_provider.dart';

class BookFormScreen extends StatefulWidget {
  final Book? bookToEdit;

  const BookFormScreen({super.key, this.bookToEdit});

  @override
  State<BookFormScreen> createState() => _BookFormScreenState();
}

class _BookFormScreenState extends State<BookFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _classificationController;
  late TextEditingController _pagesController;
  late TextEditingController _idPublisherController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.bookToEdit?.name ?? '');
    _classificationController = TextEditingController(text: widget.bookToEdit?.classification ?? '');
    _pagesController = TextEditingController(text: widget.bookToEdit?.pages.toString() ?? '');
    _idPublisherController = TextEditingController(text: widget.bookToEdit?.idPublisher ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _classificationController.dispose();
    _pagesController.dispose();
    _idPublisherController.dispose();
    super.dispose();
  }

  void _saveBook() async {
    if (_formKey.currentState!.validate()) {
      final provider = context.read<BooksProvider>();
      
      final book = Book(
        id: widget.bookToEdit?.id ?? '',
        idPublisher: _idPublisherController.text.trim(),
        name: _nameController.text.trim(),
        classification: _classificationController.text.trim(),
        pages: int.parse(_pagesController.text.trim()),
        createdAt: widget.bookToEdit?.createdAt ?? DateTime.now(),
      );

      bool success;
      if (widget.bookToEdit == null) {
        success = await provider.createBook(book);
      } else {
        success = await provider.updateBook(book);
      }

      if (success && mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(widget.bookToEdit == null ? 'Libro creado exitosamente' : 'Libro actualizado exitosamente')),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(provider.errorMessage ?? 'Error al guardar el libro')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.bookToEdit != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Libro' : 'Nuevo Libro'),
      ),
      body: Consumer<BooksProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Nombre del Libro'),
                    validator: (v) => Validators.validateRequired(v, 'Nombre'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _classificationController,
                    decoration: const InputDecoration(labelText: 'Clasificación / Género'),
                    validator: (v) => Validators.validateRequired(v, 'Clasificación'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _pagesController,
                    decoration: const InputDecoration(labelText: 'Número de Páginas'),
                    keyboardType: TextInputType.number,
                    validator: Validators.validatePages,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _idPublisherController,
                    decoration: const InputDecoration(labelText: 'ID Editorial / Autor'),
                    validator: (v) => Validators.validateRequired(v, 'ID Editorial'),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: provider.isLoading ? null : _saveBook,
                    child: provider.isLoading
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                        : Text(isEditing ? 'ACTUALIZAR' : 'CREAR'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
