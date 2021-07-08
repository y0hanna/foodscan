import 'package:flutter/material.dart';

import '../constants.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  String title;
  List<Widget> action;
  TabBar bottom;

  MainAppBar(String title, {List<Widget> action, TabBar bottom}) {
    this.title = title;
    this.action = action;
    this.bottom = bottom;
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(title),
      automaticallyImplyLeading: true,
      backgroundColor: kAccentColor,
      actions: action,
      bottom: bottom,
    );
  }
}
