import 'package:library_leo/features/jsonplaceholder/domain/repositories/jsonplaceholder_repository.dart';

class DeleteJsonPlaceholderUseCase {
  final JsonPlaceholderRepository repository;

  DeleteJsonPlaceholderUseCase(this.repository);

  Future<void> execute(int id) {
    return repository.deleteJsonPlaceholder(id);
  }
}
