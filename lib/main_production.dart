import 'package:ollama_flutter_app/bootstrap.dart';
import 'package:ollama_flutter_app/src/app.dart';
import 'package:ollama_flutter_app/src/constants/env.dart';
import 'package:ollama_flutter_app/src/di/di.dart';

void main() {
  configureDependencies(env: AppEnvironments.prod);

  bootstrap(() => MyApp());
}
