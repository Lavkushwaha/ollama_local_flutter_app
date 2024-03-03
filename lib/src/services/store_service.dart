import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

const String userKey = 'UserKey';
const String baseUrlKey = 'BaseUrlKey';
const String portKey = 'PortKey';
const String customPathKey = 'CustomPathKey';
const String customModelKey = 'CustomModelKey';

// DEFAULT
const String defaultUrl = 'localhost';
const int defaultPort = 11434;
const String defaultPath = '/api/generate';
const String defaultModel = 'llama2';

class StoreService {
  late SharedPreferences preferences;
  StoreService(this.preferences);

  // USER DETAILS
  Future<void> saveUser({required String? user}) async {
    if (user == null || user.isEmpty) {
      return;
    }
    await preferences.setString(userKey, user);
  }

  Future<String> getUser() async {
    final res = preferences.getString(userKey);
    return res ?? 'user';
  }

  // BASE URL DETAILS
  Future<void> saveBaseUrl({required String? baseUrl}) async {
    if (baseUrl == null || baseUrl.isEmpty) {
      return;
    }
    await preferences.setString(baseUrlKey, baseUrl);
  }

  Future<String> getBaseUrl() async {
    final res = preferences.getString(baseUrlKey);
    if (res != null && res.isNotEmpty) {
      return res;
    } else {
      // IF TESTING ON ANDROID EMULATOR
      // ELSE USE 127.0.0.1
      if (Platform.isAndroid) {
        return '10.0.2.2';
      } else if (Platform.isIOS) {
        return '127.0.0.1';
      } else {
        return defaultUrl;
      }
    }
  }

  // PORT  DETAILS
  Future<void> savePort({required int? port}) async {
    if (port == null) {
      return;
    }
    await preferences.setInt(portKey, port);
  }

  Future<int> getPort() async {
    final res = preferences.getInt(baseUrlKey);
    if (res != null) {
      return res;
    } else {
      return defaultPort;
    }
  }

  // PATH  DETAILS
  Future<void> savePath({required String? path}) async {
    if (path == null || path.isEmpty) {
      return;
    }
    await preferences.setString(customPathKey, path);
  }

  Future<String> getPath() async {
    final res = preferences.getString(customPathKey);
    if (res != null && res.isNotEmpty) {
      return res;
    } else {
      return defaultPath;
    }
  }

  // MODEL  DETAILS
  Future<void> saveModel({required String? model}) async {
    if (model == null || model.isEmpty) {
      return;
    }
    await preferences.setString(customPathKey, model);
  }

  Future<String> getModel() async {
    final res = preferences.getString(customModelKey);
    if (res != null && res.isNotEmpty) {
      return res;
    } else {
      return defaultModel;
    }
  }
}
