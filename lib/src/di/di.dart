import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:ollama_flutter_app/src/di/di.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init', // default
  preferRelativeImports: true, // default
  asExtension: true, // default
)
void configureDependencies({required String env}) => getIt.init(environment: env);
