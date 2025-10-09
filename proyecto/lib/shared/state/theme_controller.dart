import 'package:flutter/material.dart';

class ThemeController extends ChangeNotifier {
  double _sliderValue = 0.0;

  double get sliderValue => _sliderValue;
  ThemeMode get themeMode =>
      _sliderValue < 0.5 ? ThemeMode.light : ThemeMode.dark;

  bool get isDark => _sliderValue >= 0.5;
  void setSlider(double value) {
    _sliderValue = value.clamp(0.0, 1.0);
    notifyListeners();
  }

  void setDark(bool value) => setSlider(value ? 1.0 : 0.0);
  void toggle() => setDark(!isDark);
}
