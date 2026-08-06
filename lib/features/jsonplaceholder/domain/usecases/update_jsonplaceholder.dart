import 'package:library_leo/features/jsonplaceholder/domain/entities/jsonplaceholder.dart';
import 'package:library_leo/features/jsonplaceholder/domain/repositories/jsonplaceholder_repository.dart';

class UpdateJsonPlaceholderUseCase {
  final JsonPlaceholderRepository repository;

  UpdateJsonPlaceholderUseCase(this.repository);

  Future<JsonPlaceholder> execute(JsonPlaceholder jsonPlaceholder) {
    return repository.updateJsonPlaceholder(jsonPlaceholder);
  }
}
