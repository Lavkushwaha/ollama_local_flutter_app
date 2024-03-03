import 'package:ollama_flutter_app/src/constants/endpoints/endpoints.dart';

class DevEndpoints implements AppEndpoints {
  @override
  Map<String, String> getAuthHeaders() {
    return {};
  }

  @override
  String getBaseUrl() {
    return 'http://localhost:11434/';
  }

  @override
  String getAuthUrl() {
    return '${getBaseUrl()}api/auth';
  }

  @override
  String getChatUrl() {
    return '${getBaseUrl()}api/generate';
  }
}
