import 'package:flutter/material.dart';

PageRouteBuilder _customPageRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) {
      return page;
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Define the animation
      var begin = Offset(1.0, 0.0); // Start from the right
      var end = Offset.zero;
      var curve = Curves.easeInOut; // Choose a curve for smoothness
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      // Slide transition
      return SlideTransition(position: offsetAnimation, child: child);
    },
  );
}
