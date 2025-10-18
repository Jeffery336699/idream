import 'dart:math';
import 'package:flutter/material.dart';

class RandomColor {
  final Random _random;
  /// 可选传入 seed 以获得可重复的随机序列
  RandomColor([int? seed]) : _random = seed == null ? Random() : Random(seed);

  /// 生成一个随机颜色，alpha 范围 0-255（默认 255）
  Color randomColor({int alpha = 255}) {
    final int r = _random.nextInt(256);
    final int g = _random.nextInt(256);
    final int b = _random.nextInt(256);
    return Color.fromARGB(alpha.clamp(0, 255), r, g, b);
  }
}