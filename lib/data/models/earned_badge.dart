import 'package:freezed_annotation/freezed_annotation.dart';

part 'earned_badge.freezed.dart';
part 'earned_badge.g.dart';

@freezed
abstract class EarnedBadge with _$EarnedBadge {
  const factory EarnedBadge({
    required int id,
    required String badgeId,
    required DateTime earnedAt,
  }) = _EarnedBadge;

  factory EarnedBadge.fromJson(Map<String, dynamic> json) =>
      _$EarnedBadgeFromJson(json);
}
