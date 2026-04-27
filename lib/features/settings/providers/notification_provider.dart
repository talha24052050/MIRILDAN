import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/preferences_repository.dart';
import '../data/notification_service.dart';

class NotificationNotifier extends Notifier<({bool enabled, TimeOfDay time})> {
  static const _defaultTime = TimeOfDay(hour: 20, minute: 0);

  @override
  ({bool enabled, TimeOfDay time}) build() {
    _loadSaved();
    return (enabled: false, time: _defaultTime);
  }

  Future<void> _loadSaved() async {
    final prefs = await PreferencesRepository().get();
    TimeOfDay time = _defaultTime;
    if (prefs.notificationTime != null) {
      final parts = prefs.notificationTime!.split(':');
      if (parts.length == 2) {
        time = TimeOfDay(
          hour: int.tryParse(parts[0]) ?? 20,
          minute: int.tryParse(parts[1]) ?? 0,
        );
      }
    }
    state = (enabled: prefs.notificationsEnabled, time: time);
  }

  Future<void> setEnabled(bool enabled) async {
    state = (enabled: enabled, time: state.time);
    final repo = PreferencesRepository();
    final current = await repo.get();
    await repo.save(current.copyWith(notificationsEnabled: enabled));

    if (enabled) {
      await NotificationService.instance.requestPermission();
      await NotificationService.instance.scheduleDailyReminder(state.time);
    } else {
      await NotificationService.instance.cancelAll();
    }
  }

  Future<void> setTime(TimeOfDay time) async {
    state = (enabled: state.enabled, time: time);
    final timeStr = '${time.hour}:${time.minute}';
    final repo = PreferencesRepository();
    final current = await repo.get();
    await repo.save(current.copyWith(notificationTime: timeStr));

    if (state.enabled) {
      await NotificationService.instance.scheduleDailyReminder(time);
    }
  }
}

final notificationProvider =
    NotifierProvider<NotificationNotifier, ({bool enabled, TimeOfDay time})>(
      NotificationNotifier.new,
    );
