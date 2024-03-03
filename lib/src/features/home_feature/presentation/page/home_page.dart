import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ollama_flutter_app/src/router/app_router.gr.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Home Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Add your settings functionality here
            },
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Welcome to Flutter Home Page',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
          height: 50.0,
          child: ElevatedButton(
            onPressed: () {
              AutoRouter.of(context).push(const ChatRoute());
            },
            child: const Text('Chat Now'),
          ),
        ),
      ),
    );
  }
}
