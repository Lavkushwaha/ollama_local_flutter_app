import 'package:flutter/foundation.dart';

@factory
abstract class AppEndpoints {
  String getBaseUrl();
  String getAuthUrl();

  String getChatUrl();
  
  Map<String, String> getAuthHeaders();
}
