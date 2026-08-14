import 'package:flutter/material.dart';
import 'package:learning_app/app/app_state.dart';
import 'package:learning_app/core/theme/tokens.dart';
import 'package:learning_app/core/widgets/aurora_background.dart';
import 'package:learning_app/features/chinese/chinese_lab_screen.dart';
import 'package:learning_app/features/home/home_screen.dart';
import 'package:learning_app/features/lessons/unit_list_screen.dart';
import 'package:learning_app/features/practice/practice_screen.dart';
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

  static const _baseDestinations = [
    (icon: Icons.bolt_outlined, active: Icons.bolt, label: 'Aujourd\'hui'),
    (
      icon: Icons.auto_stories_outlined,
      active: Icons.auto_stories,
      label: 'Parcours'
    ),
    (icon: Icons.mic_none_outlined, active: Icons.mic, label: 'Atelier'),
    (icon: Icons.insights_outlined, active: Icons.insights, label: 'Progres'),
  ];

  static const _chineseDestination = (
    icon: Icons.translate_outlined,
    active: Icons.translate,
    label: '中文',
  );

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    final language = context.select<LearningController, String?>(
      (controller) => controller.language?.code,
    );
    final ramp = language == null ? null : LL.gradientFor(language);
    final isChinese = language == 'zh';

    final destinations = [
      ..._baseDestinations,
      if (isChinese) _chineseDestination,
    ];
    // Switching away from Mandarin removes a tab, so an index pointing at it
    // would fall off the end.
    final index = _index.clamp(0, destinations.length - 1);

    return Scaffold(
      extendBody: true,
      body: AuroraBackground(
        colors: ramp == null ? null : [ramp.first, ramp.last, c.auroraC],
        child: SafeArea(
          bottom: false,
          child: IndexedStack(
            index: index,
            children: [
              const HomeScreen(),
              const UnitListScreen(),
              const PracticeScreen(),
              const ProfileScreen(),
              if (isChinese) const ChineseLabScreen(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _GlassNavBar(
        index: index,
        destinations: destinations,
        onChanged: (value) => setState(() => _index = value),
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

    return Container(
      padding: EdgeInsets.only(bottom: bottomInset),
      decoration: BoxDecoration(
        color: c.background.withValues(alpha: c.isDark ? 0.88 : 0.94),
        border: Border(top: BorderSide(color: c.divider)),
      ),
      child: SizedBox(
        height: 64,
        child: Row(
          children: [
            for (var i = 0; i < destinations.length; i++)
              Expanded(
                child: _NavItem(
                  destination: destinations[i],
                  selected: i == index,
                  onTap: () => onChanged(i),
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
    final color = selected ? c.accent : c.textTertiary;

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
            AnimatedContainer(
              duration: LL.fast,
              curve: LL.enter,
              height: 3,
              width: selected ? 22 : 0,
              margin: const EdgeInsets.only(bottom: LL.s8),
              decoration: BoxDecoration(
                color: c.accent,
                borderRadius: BorderRadius.circular(LL.rPill),
              ),
            ),
            Icon(
              selected ? destination.active : destination.icon,
              color: color,
              size: 24,
            ),
            const SizedBox(height: LL.s4),
            Text(
              destination.label,
              style: context.type.labelSmall?.copyWith(
                color: color,
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
