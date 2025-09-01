import 'package:flutter/material.dart';

abstract class CustomIcons {
  static const String _kCheckIcon = 'assets/vectors/check_icon.png';
  static const String _kLeftArrowIcon = 'assets/vectors/left_arrow_icon.png';
  static const String _kRightArrowIcon = 'assets/vectors/right_arrow_icon.png';
  static const String _kCrossIcon = 'assets/vectors/cross_icon.png';
  static const String _kParkingIcon = 'assets/vectors/parking_icon.png';
  static const String _kSocietyIcon = 'assets/vectors/society_icon.png';
  static const String _kLocationIcon = 'assets/vectors/location_vector.png';

  static Widget checkIcon([double? height, double? width]) =>
      Image.asset(_kCheckIcon, height: height ?? 24, width: width ?? 24);

  static Widget leftArrowIcon([double? height, double? width]) =>
      Image.asset(_kLeftArrowIcon, height: height ?? 24, width: width ?? 24);

  static Widget rightArrowIcon([double? height, double? width]) =>
      Image.asset(_kRightArrowIcon, height: height ?? 24, width: width ?? 24);

  static Widget crossIcon([double? height, double? width]) =>
      Image.asset(_kCrossIcon, height: height ?? 24, width: width ?? 24);

  static Widget parkingIcon([double? height, double? width]) =>
      Image.asset(_kParkingIcon, height: height ?? 24, width: width ?? 24);

  static Widget societyIcon([double? height, double? width]) =>
      Image.asset(_kSocietyIcon, height: height ?? 24, width: width ?? 24);

  static Widget locationIcon([double? height, double? width]) =>
      Image.asset(_kLocationIcon, height: height ?? 24, width: width ?? 24);
}
