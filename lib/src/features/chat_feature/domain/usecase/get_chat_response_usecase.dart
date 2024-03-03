import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:ollama_flutter_app/src/core/failures/failures.dart';
import 'package:ollama_flutter_app/src/features/chat_feature/domain/entity/chat_response_entity.dart';
import 'package:ollama_flutter_app/src/features/chat_feature/domain/repository/chat_repository.dart';

@lazySingleton
class GetChatResponseUsecase {
  final ChatRepository repository;
  GetChatResponseUsecase(this.repository);

  // Future<Either<Failure, ChatResponseEntity>> execute({required String userInput}) async {
  //   return repository.getChatResponse(userInput: userInput);
  // }

   Stream<ChatResponseEntity> execute({required String userInput}) {
    return repository.getChatResponseStream(userInput: userInput);
  }
}
