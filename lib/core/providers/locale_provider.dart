import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() => const Locale('tr');

  void setLocale(Locale locale) => state = locale;

  void setLanguageCode(String code) => state = Locale(code);
}

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(
  LocaleNotifier.new,
);
