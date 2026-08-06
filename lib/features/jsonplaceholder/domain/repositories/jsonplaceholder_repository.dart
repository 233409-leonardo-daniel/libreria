import 'package:library_leo/features/jsonplaceholder/domain/entities/jsonplaceholder.dart';

abstract class JsonPlaceholderRepository {
  Future<List<JsonPlaceholder>> getJsonPlaceholder();
  Future<JsonPlaceholder> getJsonPlaceholderById(int id);
  Future<JsonPlaceholder> createJsonPlaceholder(
      JsonPlaceholder jsonPlaceholder);
  Future<JsonPlaceholder> updateJsonPlaceholder(
      JsonPlaceholder jsonPlaceholder);
  Future<void> deleteJsonPlaceholder(int id);
}
