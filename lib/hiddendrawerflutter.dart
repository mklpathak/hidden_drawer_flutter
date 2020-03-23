import 'package:flutter/material.dart';

import 'drawer_helper.dart';

class HiddenDrawer extends StatefulWidget {
  final Widget child;
  final Widget drawer;

  const HiddenDrawer({@required this.child, this.drawer});
  @override
  _HiddenDrawerState createState() => _HiddenDrawerState();
}

class _HiddenDrawerState extends State<HiddenDrawer>
    with SingleTickerProviderStateMixin {
  AnimationController _animationcontroller;
  Animation curve;
  Animation<double> translate;
  Animation<double> scale;
  Animation<double> radius;
  Animation<double> elevation;
  bool _menuState = false;

  DrawerHelper _drawerHelper = DrawerHelper();

  @override
  void initState() {
    _animationcontroller = AnimationController(
        duration: const Duration(milliseconds: 400), vsync: this)
      ..addStatusListener((status) {
        _menuState = status == AnimationStatus.completed ? true : false;
      });
    curve = CurvedAnimation(parent: _animationcontroller, curve: Curves.easeIn);
    scale = Tween<double>(begin: 1, end: 0.7).animate(curve);
    translate = Tween<double>(begin: 0, end: 300).animate(curve);
    radius = Tween<double>(begin: 0, end: 32).animate(curve);
    elevation = Tween<double>(begin: 0, end: 32).animate(curve);

    _drawerHelper.stream.listen((drawerStatus) {
      if (drawerStatus) {
        _animationcontroller.forward();
      } else {
        _animationcontroller.reverse();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.drawer == null) return widget.child;

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        widget.drawer,
        AnimatedBuilder(
          animation: _animationcontroller,
          builder: (context, child) => Stack(
            children: <Widget>[
              Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..scale(scale.value * 0.9, scale.value * 0.9)
                  ..translate(translate.value * 0.97),
                // perspective,
                // changed
                alignment: FractionalOffset.center,
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  margin: EdgeInsets.all(0),
                  elevation: elevation.value,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(radius.value)),
                  child: Container(
                    color: Colors.white,
                  ),
                ),
              ),
              Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..scale(scale.value, scale.value)
                  ..translate(translate.value),
                // perspective,
                // changed
                alignment: FractionalOffset.center,
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  margin: EdgeInsets.all(0),
                  elevation: elevation.value,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(radius.value)),
                  child: child,
                ),
              )
            ],
          ),
          child: widget.child,
        )
      ],
    );
  }
}
