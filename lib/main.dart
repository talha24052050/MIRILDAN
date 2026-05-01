import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'data/services/database_service.dart';
import 'features/settings/data/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseService.init();
  await NotificationService.instance.init();
  // Firebase config dosyaları (google-services.json / GoogleService-Info.plist)
  // FlutterFire CLI ile eklenene kadar hata fırlatmaz; misafir mod çalışmaya devam eder.
  try {
    await Firebase.initializeApp();
  } catch (_) {}
  runApp(const ProviderScope(child: MiriildanApp()));
}
