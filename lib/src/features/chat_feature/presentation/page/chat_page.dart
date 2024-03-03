import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ollama_flutter_app/src/features/chat_feature/presentation/cubit/chat_cubit.dart';
import 'package:rxdart/subjects.dart';

@RoutePage()
class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  late BehaviorSubject<List<String>> messagesController;
  late BehaviorSubject<bool> loadingController;
  late ScrollController scrollController;

  bool _isUserDragging = false;

  List<String> messages = [];
  final newMessage = [];

  @override
  void initState() {
    messagesController = BehaviorSubject.seeded([]);
    loadingController = BehaviorSubject.seeded(false);
    scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    messages.clear();
    messagesController.close();
    loadingController.close();
  }

  void _scrollDown() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Page'),
      ),
      body: GestureDetector(
        onVerticalDragStart: (_) {
          _isUserDragging = true;
        },
        onVerticalDragEnd: (_) {
          _isUserDragging = false;
        },
        child: Column(
          children: [
            Expanded(
              child: BlocConsumer<ChatCubit, ChatState>(
                listener: (context, state) {
                  if (state is ChatNewResponse) {
                    // Append partial response to the last user message
                    messages[messages.length - 1] += state.entity.response;

                    messagesController.add(messages);
                    loadingController.add(true);

                    if (!_isUserDragging) {
                      // Only trigger auto-scroll if the user is not dragging the screen
                      _scrollDown();
                    }
                  } else if (state is ChatLoaded) {
                    // Add concatenated response as a single message
                    messages[messages.length - 1] += state.entity.response;
                    messagesController.add(messages);
                    loadingController.add(false);
                  } else if (state is ChatError) {
                    messages[messages.length - 1] += state.error;
                    messagesController.add(messages);
                    loadingController.add(false);
                  } else {
                    loadingController.add(false);
                  }
                },
                builder: (context, state) {
                  return ListView.builder(
                      controller: scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        if (index == messages.length - 1 || index == messages.length - 2) {
                          return ListTile(
                            title: Text(
                              messages[index],
                              style: const TextStyle(color: Colors.black),
                            ),
                          );
                        }
                        return ListTile(
                          title: Text(
                            messages[index],
                            style: const TextStyle(color: Colors.grey),
                          ),
                        );
                      });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Enter your message',
                      ),
                      onSubmitted: (v) {
                        sendMessage();
                      },
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  StreamBuilder<bool>(
                      stream: loadingController,
                      builder: (context, snapshot) {
                        return ElevatedButton(
                          onPressed: (snapshot.hasData && snapshot.data == true)
                              ? null
                              : () {
                                  sendMessage();
                                },
                          child: (snapshot.hasData && snapshot.data == true)
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 1,
                                  ))
                              : const Text('Send'),
                        );
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void sendMessage() {
    String message = _controller.text;
    if (message.isNotEmpty) {
      messages.add('User: $message');
      messages.add('GPT : ');
      messagesController.add(messages);
      loadingController.add(true);
      context.read<ChatCubit>().getChatResponse(userInput: message);
      // newMessage.add(message); // Add the user message to the list of new messages
      _controller.clear();
    }
  }

  String generateResponse(String message) {
    // Simulate response generation based on user input
    return "This is a sample response to '$message'";
  }
}
