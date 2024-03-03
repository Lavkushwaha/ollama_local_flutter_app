import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ollama_flutter_app/src/di/di.dart';
import 'package:ollama_flutter_app/src/features/chat_feature/domain/entity/chat_response_entity.dart';
import 'package:ollama_flutter_app/src/services/store_service.dart'; // Importing Ollama class

abstract class ChatDatasource {
  Stream<ChatResponseEntity> getChatResponseFromServer({required String userInput});
  Future<void> abortCurrentRequest();
}

class RemoteChatDatasource extends ChatDatasource {
  final HttpClient _client;
  RemoteChatDatasource(this._client);

  late HttpClientRequest request;

  // @override
  // Stream<ChatResponseEntity> getChatResponseFromServer({required String userInput}) async* {
  //   try {
  //     HttpClientRequest request = await _client.post('localhost', 11434, '/api/generate');
  //     Map<String, dynamic> jsonMap = {"model": "llama2", "prompt": "hi"};
  //     String jsonString = json.encode(jsonMap);
  //     List<int> bodyBytes = utf8.encode(jsonString);
  //     request.add(bodyBytes);
  //     HttpClientResponse response = await request.close();
  //     final responseMessage = [];
  //     final context = [];

  //     await response.transform(utf8.decoder).listen((event) async* {
  //       final resp = json.decode(event);
  //       if (resp['done'] == false) {
  //         yield ChatResponseEntity.fromJson(json.decode(event)['response']);
  //         responseMessage.add(json.decode(event)['response'].toString());
  //       } else {
  //         context.add(resp['context']);
  //       }
  //     }).asFuture();

  //     print(responseMessage.join(''));
  //   } catch (e) {
  //     print(e);
  //     rethrow;
  //   } finally {
  //     _client.close();
  //   }

  //   // final url = getIt<AppEndpoints>().getChatUrl();
  //   // final uri = Uri.parse(url);
  //   // final request = await _client.postUrl(uri);

  //   // // Set headers
  //   // request.headers.contentType = ContentType.json;

  //   // // Create request body
  //   // final requestBody = {
  //   //   "model": LLMModels.defaultModel,
  //   //   "prompt": userInput,
  //   // };

  //   // // Write request body to the request
  //   // request.write(jsonEncode(requestBody));

  //   // // Send request and listen for response
  //   // final response = await request.close();

  //   // // Check response status code
  //   // if (response.statusCode == HttpStatus.ok) {
  //   //   // Process response
  //   //   await for (final chunk in response.transform(utf8.decoder)) {
  //   //     final jsonResponse = jsonDecode(chunk);
  //   //     yield ChatResponseEntity.fromJson(jsonResponse);
  //   //   }
  //   // } else {
  //   //   throw ServerException(not200ErrorMessage);
  //   // }
  // }
  @override
  Stream<ChatResponseEntity> getChatResponseFromServer({required String userInput}) async* {
    try {
      final baseUrl = await getIt<StoreService>().getBaseUrl();
      final basePort = await getIt<StoreService>().getPort();
      final basePath = await getIt<StoreService>().getPath();
      final baseModel = await getIt<StoreService>().getModel();

      request = await _client.post(
        baseUrl,
        basePort,
        basePath,
      );
      Map<String, dynamic> jsonMap = {
        "model": baseModel,
        "prompt": userInput,
      };
      String jsonString = json.encode(jsonMap);
      List<int> bodyBytes = utf8.encode(jsonString);
      request.add(bodyBytes);
      HttpClientResponse response = await request.close();
      final responseMessage = [];
      final context = [];

      await for (final chunk in response.transform(utf8.decoder)) {
        final resp = json.decode(chunk);
        // print(resp);
        if (resp['done'] == false) {
          // print(resp);
          yield ChatResponseEntity.fromJson(resp);
          responseMessage.add(resp['response'].toString());
        } else {
          yield ChatResponseEntity.fromJson(resp);
          context.add(resp['context']);
        }
      }
      // print(responseMessage.join(''));
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    } finally {
      // _client.close();
    }
  }

  @override
  Future<void> abortCurrentRequest() async {
    try {
      request.abort();
      request.addError('request aborted');
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
