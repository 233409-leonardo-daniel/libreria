import 'dart:convert';
import 'package:library_leo/core/constants/api_constants.dart';
import 'package:library_leo/core/network/api_client.dart';
import 'package:library_leo/core/utils/firestore_helpers.dart';

class BooksRemoteDataSource {
  final ApiClient client;

  BooksRemoteDataSource(this.client);

  Future<List<Map<String, dynamic>>> getBooks(String idToken) async {
    final url = ApiConstants.collectionUrl('books');
    client.setAuthToken(idToken);
    final response = await client.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final documents = data['documents'] as List? ?? [];
      return documents.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Error al obtener libros');
    }
  }

  Future<Map<String, dynamic>> createBook(Map<String, dynamic> bookData, String idToken) async {
    final url = ApiConstants.collectionUrl('books');
    final formattedData = {'fields': FirestoreHelpers.buildFields(bookData)};

    client.setAuthToken(idToken);
    final response = await client.post(
      url,
      formattedData,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al crear libro');
    }
  }

  Future<Map<String, dynamic>> updateBook(String bookId, Map<String, dynamic> bookData, String idToken) async {
    final url = ApiConstants.documentUrl('books/$bookId');
    final formattedData = {'fields': FirestoreHelpers.buildFields(bookData)};

    client.setAuthToken(idToken);
    final response = await client.patch(
      url,
      formattedData,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al actualizar libro');
    }
  }

  Future<void> deleteBook(String bookId, String idToken) async {
    final url = ApiConstants.documentUrl('books/$bookId');
    client.setAuthToken(idToken);
    final response = await client.delete(url);

    if (response.statusCode != 200) {
      throw Exception('Error al eliminar libro');
    }
  }

  // --- Favorites ---

  Future<List<Map<String, dynamic>>> getFavorites(String idToken) async {
    // Note: This fetches all favorites. In a real app, we would use a structured query (RunQuery) to filter by userId.
    // For simplicity with REST API and without setting up indexes, we fetch and filter locally.
    final url = ApiConstants.collectionUrl('favorites');
    client.setAuthToken(idToken);
    final response = await client.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final documents = data['documents'] as List? ?? [];
      return documents.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Error al obtener favoritos');
    }
  }

  Future<Map<String, dynamic>> addFavorite(Map<String, dynamic> favoriteData, String idToken) async {
    final url = ApiConstants.collectionUrl('favorites');
    final formattedData = {'fields': FirestoreHelpers.buildFields(favoriteData)};

    client.setAuthToken(idToken);
    final response = await client.post(
      url,
      formattedData,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al agregar a favoritos');
    }
  }

  Future<void> removeFavorite(String favoriteId, String idToken) async {
    final url = ApiConstants.documentUrl('favorites/$favoriteId');
    client.setAuthToken(idToken);
    final response = await client.delete(url);

    if (response.statusCode != 200) {
      throw Exception('Error al eliminar favorito');
    }
  }

  Future<Map<String, dynamic>> updateFavorite(String favoriteId, Map<String, dynamic> favoriteData, String idToken) async {
    final url = ApiConstants.documentUrl('favorites/$favoriteId');
    final formattedData = {'fields': FirestoreHelpers.buildFields(favoriteData)};

    client.setAuthToken(idToken);
    final response = await client.patch(
      url,
      formattedData,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al actualizar favorito');
    }
  }
}
