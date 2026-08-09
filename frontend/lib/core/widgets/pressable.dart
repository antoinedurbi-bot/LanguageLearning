import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:learning_app/core/theme/tokens.dart';

/// Tap wrapper that scales slightly on press and fires a haptic tick.
///
/// The scale is applied via `Transform`, so it never changes layout bounds and
/// cannot nudge neighbouring content. Feedback appears within one frame of the
/// pointer going down, well under the 100ms perception threshold.
class Pressable extends StatefulWidget {
  const Pressable({
    super.key,
    required this.child,
    required this.onPressed,
    this.scale = 0.97,
    this.semanticLabel,
    this.haptic = true,
    this.borderRadius,
    this.disabledOpacity = 0.45,
  });

  final Widget child;
  final VoidCallback? onPressed;
  final double scale;
  final String? semanticLabel;
  final bool haptic;
  final BorderRadius? borderRadius;

  /// Opacity applied when [onPressed] is null. Set to 1 where "not tappable"
  /// must not mean "hard to read" — a graded answer, for instance.
  final double disabledOpacity;

  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> {
  bool _down = false;

  bool get _enabled => widget.onPressed != null;

  void _set(bool value) {
    if (_down == value || !_enabled) return;
    setState(() => _down = value);
  }

  @override
  Widget build(BuildContext context) {
    final target = _down && !context.reduceMotion ? widget.scale : 1.0;

    return Semantics(
      button: true,
      enabled: _enabled,
      label: widget.semanticLabel,
      child: MouseRegion(
        cursor: _enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (_) => _set(true),
          onTapUp: (_) => _set(false),
          onTapCancel: () => _set(false),
          onTap: _enabled
              ? () {
                  if (widget.haptic) HapticFeedback.selectionClick();
                  widget.onPressed!.call();
                }
              : null,
          child: AnimatedScale(
            scale: target,
            duration: LL.fast,
            curve: LL.enter,
            child: AnimatedOpacity(
              opacity: _enabled ? 1 : widget.disabledOpacity,
              duration: LL.fast,
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}

/// The app's primary call to action: a gradient pill with a soft coloured
/// glow. Exactly one of these belongs on any given screen.
class GradientButton extends StatelessWidget {
  const GradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.colors,
    this.loading = false,
    this.expand = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final List<Color>? colors;
  final bool loading;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    final ramp = colors ?? [c.accent, c.accentAlt];
    final enabled = onPressed != null && !loading;

    return Pressable(
      onPressed: enabled ? onPressed : null,
      semanticLabel: label,
      child: Container(
        height: 56,
        width: expand ? double.infinity : null,
        padding: expand ? null : const EdgeInsets.symmetric(horizontal: LL.s24),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: ramp),
          borderRadius: BorderRadius.circular(LL.rSm + 6),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: ramp.first.withValues(alpha: 0.38),
                    blurRadius: 28,
                    spreadRadius: -4,
                    offset: const Offset(0, 10),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: loading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.4,
                    color: Colors.white,
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, size: 20, color: Colors.white),
                      const SizedBox(width: LL.s8 + 2),
                    ],
                    Text(
                      label,
                      style: context.type.labelLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
