import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:library_leo/app_state.dart';
import 'package:library_leo/core/utils/validators.dart';
import 'package:library_leo/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:library_leo/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:library_leo/features/books/presentation/screens/book_list_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedRole = 'lector';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      final viewModel = context.read<AuthViewModel>();
      final success = await viewModel.register(
        _nameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text,
        _selectedRole,
      );

      if (success && mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const BookListScreen()),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Consumer<AppState>(
            builder: (context, appState, child) {
              return Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (appState.errorMessage != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          appState.errorMessage!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onErrorContainer,
                          ),
                        ),
                      ),
                    AuthTextField(
                      controller: _nameController,
                      labelText: 'Nombre',
                      hintText: 'Ingresa tu nombre completo',
                      prefixIcon: Icons.person,
                      validator: Validators.validateName,
                    ),
                    const SizedBox(height: 16),
                    AuthTextField(
                      controller: _emailController,
                      labelText: 'Email',
                      hintText: 'Ingresa tu correo',
                      prefixIcon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                      validator: Validators.validateEmail,
                    ),
                    const SizedBox(height: 16),
                    AuthTextField(
                      controller: _passwordController,
                      labelText: 'Contraseña',
                      hintText: 'Ingresa tu contraseña',
                      prefixIcon: Icons.lock,
                      isPassword: true,
                      validator: Validators.validatePassword,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedRole,
                      decoration: const InputDecoration(
                        labelText: 'Rol',
                        prefixIcon: Icon(Icons.security),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'lector', child: Text('Lector')),
                        DropdownMenuItem(value: 'admin', child: Text('Administrador')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedRole = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: appState.isLoading ? null : _register,
                      child: appState.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('REGISTRARSE', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
