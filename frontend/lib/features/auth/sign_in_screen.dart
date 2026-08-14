import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learning_app/core/theme/tokens.dart';
import 'package:learning_app/core/widgets/aurora_background.dart';
import 'package:learning_app/core/widgets/glass.dart';
import 'package:learning_app/core/widgets/motion.dart';
import 'package:learning_app/core/widgets/pressable.dart';
import 'package:learning_app/features/language/language_picker_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  bool _createAccount = false;
  bool _obscure = true;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  /// Maps Firebase's error codes onto messages that say what to do next.
  String _messageFor(FirebaseAuthException error) => switch (error.code) {
        'invalid-email' => 'Cette adresse email n\'est pas valide.',
        'user-not-found' ||
        'wrong-password' ||
        'invalid-credential' =>
          'Email ou mot de passe incorrect. Verifie les deux, ou cree un compte.',
        'email-already-in-use' =>
          'Un compte existe deja avec cet email. Passe en mode connexion.',
        'weak-password' =>
          'Mot de passe trop court : il faut au moins 6 caracteres.',
        'network-request-failed' =>
          'Pas de connexion. La progression reste enregistree localement.',
        'too-many-requests' =>
          'Trop de tentatives. Reessaie dans quelques minutes.',
        _ => error.message ?? 'Connexion impossible pour le moment.',
      };

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text;
      if (_createAccount) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      }
      if (mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    } on FirebaseAuthException catch (error) {
      if (mounted) setState(() => _error = _messageFor(error));
    } catch (_) {
      if (mounted) {
        setState(() => _error = 'Connexion impossible pour le moment.');
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.ll;

    return Scaffold(
      body: AuroraBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(LL.s24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Reveal(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Floating(
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            gradient:
                                LinearGradient(colors: [c.accent, c.accentAlt]),
                            borderRadius: BorderRadius.circular(LL.rMd),
                          ),
                          child: const Icon(Icons.graphic_eq_rounded,
                              color: Colors.white, size: 30),
                        ),
                      ),
                      const SizedBox(height: LL.s24),
                      Text('LinguaLab', style: context.type.displayMedium),
                      const SizedBox(height: LL.s8),
                      Text(
                        'Des phrases entieres, programmees pour revenir juste '
                        'avant que tu les oublies.',
                        style: context.type.bodyLarge,
                      ),
                      const SizedBox(height: LL.s32),
                      GlassCard(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              TextFormField(
                                controller: _emailController,
                                focusNode: _emailFocus,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                autofillHints: const [AutofillHints.email],
                                decoration: const InputDecoration(
                                  labelText: 'Email',
                                  prefixIcon: Icon(Icons.mail_outline_rounded),
                                ),
                                onFieldSubmitted: (_) =>
                                    _passwordFocus.requestFocus(),
                                validator: (value) {
                                  final text = value?.trim() ?? '';
                                  if (text.isEmpty) return 'Email requis';
                                  if (!text.contains('@') ||
                                      !text.contains('.')) {
                                    return 'Adresse email incomplete';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: LL.s16),
                              TextFormField(
                                controller: _passwordController,
                                focusNode: _passwordFocus,
                                obscureText: _obscure,
                                textInputAction: TextInputAction.done,
                                autofillHints: [
                                  _createAccount
                                      ? AutofillHints.newPassword
                                      : AutofillHints.password,
                                ],
                                decoration: InputDecoration(
                                  labelText: 'Mot de passe',
                                  helperText: _createAccount
                                      ? 'Au moins 6 caracteres'
                                      : null,
                                  prefixIcon:
                                      const Icon(Icons.lock_outline_rounded),
                                  suffixIcon: IconButton(
                                    onPressed: () =>
                                        setState(() => _obscure = !_obscure),
                                    icon: Icon(_obscure
                                        ? Icons.visibility_rounded
                                        : Icons.visibility_off_rounded),
                                    tooltip: _obscure
                                        ? 'Afficher le mot de passe'
                                        : 'Masquer le mot de passe',
                                  ),
                                ),
                                onFieldSubmitted: (_) => _submit(),
                                validator: (value) {
                                  final text = value ?? '';
                                  if (text.isEmpty) {
                                    return 'Mot de passe requis';
                                  }
                                  if (_createAccount && text.length < 6) {
                                    return 'Au moins 6 caracteres';
                                  }
                                  return null;
                                },
                              ),
                              if (_error != null) ...[
                                const SizedBox(height: LL.s16),
                                _ErrorBanner(message: _error!),
                              ],
                              const SizedBox(height: LL.s24),
                              GradientButton(
                                label: _createAccount
                                    ? 'Creer mon compte'
                                    : 'Se connecter',
                                loading: _loading,
                                onPressed: _loading ? null : _submit,
                              ),
                              const SizedBox(height: LL.s8),
                              TextButton(
                                onPressed: _loading
                                    ? null
                                    : () => setState(() {
                                          _createAccount = !_createAccount;
                                          _error = null;
                                        }),
                                child: Text(
                                  _createAccount
                                      ? 'J\'ai deja un compte'
                                      : 'Creer un compte',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: LL.s20),
                      TextButton.icon(
                        onPressed: _loading
                            ? null
                            : () {
                                if (Navigator.of(context).canPop()) {
                                  Navigator.of(context).pop();
                                } else {
                                  // Continuing without an account is a first
                                  // class path, not a hidden escape hatch:
                                  // progress is kept locally either way.
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute<void>(
                                      builder: (_) =>
                                          const LanguagePickerScreen(),
                                    ),
                                  );
                                }
                              },
                        icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                        label: const Text('Continuer sans compte'),
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

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final c = context.ll;
    return Semantics(
      liveRegion: true,
      child: Container(
        padding: const EdgeInsets.all(LL.s12),
        decoration: BoxDecoration(
          color: c.danger.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(LL.rSm),
          border: Border.all(color: c.danger.withValues(alpha: 0.4)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.error_outline_rounded, size: 18, color: c.danger),
            const SizedBox(width: LL.s8),
            Expanded(
              child: Text(
                message,
                style: context.type.bodyMedium?.copyWith(color: c.danger),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
