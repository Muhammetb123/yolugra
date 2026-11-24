import 'package:flutter/widgets.dart';

import '../app/localization/tk_localizations.dart';
import '../features/authentication/presentation/bloc/auth_bloc.dart';
import '../features/notifications/data/push_service.dart';
import 'dependency_injection.dart';

/// Ordered start-up: bindings, Turkmen date data, Firebase, the object graph, then the session.
Future<void> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  registerTurkmenDateSymbols();
  final pushAvailable = await PushService.initialize();
  await configureDependencies(pushAvailable: pushAvailable);
  sl<AuthBloc>().add(const AuthStarted());
}
