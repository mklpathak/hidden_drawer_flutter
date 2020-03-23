import 'package:rxdart/rxdart.dart';

class DrawerHelper {
  factory DrawerHelper() => DrawerHelper._instance;
  static final DrawerHelper _instance = new DrawerHelper._();
  BehaviorSubject<bool> _replaySubject;

  Stream get stream => _replaySubject.stream;

  static bool drawerStatus = false;

  void toggleDrawer() {
    drawerStatus = !drawerStatus;
    _replaySubject.add(drawerStatus);
  }

  void dispose() {
    // _replaySubject.close(); // close our StreamController to avoid memory leak
  }

  DrawerHelper._() {
    this._replaySubject = BehaviorSubject();
  }
}
