import 'package:flutter/widgets.dart';

import 'app/app.dart';
import 'init/initialization.dart';

Future<void> main() async {
  await initializeApp();
  runApp(const YolugraApp());
}
