import 'package:flutter/material.dart';

class GoRouterObserver extends NavigatorObserver {
  GoRouterObserver();

  @override
  void didPop(Route route, Route? previousRoute) {
    debugPrint(
        "DidPop : ${route.settings.name}, Previous Route : ${previousRoute?.settings.name}");
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    debugPrint(
        "DidPush : ${route.settings.name}, Previous Route : ${previousRoute?.settings.name}");
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    debugPrint(
        "DidRemove : ${route.settings.name}, Previous Route : ${previousRoute?.settings.name}");
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    debugPrint(
        "DidReplace : ${newRoute?.settings.name}, oldRoute: ${oldRoute?.settings.name}");
  }

  @override
  void didStartUserGesture(Route route, Route? previousRoute) {
    debugPrint(
        "DidStartUserGesture : ${route.settings.name}, Previous Route : ${previousRoute?.settings.name}");
  }

  @override
  void didStopUserGesture() {
    debugPrint("DidStopUserGesture");
  }
}
