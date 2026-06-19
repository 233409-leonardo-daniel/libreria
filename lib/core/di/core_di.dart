import 'package:http/http.dart' as http;
import 'package:library_leo/app_state.dart';
import 'package:library_leo/core/network/api_client.dart';

class CoreDI {
  late final http.Client httpClient;
  late final ApiClient apiClient;
  late final AppState appState;

  CoreDI() {
    httpClient = http.Client();
    apiClient = ApiClient(client: httpClient);
    appState = AppState(apiClient: apiClient);
  }
}
