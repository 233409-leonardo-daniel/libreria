class ApiConstants {
  static const String projectId = 'library-leo';
  static const String apiKey = 'AIzaSyAK44uJV0JQ1WHa99wXaxDnV6wC1lHhhOU';

  // Firebase Auth REST API (Identity Toolkit)
  static const String authBaseUrl = 'https://identitytoolkit.googleapis.com/v1/accounts';

  // Firestore REST API
  static const String firestoreBaseUrl = 'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents';

  // Helper methods to build URLs
  static String get signUpUrl => '$authBaseUrl:signUp?key=$apiKey';
  static String get signInUrl => '$authBaseUrl:signInWithPassword?key=$apiKey';
  static String get lookupUserUrl => '$authBaseUrl:lookup?key=$apiKey';

  static String collectionUrl(String collectionPath) {
    return '$firestoreBaseUrl/$collectionPath';
  }

  static String documentUrl(String documentPath) {
    return '$firestoreBaseUrl/$documentPath';
  }
}
