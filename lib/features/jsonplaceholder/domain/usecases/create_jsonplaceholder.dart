import 'package:library_leo/features/jsonplaceholder/domain/entities/jsonplaceholder.dart';
import 'package:library_leo/features/jsonplaceholder/domain/repositories/jsonplaceholder_repository.dart';

class CreateJsonPlaceholderUseCase {
  final JsonPlaceholderRepository _repository;

  CreateJsonPlaceholderUseCase(this._repository);

  Future<JsonPlaceholder> execute(JsonPlaceholder jsonPlaceholder) async {
    return await _repository.createJsonPlaceholder(jsonPlaceholder);
  }
}
