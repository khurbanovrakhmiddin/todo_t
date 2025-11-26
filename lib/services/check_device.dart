import 'package:flutter/cupertino.dart';

extension BuildContextEntension<T> on BuildContext {
  MediaQueryData get mq => MediaQuery.of(this);

  bool get isMobileOr =>
      (isLandscape ? mq.size.height : mq.size.width) <= 500.0;

  bool get isLandscape => mq.orientation == Orientation.landscape;

  bool get isMobile =>
      mq.size.width <= 500.0 && mq.orientation == Orientation.landscape;

  bool get isTablet => mq.size.width < 1024.0 && mq.size.width >= 650.0;

  bool get isSmallTablet => mq.size.width < 650.0 && mq.size.width > 500.0;

  bool get isDesktop => mq.size.width >= 1024.0;

  bool get isSmall => mq.size.width < 850.0 && mq.size.width >= 560.0;

  double get width => mq.size.width;

  double get height => mq.size.height;

  Size get size => mq.size;
}
