import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'package:library_leo/app_state.dart';
import 'package:library_leo/core/themes/app_theme.dart';
import 'package:library_leo/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:library_leo/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:library_leo/features/auth/presentation/screens/login_screen.dart';
import 'package:library_leo/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:library_leo/features/books/data/datasources/books_remote_datasource.dart';
import 'package:library_leo/features/books/data/repositories/books_repository_impl.dart';
import 'package:library_leo/features/books/presentation/viewmodels/books_viewmodel.dart';
import 'package:library_leo/features/profile/presentation/viewmodels/profile_viewmodel.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Manual Dependency Injection
  final httpClient = http.Client();
  
  // Data Sources
  final authRemoteDataSource = AuthRemoteDataSource(httpClient);
  final booksRemoteDataSource = BooksRemoteDataSource(httpClient);
  
  // Repositories
  final authRepository = AuthRepositoryImpl(authRemoteDataSource);
  final booksRepository = BooksRepositoryImpl(booksRemoteDataSource);
  
  // Global App State
  final appState = AppState();

  // ViewModels
  final authViewModel = AuthViewModel(authRepository, appState);
  final booksViewModel = BooksViewModel(booksRepository, appState);
  final profileViewModel = ProfileViewModel(booksViewModel, appState);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: appState),
        ChangeNotifierProvider.value(value: authViewModel),
        ChangeNotifierProvider.value(value: booksViewModel),
        ChangeNotifierProvider.value(value: profileViewModel),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Library Leo',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
