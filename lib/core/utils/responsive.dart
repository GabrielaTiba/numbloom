import 'package:flutter/widgets.dart';

enum ScreenSize { compact, medium, expanded }

/// Breakpoints: celular (<600), tablet (<1024), desktop/web largo (>=1024).
class Responsive {
  const Responsive._();

  static const double mediumBreakpoint = 600;
  static const double expandedBreakpoint = 1024;

  static ScreenSize of(double width) {
    if (width < mediumBreakpoint) return ScreenSize.compact;
    if (width < expandedBreakpoint) return ScreenSize.medium;
    return ScreenSize.expanded;
  }
}

extension ResponsiveContext on BuildContext {
  ScreenSize get screenSize => Responsive.of(MediaQuery.sizeOf(this).width);
}