import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_preferences.freezed.dart';
part 'user_preferences.g.dart';

@freezed
abstract class UserPreferences with _$UserPreferences {
  const factory UserPreferences({
    @Default('darkGalaxy') String theme,
    @Default('tr') String languageCode,
    String? notificationTime,
    @Default(false) bool notificationsEnabled,
    @Default(false) bool onboardingCompleted,
  }) = _UserPreferences;

  factory UserPreferences.fromJson(Map<String, dynamic> json) =>
      _$UserPreferencesFromJson(json);
}
