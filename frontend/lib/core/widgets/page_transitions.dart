import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:learning_app/core/theme/tokens.dart';

/// A push route using Material's shared-axis (horizontal) motion instead of
/// the platform's default fade/slide — the "next screen enters from the
/// right while the current one exits to the left" language used throughout
/// Material Motion for lateral, list-to-detail-style navigation.
///
/// Route-level replacement for `MaterialPageRoute` at the call sites this
/// pass touches; respects reduced-motion by falling back to an instant cut.
class SharedAxisRoute<T> extends PageRouteBuilder<T> {
  SharedAxisRoute({required WidgetBuilder builder, super.settings})
      : super(
          transitionDuration: LL.medium,
          reverseTransitionDuration: LL.medium,
          pageBuilder: (context, animation, secondaryAnimation) =>
              builder(context),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            if (MediaQuery.maybeDisableAnimationsOf(context) ?? false) {
              return child;
            }
            return SharedAxisTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.horizontal,
              child: child,
            );
          },
        );
}
