import 'package:library_leo/features/jsonplaceholder/domain/entities/jsonplaceholder.dart';
import 'package:library_leo/features/jsonplaceholder/domain/repositories/jsonplaceholder_repository.dart';

class GetJsonPlaceholderUseCase {
  final JsonPlaceholderRepository _repository;

  GetJsonPlaceholderUseCase(this._repository);

  Future<List<JsonPlaceholder>> execute() async {
    return await _repository.getJsonPlaceholder();
  }
}
