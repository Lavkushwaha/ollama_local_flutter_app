import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ollama_flutter_app/src/di/di.dart';
import 'package:ollama_flutter_app/src/features/chat_feature/presentation/cubit/chat_cubit.dart';
import 'package:ollama_flutter_app/src/services/store_service.dart';
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
  String userName = 'User';
  String gpt = 'GPT';

  List<String> messages = [];
  final newMessage = [];

  @override
  void initState() {
    messagesController = BehaviorSubject.seeded([]);
    loadingController = BehaviorSubject.seeded(false);
    scrollController = ScrollController();
    getUserDetails();
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

  void getUserDetails() async {
    userName = await getIt<StoreService>().getUser();
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
      appBar: AppBar(title: const Text('Chat Page'), actions: [
        StreamBuilder(
            stream: loadingController,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data == true && mounted) {
                return const SizedBox(
                    height: 50,
                    width: 50,
                    // child: CircularProgressIndicator(
                    //   strokeWidth: 1,
                    // ),
                    child: SpinKitPulse(
                      color: Colors.purple,
                      size: 50.0,
                    ));
              } else {
                return const SizedBox.shrink();
              }
            }),
        const SizedBox(
          width: 10,
        )
      ]),
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
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Row(
            //     children: [
            //       Expanded(
            //         child: TextField(
            //           controller: _controller,
            //           decoration: const InputDecoration(
            //             hintText: 'Enter your message',
            //           ),
            //           onSubmitted: (v) {
            //             sendMessage();
            //           },
            //         ),
            //       ),
            //       const SizedBox(width: 8.0),
            //       StreamBuilder<bool>(
            //           stream: loadingController,
            //           builder: (context, snapshot) {
            //             return ElevatedButton(
            //               onPressed: (snapshot.hasData && snapshot.data == true)
            //                   ? null
            //                   : () {
            //                       sendMessage();
            //                     },
            //               child: (snapshot.hasData && snapshot.data == true && mounted)
            //                   ? const SizedBox(
            //                       height: 20,
            //                       width: 20,
            //                       // child: CircularProgressIndicator(
            //                       //   strokeWidth: 1,
            //                       // ),
            //                       child: SpinKitPulse(
            //                         color: Colors.white,
            //                         size: 20.0,
            //                       ))
            //                   : const Text('Send'),
            //             );
            //           }),
            //     ],
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: TextField(
                          controller: _controller,
                          decoration: const InputDecoration(
                            hintText: 'Type a message...',
                            border: InputBorder.none,
                          ),
                          onSubmitted: (v) {
                            sendMessage();
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  StreamBuilder<bool>(
                    stream: loadingController,
                    builder: (context, snapshot) {
                      return GestureDetector(
                        onTap: (snapshot.hasData && snapshot.data == true)
                            ? () {
                                context.read<ChatCubit>().abortRequest();
                              }
                            : sendMessage,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Center(
                            child: (snapshot.hasData && snapshot.data == true && mounted)
                                ? const SpinKitPulse(
                                    color: Colors.purple,
                                    size: 50.0,
                                  )
                                : const Icon(
                                    Icons.send,
                                    color: Colors.purple,
                                  ),
                          ),
                        ),
                      );
                    },
                  ),
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
      messages.add('$userName : $message');
      messages.add('$gpt : ');
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
