import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../providers/floatingbutton/MyFloatingButtonProvider.dart';

class MyScrollAnimation {

  late BuildContext _context;
  late ScrollController _controller;
  late double _actualScrollPosition;

  MyScrollAnimation(BuildContext context, ScrollController controller, double actualScrollPosition) {

    _context = context;
    _controller = controller;
    _actualScrollPosition = actualScrollPosition;
  }

  ///FloatingActionButton ScrollAnimation
  void scrollListener() {

    double activateChange = 30;
    final actualOffset = _controller.offset;

    if (actualOffset < (_actualScrollPosition - activateChange)) {
      Provider.of<MyFloatingButtonProvider>(_context, listen: false).updateExtended(true);
    } else if (actualOffset > (_actualScrollPosition + 10)) {
      Provider.of<MyFloatingButtonProvider>(_context, listen: false).updateExtended(false);
    }

    if ((actualOffset - _actualScrollPosition).abs() >= activateChange) {
      _actualScrollPosition = actualOffset;
    }
  }
}