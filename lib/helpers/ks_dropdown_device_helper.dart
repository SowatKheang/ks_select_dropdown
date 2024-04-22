
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

///
/// [KSDropDownDeviceHelper]
///
class KSDropDownDeviceHelper {
  static const String platformiOSText = 'iOS';
  static const String platformAndroidText = 'Android';

  static KSDropDownDeviceHelper? _instance;
  
  static KSDropDownDeviceHelper getInstance() {
    _instance ??= KSDropDownDeviceHelper();
    return _instance!;
  }
  
  ScreenType? _screenType;
  Orientation? _orientation;

  ScreenType get screenType => _screenType!;
  Orientation get orientation => _orientation!;

  void setScreenType(ScreenType screenType) => _screenType = screenType;

  void setOrientation(Orientation orientation) => _orientation = orientation;

  bool get isTabletLandscapeMode => (_screenType == ScreenType.tablet && _orientation == Orientation.landscape);

  bool get isTablet => screenType == ScreenType.tablet;

  bool get isLandscape => _orientation == Orientation.landscape;

  String get platForm => Platform.isIOS ? KSDropDownDeviceHelper.platformiOSText : KSDropDownDeviceHelper.platformAndroidText;

}