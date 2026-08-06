import 'dart:convert';
import 'package:library_leo/core/network/api_client.dart';

class JsonPlaceholderDataSource {
  final ApiClient client;

  JsonPlaceholderDataSource(this.client);

  Future<List<Map<String, dynamic>>> getJsonPlaceholders() async {
    final response =
        await client.get('https://jsonplaceholder.typicode.com/posts');

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((e) => e as Map<String, dynamic>).toList();
    } else {
      throw Exception(
          'Error al obtener posts de la API pública. Código: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> getJsonPlaceholderById(int id) async {
    final response = await client.get('https://jsonplaceholder.typicode.com/posts/$id');

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Error al obtener el post. Código: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> createJsonPlaceholder(Map<String, dynamic> postData) async {
    final response = await client.post(
      'https://jsonplaceholder.typicode.com/posts',
      postData,
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception(
          'Error al crear el post en la API pública. Código: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> updateJsonPlaceholder(int id, Map<String, dynamic> postData) async {
    final response = await client.put(
      'https://jsonplaceholder.typicode.com/posts/$id',
      postData,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Error al actualizar el post. Código: ${response.statusCode}');
    }
  }

  Future<void> deleteJsonPlaceholder(int id) async {
    final response = await client.delete('https://jsonplaceholder.typicode.com/posts/$id');
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Error al eliminar el post. Código: ${response.statusCode}');
    }
  }
}
