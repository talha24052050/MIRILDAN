import 'package:flutter/material.dart';
import 'app_colors.dart';

enum EmotionColor {
  yellow,
  blue,
  red,
  green,
  purple,
  gray,
  pink,
  orange,
}

extension EmotionColorExtension on EmotionColor {
  Color get color {
    switch (this) {
      case EmotionColor.yellow:
        return AppColors.emotionYellow;
      case EmotionColor.blue:
        return AppColors.emotionBlue;
      case EmotionColor.red:
        return AppColors.emotionRed;
      case EmotionColor.green:
        return AppColors.emotionGreen;
      case EmotionColor.purple:
        return AppColors.emotionPurple;
      case EmotionColor.gray:
        return AppColors.emotionGray;
      case EmotionColor.pink:
        return AppColors.emotionPink;
      case EmotionColor.orange:
        return AppColors.emotionOrange;
    }
  }

  String get labelTr {
    switch (this) {
      case EmotionColor.yellow:
        return 'Enerji';
      case EmotionColor.blue:
        return 'Sakin';
      case EmotionColor.red:
        return 'Öfke';
      case EmotionColor.green:
        return 'Huzur';
      case EmotionColor.purple:
        return 'Düşünceli';
      case EmotionColor.gray:
        return 'Boş';
      case EmotionColor.pink:
        return 'Sevgi';
      case EmotionColor.orange:
        return 'Heyecan';
    }
  }

  String get key => name;
}
