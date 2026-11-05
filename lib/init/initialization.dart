import 'package:flutter/widgets.dart';

import '../app/localization/tk_localizations.dart';
import '../features/authentication/presentation/bloc/auth_bloc.dart';
import 'dependency_injection.dart';

/// Ordered start-up: bindings, Turkmen date data, the object graph, then the session.
Future<void> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  registerTurkmenDateSymbols();
  await configureDependencies();
  sl<AuthBloc>().add(const AuthStarted());
}
