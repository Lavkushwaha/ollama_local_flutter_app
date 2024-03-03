part of 'chat_cubit.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatNewResponse extends ChatState {
  final ChatResponseEntity entity;
  const ChatNewResponse(this.entity);
}

class ChatLoaded extends ChatState {
  final ChatResponseEntity entity;
  const ChatLoaded(this.entity);
}

class ChatError extends ChatState {
  final String error;
  const ChatError(this.error);
}
