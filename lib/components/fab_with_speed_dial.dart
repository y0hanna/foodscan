import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:kassenzettel_app/models/item_data.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../constants.dart';

class FABWithSpeedDial extends StatefulWidget {
  @override
  _FABWithSpeedDialState createState() => _FABWithSpeedDialState();
}

class _FABWithSpeedDialState extends State<FABWithSpeedDial>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  static const List<IconData> icons = const [
    Icons.edit,
    Icons.photo_camera,
  ];

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  dispose() {
    _controller.dispose(); // you need this
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: new List.generate(icons.length, (int index) {
        Widget child = new Container(
          height: 70.0,
          width: 56.0,
          alignment: FractionalOffset.topCenter,
          child: new ScaleTransition(
            scale: new CurvedAnimation(
              parent: _controller,
              curve: new Interval(0.0, 1.0 - index / icons.length / 2.0,
                  curve: Curves.easeOut),
            ),
            child: new FloatingActionButton(
              heroTag: null,
              backgroundColor: kAccentColor,
              mini: true,
              child: new Icon(icons[index], color: Colors.white),
              onPressed: () {
                if (index == 0) {
                  Provider.of<ItemData>(context, listen: false).resetList();
                  Navigator.pushNamed(context, '/addmanually');
                  _controller.reverse();
                } else if (index == 1) {
                  Navigator.pushNamed(context, '/addreceipt');
                  _controller.reverse();
                }
              },
            ),
          ),
        );
        return child;
      }).toList()
        ..add(
          new FloatingActionButton(
            elevation: 1.0,
            backgroundColor: kAccentColor,
            heroTag: null,
            child: new AnimatedBuilder(
              animation: _controller,
              builder: (BuildContext context, Widget child) {
                return new Transform(
                  transform:
                      new Matrix4.rotationZ(_controller.value * 0.5 * pi),
                  alignment: FractionalOffset.center,
                  child: new Icon(
                      _controller.isDismissed ? Icons.add : Icons.close),
                );
              },
            ),
            onPressed: () {
              if (_controller.isDismissed) {
                _controller.forward();
              } else {
                _controller.reverse();
              }
            },
          ),
        ),
    );
  }
}
