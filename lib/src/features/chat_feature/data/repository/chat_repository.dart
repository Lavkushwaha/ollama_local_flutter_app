import 'package:dartz/dartz.dart';
import 'package:ollama_flutter_app/src/core/failures/failures.dart';
import 'package:ollama_flutter_app/src/features/chat_feature/data/datasource/remote_chat_datasource.dart';
import 'package:ollama_flutter_app/src/features/chat_feature/domain/entity/chat_response_entity.dart';
import 'package:ollama_flutter_app/src/features/chat_feature/domain/repository/chat_repository.dart';

class ChatRepositoryImpl extends ChatRepository {
  final ChatDatasource ds;
  ChatRepositoryImpl(this.ds);
  @override
  // Future<Either<Failure, ChatResponseEntity>> getChatResponse({required String userInput}) async {
  //   // try {
  //   //   final res = await ds.getChatResponseFromServer(userInput: userInput);
  //   //   return Right(res);
  //   // } on ServerException catch (e) {
  //   //   return Left(ServerFailure(e.message ?? not200ErrorMessage));
  //   // } catch (e) {
  //   //   return Left(ServerFailure(e.toString()));
  //   // }
  // }
  @override
  Stream<ChatResponseEntity> getChatResponseStream({required String userInput}) {
    return ds.getChatResponseFromServer(userInput: userInput).asBroadcastStream();
  }
}
