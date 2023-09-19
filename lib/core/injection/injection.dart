import 'package:crud_bloc/core/injection/external_injection.dart';
import 'package:get_it/get_it.dart';

import '../../features/todo/todo_injection.dart';
import 'core_injection.dart';

/// sl = Service Locator
final sl = GetIt.instance;

// * Initialization of GetIt service locator or dependency injection
Future<void> init() async {
  CoreInjection.init();

  ExternalInjection.init();

  // *** Features injection ***

  TodoInjection.init();
}
