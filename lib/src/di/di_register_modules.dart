import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:ollama_flutter_app/src/constants/endpoints/dev_endpoints.dart';
import 'package:ollama_flutter_app/src/constants/endpoints/endpoints.dart';
import 'package:ollama_flutter_app/src/constants/endpoints/prod_endpoints.dart';
import 'package:ollama_flutter_app/src/di/di.dart';
import 'package:ollama_flutter_app/src/features/chat_feature/data/datasource/remote_chat_datasource.dart';
import 'package:ollama_flutter_app/src/features/chat_feature/data/repository/chat_repository.dart';
import 'package:ollama_flutter_app/src/features/chat_feature/domain/repository/chat_repository.dart';

@module
abstract class RegisterModule {
  @lazySingleton
  Dio get dio => Dio();

  @lazySingleton
  HttpClient get httpClient => HttpClient();

  // // ABSTRACT CLASSES NEED TO IMPORT LIKE THIS WITH ACTUAL IMPLEMENTATION
  @lazySingleton
  ChatRepository get chatRepository => ChatRepositoryImpl(getIt());

  @lazySingleton
  ChatDatasource get chatDatasource => RemoteChatDatasource(getIt());

  @Environment('dev')
  @singleton
  AppEndpoints get devEndpoints => DevEndpoints();

  @Environment('production')
  @singleton
  AppEndpoints get prodEndpoints => ProdEndpoints();
}
