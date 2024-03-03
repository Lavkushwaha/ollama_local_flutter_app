import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
        title: const Text('Flutter Ollama App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              AutoRouter.of(context).push(const SettingsRoute());

              // Add your settings functionality here
            },
          ),
        ],
      ),
      body: const Center(
        child: Stack(
          children: [
            SpinKitPulse(
              color: Colors.purple,
              size: 200.0,
              duration: Duration(seconds: 3),
            ),
            SpinKitRipple(
              color: Colors.grey,
              size: 200.0,
            ),
            Center(
              child: Text(
                'Ollama',
                style: TextStyle(fontSize: 24.0),
              ),
            ),
          ],
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
