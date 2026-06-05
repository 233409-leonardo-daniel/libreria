import 'dart:convert';
import 'package:library_leo/core/constants/api_constants.dart';
import 'package:library_leo/core/network/api_client.dart';
import 'package:library_leo/core/utils/firestore_helpers.dart';

class AuthRemoteDataSource {
  final ApiClient client;

  AuthRemoteDataSource(this.client);

  Future<Map<String, dynamic>> signInWithPassword(String email, String password) async {
    final response = await client.post(
      ApiConstants.signInUrl,
      {
        'email': email,
        'password': password,
        'returnSecureToken': true,
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['error']['message'] ?? 'Error de autenticación');
    }
  }

  Future<Map<String, dynamic>> signUp(String email, String password) async {
    final response = await client.post(
      ApiConstants.signUpUrl,
      {
        'email': email,
        'password': password,
        'returnSecureToken': true,
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['error']['message'] ?? 'Error al registrar usuario');
    }
  }

  Future<void> createUserDocument(String userId, Map<String, dynamic> userData, String idToken) async {
    // Firestore REST API requires a PATCH request to create a document with a specific ID
    // URL format: databases/(default)/documents/users/{userId}?documentId={userId}
    final url = '${ApiConstants.collectionUrl('users')}?documentId=$userId';
    
    final formattedData = {
      'fields': FirestoreHelpers.buildFields(userData)
    };

    client.setAuthToken(idToken);

    final response = await client.post(
      url,
      formattedData,
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      final errorData = jsonDecode(response.body);
      throw Exception('Error creando documento de usuario: ${errorData['error']['message']}');
    }
  }

  Future<Map<String, dynamic>?> getUserDocument(String userId, String idToken) async {
    final url = ApiConstants.documentUrl('users/$userId');
    
    client.setAuthToken(idToken);

    final response = await client.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data; // Returns the full Document response (including 'fields')
    } else if (response.statusCode == 404) {
      return null;
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception('Error obteniendo documento de usuario: ${errorData['error']['message']}');
    }
  }
}
