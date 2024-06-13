import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:firebase_core/firebase_core.dart';

import './injection.dart';
import './presentation/app_widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  configureInjection(Environment.prod);
  runApp(AppWidget());
}
