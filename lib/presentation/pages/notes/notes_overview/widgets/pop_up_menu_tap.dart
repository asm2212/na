// ignore_for_file: overridden_fields

import 'package:flutter/material.dart';

class MyPopupMenuItem<T> extends PopupMenuItem<T> {
  @override
  final Widget child;
  final Function onClick;

  const MyPopupMenuItem({Key? key, required this.child, required this.onClick})
      : super(key: key, child: child);

  @override
  PopupMenuItemState<T, PopupMenuItem<T>> createState() {
    return MyPopupMenuItemState();
  }
}

class MyPopupMenuItemState<T, PopupMenuItem>
    extends PopupMenuItemState<T, MyPopupMenuItem<T>> {
  @override
  void handleTap() {
    Navigator.pop<T>(context);
    widget.onClick();
  }
}
