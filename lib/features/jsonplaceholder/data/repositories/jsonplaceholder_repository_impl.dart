import 'package:library_leo/features/jsonplaceholder/data/datasources/jsonplaceholder_datasource.dart';
import 'package:library_leo/features/jsonplaceholder/domain/entities/jsonplaceholder.dart';
import 'package:library_leo/features/jsonplaceholder/domain/repositories/jsonplaceholder_repository.dart';

class JsonPlaceholderRepositoryImpl implements JsonPlaceholderRepository {
  final JsonPlaceholderDataSource _dataSource;

  JsonPlaceholderRepositoryImpl(this._dataSource);

  @override
  Future<List<JsonPlaceholder>> getJsonPlaceholder() async {
    final rawPosts = await _dataSource.getJsonPlaceholders();
    return rawPosts.map((json) => JsonPlaceholder.fromJson(json)).toList();
  }

  @override
  Future<JsonPlaceholder> getJsonPlaceholderById(int id) async {
    final rawPost = await _dataSource.getJsonPlaceholderById(id);
    return JsonPlaceholder.fromJson(rawPost);
  }

  @override
  Future<JsonPlaceholder> createJsonPlaceholder(
      JsonPlaceholder jsonPlaceholder) async {
    final rawPostData = jsonPlaceholder.toJson();
    rawPostData.remove('id');

    final createdRaw = await _dataSource.createJsonPlaceholder(rawPostData);
    return JsonPlaceholder.fromJson(createdRaw);
  }

  @override
  Future<JsonPlaceholder> updateJsonPlaceholder(
      JsonPlaceholder jsonPlaceholder) async {
    final rawPostData = jsonPlaceholder.toJson();
    final updatedRaw = await _dataSource.updateJsonPlaceholder(jsonPlaceholder.id, rawPostData);
    return JsonPlaceholder.fromJson(updatedRaw);
  }

  @override
  Future<void> deleteJsonPlaceholder(int id) async {
    await _dataSource.deleteJsonPlaceholder(id);
  }
}
