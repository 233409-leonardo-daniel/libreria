import 'package:library_leo/app_state.dart';
import 'package:library_leo/core/network/api_client.dart';
import 'package:library_leo/features/jsonplaceholder/data/datasources/jsonplaceholder_datasource.dart';
import 'package:library_leo/features/jsonplaceholder/data/repositories/jsonplaceholder_repository_impl.dart';
import 'package:library_leo/features/jsonplaceholder/domain/repositories/jsonplaceholder_repository.dart';
import 'package:library_leo/features/jsonplaceholder/domain/usecases/create_jsonplaceholder.dart';
import 'package:library_leo/features/jsonplaceholder/domain/usecases/get_jsonplaceholder.dart';
import 'package:library_leo/features/jsonplaceholder/domain/usecases/update_jsonplaceholder.dart';
import 'package:library_leo/features/jsonplaceholder/domain/usecases/delete_jsonplaceholder.dart';
import 'package:library_leo/features/jsonplaceholder/presentation/providers/jsonplaceholder_provider.dart';



class JsonPlaceholderDI {
  final ApiClient apiClient;
  final AppState appState;

  late final JsonPlaceholderDataSource remoteDataSource;
  late final JsonPlaceholderRepository repository;

  late final GetJsonPlaceholderUseCase getJsonPlaceholderUseCase;
  late final CreateJsonPlaceholderUseCase createJsonPlaceholderUseCase;
  late final UpdateJsonPlaceholderUseCase updateJsonPlaceholderUseCase;
  late final DeleteJsonPlaceholderUseCase deleteJsonPlaceholderUseCase;

  late final JsonPlaceholderProvider provider;

  JsonPlaceholderDI({
    required this.apiClient,
    required this.appState,
  }) {
    remoteDataSource = JsonPlaceholderDataSource(apiClient);
    repository = JsonPlaceholderRepositoryImpl(remoteDataSource);

    getJsonPlaceholderUseCase = GetJsonPlaceholderUseCase(repository);
    createJsonPlaceholderUseCase = CreateJsonPlaceholderUseCase(repository);
    updateJsonPlaceholderUseCase = UpdateJsonPlaceholderUseCase(repository);
    deleteJsonPlaceholderUseCase = DeleteJsonPlaceholderUseCase(repository);

    provider = JsonPlaceholderProvider(
      getJsonPlaceholderUseCase,
      createJsonPlaceholderUseCase,
      updateJsonPlaceholderUseCase,
      deleteJsonPlaceholderUseCase,
    );
  }
}
