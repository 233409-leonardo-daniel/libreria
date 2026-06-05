import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:library_leo/core/themes/app_theme.dart';
import 'package:library_leo/core/di/core_di.dart';
import 'package:library_leo/features/auth/di/auth_di.dart';
import 'package:library_leo/features/auth/presentation/screens/login_screen.dart';
import 'package:library_leo/features/books/di/books_di.dart';
import 'package:library_leo/features/profile/di/profile_di.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Core Dependency Injection
  final coreDI = CoreDI();

  // Feature Dependency Injections
  final authDI = AuthDI(
    apiClient: coreDI.apiClient,
    appState: coreDI.appState,
  );
  
  final booksDI = BooksDI(
    apiClient: coreDI.apiClient,
    appState: coreDI.appState,
  );

  final profileDI = ProfileDI(
    booksProvider: booksDI.provider,
    appState: coreDI.appState,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: coreDI.appState),
        ChangeNotifierProvider.value(value: authDI.provider),
        ChangeNotifierProvider.value(value: booksDI.provider),
        ChangeNotifierProvider.value(value: profileDI.provider),
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
