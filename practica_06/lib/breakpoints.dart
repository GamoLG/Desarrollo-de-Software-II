import 'package:flutter/material.dart';

class Breakpoints {
  static const double mobile = 480;
  static const double tablet = 768;
  static const double desktop = 1024;
  static const double wide = 1440;

  static bool isMobile(BuildContext ctx) =>
      MediaQuery.sizeOf(ctx).width < mobile;

  static bool isTablet(BuildContext ctx) {
    final w = MediaQuery.sizeOf(ctx).width;
    return w >= mobile && w < desktop;
  }

  static bool isDesktop(BuildContext ctx) =>
      MediaQuery.sizeOf(ctx).width >= desktop;
}