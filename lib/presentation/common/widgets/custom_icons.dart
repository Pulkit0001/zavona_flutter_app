import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

abstract class CustomIcons {
  static const String _kCheckIcon = 'assets/vectors/check_icon.png';
  static const String _kLeftArrowIcon = 'assets/vectors/left_arrow_icon.png';
  static const String _kRightArrowIcon = 'assets/vectors/right_arrow_icon.png';
  static const String _kCrossIcon = 'assets/vectors/cross_icon.png';
  static const String _kParkingIcon = 'assets/vectors/parking_icon.png';
  static const String _kSocietyIcon = 'assets/vectors/society_icon.png';
  static const String _kLocationIcon = 'assets/vectors/location_vector.png';

  static const String _kCarIcon = 'assets/vectors/car_vector.png';
  static const String _kSedanIcon = 'assets/vectors/sedan_vector.png';
  static const String _kSuvIcon = 'assets/vectors/suv_vector.png';
  static const String _kTwoWheelerIcon =
      'assets/vectors/two_wheeler_vector.png';

  static const String _kRentIcon = 'assets/vectors/rent_vector.png';
  static const String _kSellIcon = 'assets/vectors/sell_vector.png';

  static const String _kCameraIcon = 'assets/vectors/camera_vector.png';

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

  static Widget carIcon([double? height, double? width]) =>
      Image.asset(_kCarIcon, height: height ?? 24, width: width ?? 24);

  static Widget sedanIcon([double? height, double? width]) =>
      Image.asset(_kSedanIcon, height: height ?? 24, width: width ?? 24);

  static Widget suvIcon([double? height, double? width]) =>
      Image.asset(_kSuvIcon, height: height ?? 24, width: width ?? 24);

  static Widget twoWheelerIcon([double? height, double? width]) =>
      Image.asset(_kTwoWheelerIcon, height: height ?? 24, width: width ?? 24);

  static Widget rentIcon([double? height, double? width]) =>
      Image.asset(_kRentIcon, height: height ?? 24, width: width ?? 24);

  static Widget sellIcon([double? height, double? width]) =>
      Image.asset(_kSellIcon, height: height ?? 24, width: width ?? 24);

  static Widget cameraIcon([double? height, double? width]) =>
      Image.asset(_kCameraIcon, height: height ?? 24, width: width ?? 24);
}
