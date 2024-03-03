import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ollama_flutter_app/src/di/di.dart';
import 'package:ollama_flutter_app/src/services/store_service.dart';
import 'package:rxdart/subjects.dart';

@RoutePage()
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late BehaviorSubject<bool> loadingController;
  late TextEditingController? baseUrlController;
  late TextEditingController? basePortController;
  late TextEditingController? basePathController;
  late TextEditingController? modelNameController;
  late TextEditingController? userNameController;

  @override
  void initState() {
    loadingController = BehaviorSubject.seeded(false);
    baseUrlController = TextEditingController();
    basePortController = TextEditingController();
    basePathController = TextEditingController();
    modelNameController = TextEditingController();
    userNameController = TextEditingController();
    super.initState();
    loadSettings();
    // Initialize text editing controllers with saved settings
  }

  Future<void> loadSettings() async {
    loadingController.add(true);
    baseUrlController = TextEditingController(text: await getIt<StoreService>().getBaseUrl());
    basePortController = TextEditingController(text: "${await getIt<StoreService>().getPort()}");
    basePathController = TextEditingController(text: await getIt<StoreService>().getPath());
    modelNameController = TextEditingController(text: await getIt<StoreService>().getModel());
    userNameController = TextEditingController(text: await getIt<StoreService>().getUser());
    loadingController.add(false);
  }

  Future<void> saveSettings() async {
    await getIt<StoreService>().saveBaseUrl(baseUrl: baseUrlController?.text);
    await getIt<StoreService>().savePath(path: basePathController?.text);
    await getIt<StoreService>().savePort(port: int.tryParse(basePortController?.text ?? ''));
    await getIt<StoreService>().saveModel(model: modelNameController?.text);
    await getIt<StoreService>().saveUser(user: userNameController?.text);
    await loadSettings();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        stream: loadingController,
        builder: (context, snapshot) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Settings'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: userNameController,
                    decoration: const InputDecoration(labelText: 'User Name'),
                  ),
                  TextField(
                    controller: baseUrlController,
                    decoration: const InputDecoration(labelText: 'Base URL'),
                  ),
                  TextField(
                    controller: basePortController,
                    decoration: const InputDecoration(labelText: 'Base Port'),
                  ),
                  TextField(
                    controller: basePathController,
                    decoration: const InputDecoration(labelText: 'Base Path'),
                  ),
                  TextField(
                    controller: modelNameController,
                    decoration: const InputDecoration(labelText: 'Model Name'),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          await saveSettings();
                          Navigator.pop(context);
                        },
                        child: const Text('Save'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          await getIt<StoreService>().clearAll();
                          await loadSettings();

                          // Navigator.pop(context);
                        },
                        child: const Text('Set default'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
