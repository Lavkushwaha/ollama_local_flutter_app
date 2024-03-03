import 'package:ollama_flutter_app/src/features/chat_feature/domain/entity/chat_response_entity.dart';

abstract class ChatRepository {
  // Future<Either<Failure, ChatResponseEntity>> getChatResponse({required String userInput});
  Stream<ChatResponseEntity> getChatResponseStream({required String userInput});
}
