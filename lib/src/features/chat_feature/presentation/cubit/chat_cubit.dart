import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:ollama_flutter_app/src/features/chat_feature/domain/entity/chat_response_entity.dart';
import 'package:ollama_flutter_app/src/features/chat_feature/domain/usecase/get_chat_response_usecase.dart';

part 'chat_state.dart';

@injectable
class ChatCubit extends Cubit<ChatState> {
  final GetChatResponseUsecase usecase;
  StreamSubscription? _responseSubscription;

  ChatCubit(this.usecase) : super(ChatInitial());

  getChatResponse({required String userInput}) async {
    _responseSubscription?.cancel();
    _responseSubscription = usecase.execute(userInput: userInput).listen(
      (response) {
        if (response.done == false) {
          emit(ChatLoading());
          emit(ChatNewResponse(response));
        } else {
          emit(ChatLoaded(response));
        }
      },
      onError: (error) {
        emit(ChatError(error.toString()));
      },
    );
  }

  abortRequest() {
    emit(ChatLoading());
    usecase.abortRequest();
    emit(const ChatError('request aborted try again'));
  }

  @override
  Future<void> close() {
    _responseSubscription?.cancel();
    return super.close();
  }
}
