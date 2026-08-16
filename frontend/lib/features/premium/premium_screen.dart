import 'package:flutter/material.dart';
import 'package:learning_app/app/app_state.dart';
import 'package:learning_app/core/theme/tokens.dart';
import 'package:learning_app/core/widgets/aurora_background.dart';
import 'package:learning_app/core/widgets/glass.dart';
import 'package:learning_app/core/widgets/illustration.dart';
import 'package:learning_app/core/widgets/motion.dart';
import 'package:learning_app/core/widgets/pressable.dart';
import 'package:learning_app/data/models/entitlement.dart';
import 'package:provider/provider.dart';

/// Opens the paywall. The one call site every lock in the app should use, so
/// "what happens when I tap a locked feature" is answered the same way
/// everywhere.
void openPaywall(BuildContext context, {PremiumPerk? reason}) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(builder: (_) => PremiumScreen(reason: reason)),
  );
}

/// The paywall. One screen, reached from every lock in the app, so upgrading
/// is never a mystery about what it actually buys.
class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key, this.reason});

  /// What the learner tried to do when they hit this screen — shown at the
  /// top so the paywall answers "why am I here" before "what do I get".
  final PremiumPerk? reason;

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  final _codeController = TextEditingController();
  String? _error;
  bool _checking = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _redeem() async {
    final code = _codeController.text.trim();
    if (code.isEmpty) return;

    setState(() {
      _checking = true;
      _error = null;
    });

    final controller = context.read<LearningController>();
    final before = controller.isPremium;
    await controller.unlockPremium(code);

    if (!mounted) return;
    if (controller.isPremium && !before) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Premium débloqué. Profites-en.')),
      );
    } else {
      setState(() {
        _checking = false;
        _error = 'Code invalide.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    final controller = context.watch<LearningController>();

    if (controller.isPremium) {
      return Scaffold(
        body: AuroraBackground(
          colors: [c.success, c.accent, c.auroraC],
          child: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(LL.s32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Illustration(Illust.trophy, size: 96, haloColors: [c.success, c.accent]),
                    const SizedBox(height: LL.s20),
                    Text('Tu es déjà premium',
                        style: context.type.headlineSmall,
                        textAlign: TextAlign.center),
                    const SizedBox(height: LL.s24),
                    OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Retour'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: AuroraBackground(
        colors: [LL.violet, LL.cyan, c.auroraC],
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(LL.s8, LL.s8, LL.s20, LL.s8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close_rounded),
                      tooltip: 'Fermer',
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(LL.s24, LL.s8, LL.s24, LL.s32),
                  children: [
                    const Reveal(
                      child: Center(
                        child: Illustration(Illust.rocket,
                            size: 88, haloColors: [LL.violet, LL.cyan]),
                      ),
                    ),
                    const SizedBox(height: LL.s20),
                    Reveal(
                      index: 1,
                      child: Text(
                        widget.reason != null
                            ? widget.reason!.label
                            : 'Passe à Premium',
                        textAlign: TextAlign.center,
                        style: context.type.displaySmall,
                      ),
                    ),
                    const SizedBox(height: LL.s8),
                    Reveal(
                      index: 2,
                      child: Text(
                        widget.reason != null
                            ? widget.reason!.detail
                            : 'Tout ce que l\'app peut faire, sans limite.',
                        textAlign: TextAlign.center,
                        style: context.type.bodyLarge,
                      ),
                    ),
                    const SizedBox(height: LL.s32),
                    for (var i = 0; i < PremiumPerk.values.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: LL.s8 + 2),
                        child: Reveal(
                          index: i + 3,
                          child: _PerkRow(
                            perk: PremiumPerk.values[i],
                            highlighted: PremiumPerk.values[i] == widget.reason,
                          ),
                        ),
                      ),
                    const SizedBox(height: LL.s32),
                    GlassCard(
                      borderColor: c.accent.withValues(alpha: 0.3),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.info_outline_rounded,
                                  size: 16, color: c.textTertiary),
                              const SizedBox(width: LL.s8),
                              Expanded(
                                child: Text(
                                  'L\'abonnement n\'est pas encore branché à un '
                                  'moyen de paiement réel dans cette version.',
                                  style: context.type.labelSmall?.copyWith(
                                    color: c.textTertiary,
                                    letterSpacing: 0.1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: LL.s16),
                          Text('CODE D\'ACCÈS', style: context.type.labelSmall),
                          const SizedBox(height: LL.s8),
                          TextField(
                            controller: _codeController,
                            autocorrect: false,
                            onSubmitted: (_) => _redeem(),
                            decoration: InputDecoration(
                              hintText: 'Entrer un code',
                              errorText: _error,
                            ),
                          ),
                          const SizedBox(height: LL.s16),
                          GradientButton(
                            label: 'Valider',
                            colors: const [LL.violet, LL.cyan],
                            loading: _checking,
                            onPressed: _checking ? null : _redeem,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PerkRow extends StatelessWidget {
  const _PerkRow({required this.perk, required this.highlighted});

  final PremiumPerk perk;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;

    return Container(
      padding: const EdgeInsets.all(LL.s16),
      decoration: BoxDecoration(
        color: highlighted ? c.accent.withValues(alpha: 0.12) : c.glassFill,
        borderRadius: BorderRadius.circular(LL.rMd),
        border: Border.all(
          color: highlighted ? c.accent.withValues(alpha: 0.5) : c.glassStroke,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle_rounded,
              size: 18, color: highlighted ? c.accent : c.success),
          const SizedBox(width: LL.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(perk.label, style: context.type.titleSmall),
                const SizedBox(height: LL.s2),
                Text(perk.detail, style: context.type.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
