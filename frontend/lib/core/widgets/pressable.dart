import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:learning_app/core/theme/tokens.dart';
import 'package:learning_app/services/sound_service.dart';

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
                  if (widget.haptic) {
                    HapticFeedback.selectionClick();
                    playSfx(context, SfxSound.tap);
                  }
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

/// The app's primary call to action — a "physical" button: a solid pill with
/// a solid-colour drop shadow directly below it, like a pressed keycap
/// (`box-shadow: 0 6px 0 <darker-shade>` in the mockup) rather than a soft
/// blurred glow. On press it depresses toward its shadow and the shadow
/// shrinks, then springs back on release. Exactly one of these belongs on
/// any given screen. `GradientButton` is the historical name kept for the
/// dozens of call sites already using it; despite the name it now renders
/// as a flat physical button rather than a gradient.
class GradientButton extends StatefulWidget {
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

  /// First entry is the fill; a darker shade is derived for the shadow. A
  /// second/third entry (used historically for gradients) is accepted but
  /// only the first colour paints the physical fill now.
  final List<Color>? colors;
  final bool loading;
  final bool expand;

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> {
  bool _down = false;

  bool get _enabled => widget.onPressed != null && !widget.loading;

  void _set(bool value) {
    if (_down == value || !_enabled) return;
    setState(() => _down = value);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    final fill = widget.colors?.first ?? c.accent;
    final shadowColor = LLColors.pressedShadeOf(fill);
    // Picked per-fill rather than hard-coded: white fails AA contrast
    // (~2-2.5:1) on the lighter sage/marigold fills, e.g. the Spanish
    // language ramp, which starts with marigold.
    final fg = LLColors.readableOn(fill);
    const restOffset = 6.0;
    final offset = context.reduceMotion
        ? (_down ? 0.0 : restOffset)
        : (_down && _enabled ? 1.5 : restOffset);

    return Semantics(
      button: true,
      enabled: _enabled,
      label: widget.label,
      child: MouseRegion(
        cursor:
            _enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (_) => _set(true),
          onTapUp: (_) => _set(false),
          onTapCancel: () => _set(false),
          onTap: _enabled
              ? () {
                  HapticFeedback.mediumImpact();
                  playSfx(context, SfxSound.tap);
                  widget.onPressed!.call();
                }
              : null,
          child: AnimatedOpacity(
            opacity: _enabled || widget.loading ? 1 : 0.45,
            duration: LL.fast,
            child: AnimatedContainer(
              duration: LL.fast,
              curve: LL.enter,
              padding: EdgeInsets.only(bottom: restOffset - offset),
              width: widget.expand ? double.infinity : null,
              child: Container(
                height: 56,
                width: widget.expand ? double.infinity : null,
                padding: widget.expand
                    ? null
                    : const EdgeInsets.symmetric(horizontal: LL.s24),
                decoration: BoxDecoration(
                  color: fill,
                  borderRadius: BorderRadius.circular(LL.rPill),
                  boxShadow: [
                    BoxShadow(
                      color: shadowColor,
                      offset: Offset(0, offset),
                    ),
                  ],
                ),
                child: Center(
                  child: widget.loading
                      ? SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.4,
                            color: fg,
                          ),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (widget.icon != null) ...[
                              Icon(widget.icon, size: 20, color: fg),
                              const SizedBox(width: LL.s8 + 2),
                            ],
                            Text(
                              widget.label,
                              style: context.type.labelLarge?.copyWith(
                                fontFamily: 'Fredoka',
                                color: fg,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A smaller physical button — same pressed-keycap language as
/// [GradientButton] but sized for secondary actions (a chip-sized CTA next
/// to a bigger primary one, an inline "retry", etc).
class PhysicalButton extends StatefulWidget {
  const PhysicalButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.color,
    this.filled = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? color;

  /// When false, renders as an outlined physical button (ink/cream on
  /// transparent) instead of a solid fill — used for secondary choices.
  final bool filled;

  @override
  State<PhysicalButton> createState() => _PhysicalButtonState();
}

class _PhysicalButtonState extends State<PhysicalButton> {
  bool _down = false;

  bool get _enabled => widget.onPressed != null;

  void _set(bool value) {
    if (_down == value || !_enabled) return;
    setState(() => _down = value);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    final base = widget.color ?? c.accent;
    final fill = widget.filled ? base : c.surface;
    final shadowColor =
        widget.filled ? LLColors.pressedShadeOf(base) : c.glassStroke;
    final fg = widget.filled ? LLColors.readableOn(base) : base;
    const restOffset = 4.0;
    final offset = _down && _enabled ? 1.0 : restOffset;

    return Semantics(
      button: true,
      enabled: _enabled,
      label: widget.label,
      child: MouseRegion(
        cursor:
            _enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (_) => _set(true),
          onTapUp: (_) => _set(false),
          onTapCancel: () => _set(false),
          onTap: _enabled
              ? () {
                  HapticFeedback.selectionClick();
                  playSfx(context, SfxSound.tap);
                  widget.onPressed!.call();
                }
              : null,
          child: AnimatedOpacity(
            opacity: _enabled ? 1 : 0.45,
            duration: LL.fast,
            child: AnimatedContainer(
              duration: LL.fast,
              curve: LL.enter,
              padding: EdgeInsets.only(bottom: restOffset - offset),
              child: Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: LL.s16),
                decoration: BoxDecoration(
                  color: fill,
                  borderRadius: BorderRadius.circular(LL.rPill),
                  border: widget.filled
                      ? null
                      : Border.all(color: base, width: 2),
                  boxShadow: [
                    BoxShadow(color: shadowColor, offset: Offset(0, offset)),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.icon != null) ...[
                      Icon(widget.icon, size: 16, color: fg),
                      const SizedBox(width: LL.s4 + 2),
                    ],
                    Text(
                      widget.label,
                      style: context.type.labelMedium?.copyWith(
                        fontFamily: 'Fredoka',
                        color: fg,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
