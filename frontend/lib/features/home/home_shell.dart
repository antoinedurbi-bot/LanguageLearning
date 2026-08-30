import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:learning_app/app/app_state.dart';
import 'package:learning_app/core/theme/tokens.dart';
import 'package:learning_app/features/chinese/chinese_lab_screen.dart';
import 'package:learning_app/features/home/home_screen.dart';
import 'package:learning_app/features/japanese/japanese_lab_screen.dart';
import 'package:learning_app/features/lessons/unit_list_screen.dart';
import 'package:learning_app/features/practice/practice_screen.dart';
import 'package:learning_app/features/practice/weak_spots_screen.dart';
import 'package:learning_app/features/profile/profile_screen.dart';
import 'package:provider/provider.dart';

/// Top-level navigation: labels always visible, current tab highlighted, and
/// each tab keeps its own scroll position across switches.
///
/// A fifth destination appears for Mandarin only. Tones, characters and
/// stroke order have no equivalent in the other three languages, and burying
/// them inside a generic tab would hide the tools that matter most for the
/// one language that needs them.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;
  int _previousIndex = 0;

  static const _baseDestinations = [
    (icon: Icons.bolt_outlined, active: Icons.bolt, label: 'Aujourd\'hui'),
    (
      icon: Icons.auto_stories_outlined,
      active: Icons.auto_stories,
      label: 'Parcours'
    ),
    (icon: Icons.mic_none_outlined, active: Icons.mic, label: 'Atelier'),
    (
      icon: Icons.gps_not_fixed_rounded,
      active: Icons.gps_fixed_rounded,
      label: 'Faibles'
    ),
    (icon: Icons.insights_outlined, active: Icons.insights, label: 'Progrès'),
  ];

  static const _chineseDestination = (
    icon: Icons.translate_outlined,
    active: Icons.translate,
    label: '中文',
  );

  static const _japaneseDestination = (
    icon: Icons.translate_outlined,
    active: Icons.translate,
    label: '日本語',
  );

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    final language = context.select<LearningController, String?>(
      (controller) => controller.language?.code,
    );
    final isChinese = language == 'zh';
    final isJapanese = language == 'ja';

    final destinations = [
      ..._baseDestinations,
      if (isChinese) _chineseDestination,
      if (isJapanese) _japaneseDestination,
    ];
    // Switching away from Mandarin removes a tab, so an index pointing at it
    // would fall off the end.
    final index = _index.clamp(0, destinations.length - 1);

    final tabs = [
      const HomeScreen(),
      const UnitListScreen(),
      const PracticeScreen(),
      const WeakSpotsScreen(),
      const ProfileScreen(),
      if (isChinese) const ChineseLabScreen(),
      if (isJapanese) const JapaneseLabScreen(),
    ];

    return Scaffold(
      extendBody: true,
      body: ColoredBox(
        color: c.background,
        child: SafeArea(
          bottom: false,
          child: PageTransitionSwitcher(
            duration: LL.medium,
            reverse: index < _previousIndex,
            transitionBuilder: (child, animation, secondaryAnimation) {
              if (context.reduceMotion) return child;
              return SharedAxisTransition(
                animation: animation,
                secondaryAnimation: secondaryAnimation,
                transitionType: SharedAxisTransitionType.horizontal,
                child: child,
              );
            },
            child: KeyedSubtree(
              key: ValueKey(index),
              child: tabs[index],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _GlassNavBar(
        index: index,
        destinations: destinations,
        onChanged: (value) => setState(() {
          _previousIndex = _index;
          _index = value;
        }),
      ),
    );
  }
}

typedef _Destination = ({IconData icon, IconData active, String label});

class _GlassNavBar extends StatelessWidget {
  const _GlassNavBar({
    required this.index,
    required this.destinations,
    required this.onChanged,
  });

  final int index;
  final List<_Destination> destinations;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;

    // Flat, solid nav bar — no translucency, a plain top hairline in the
    // Mimi "paper" language rather than a frosted glass strip.
    return Container(
      padding: EdgeInsets.only(bottom: bottomInset),
      decoration: BoxDecoration(
        color: c.surface,
        border: Border(top: BorderSide(color: c.divider, width: 2)),
      ),
      child: SizedBox(
        height: 68,
        child: Row(
          children: [
            for (var i = 0; i < destinations.length; i++)
              Expanded(
                child: _NavItem(
                  destination: destinations[i],
                  selected: i == index,
                  onTap: () {
                    if (i != index) HapticFeedback.selectionClick();
                    onChanged(i);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.destination,
    required this.selected,
    required this.onTap,
  });

  final _Destination destination;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    final iconColor = selected ? c.onAccent : c.textTertiary;

    return Semantics(
      selected: selected,
      button: true,
      label: destination.label,
      child: InkWell(
        onTap: onTap,
        // Full-height ink target: comfortably past 48dp.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Color-blocked "pill" active indicator, in place of the old
            // gradient glow underline — a solid coral chip behind the icon.
            AnimatedContainer(
              duration: LL.fast,
              curve: LL.spring,
              padding: EdgeInsets.symmetric(
                horizontal: selected ? LL.s16 : LL.s8,
                vertical: LL.s4,
              ),
              decoration: BoxDecoration(
                color: selected ? c.accent : Colors.transparent,
                borderRadius: BorderRadius.circular(LL.rPill),
              ),
              child: Icon(
                selected ? destination.active : destination.icon,
                color: iconColor,
                size: 22,
              ),
            ),
            const SizedBox(height: LL.s4),
            Text(
              destination.label,
              style: context.type.labelSmall?.copyWith(
                fontFamily: 'Fredoka',
                color: selected ? c.accent : c.textTertiary,
                letterSpacing: 0.1,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
