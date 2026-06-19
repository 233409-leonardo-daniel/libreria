import 'package:library_leo/app_state.dart';
import 'package:library_leo/core/network/api_client.dart';
import 'package:library_leo/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:library_leo/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:library_leo/features/auth/domain/repositories/auth_repository.dart';
import 'package:library_leo/features/auth/domain/usecases/login_use_case.dart';
import 'package:library_leo/features/auth/domain/usecases/register_use_case.dart';
import 'package:library_leo/features/auth/presentation/providers/auth_provider.dart';

class AuthDI {
  final ApiClient apiClient;
  final AppState appState;

  late final AuthRemoteDataSource remoteDataSource;
  late final AuthRepository repository;
  late final LoginUseCase loginUseCase;
  late final RegisterUseCase registerUseCase;
  late final AuthProvider provider;

  AuthDI({
    required this.apiClient,
    required this.appState,
  }) {
    remoteDataSource = AuthRemoteDataSource(apiClient);
    repository = AuthRepositoryImpl(remoteDataSource);
    loginUseCase = LoginUseCase(repository);
    registerUseCase = RegisterUseCase(repository);
    provider = AuthProvider(loginUseCase, registerUseCase, appState);
  }
}
