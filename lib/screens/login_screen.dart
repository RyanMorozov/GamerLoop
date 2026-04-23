import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gamerloop/app/session_manager.dart';
import 'package:gamerloop/constants/app_colors.dart';
import 'package:gamerloop/screens/register_screen.dart';
import 'package:gamerloop/widgets/background_wrapper.dart';
import 'package:gamerloop/widgets/terms_consent_row.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscure = true;
  bool _rememberMe = true;
  bool _loading = false;
  bool _termsAccepted = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_termsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Devam etmek için kullanım koşullarını onayla.')),
      );
      return;
    }

    if (_loading) return;
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    final UserSession? existingUser = SessionManager.currentUser.value;
    final String fallbackName = _deriveFirstName(_emailController.text);
    await SessionManager.signIn(
      firstName: existingUser?.firstName ?? fallbackName,
      lastName: existingUser?.lastName ?? 'Oyuncu',
    );
    setState(() => _loading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Giriş başarılı.')),
    );
  }

  void _handleRegister() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const RegisterScreen(),
      ),
    );
  }

  String _deriveFirstName(String emailOrUserName) {
    final String raw = emailOrUserName.trim();
    if (raw.isEmpty) return 'Oyuncu';
    final String base = raw.contains('@') ? raw.split('@').first : raw;
    if (base.isEmpty) return 'Oyuncu';
    return base[0].toUpperCase() + base.substring(1);
  }

  InputDecoration _inputDecoration({
    required BuildContext context,
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: Colors.white70),
      suffixIcon: suffixIcon,
      hintStyle: const TextStyle(color: Colors.white54),
      filled: true,
      fillColor: Colors.white.withOpacity(0.06),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.10)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.accent, width: 1.2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWrapper(
        child: Stack(
          children: [
            Positioned(
              top: 30,
              right: -60,
              child: _GlowOrb(
                size: 220,
                color: AppColors.accent.withOpacity(0.22),
              ),
            ),
            Positioned(
              bottom: 60,
              left: -70,
              child: _GlowOrb(
                size: 260,
                color: Colors.cyanAccent.withOpacity(0.16),
              ),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - 40,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text(
                          'Gamer Loop',
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.w900,
                            color: AppColors.accent,
                            letterSpacing: 0.6,
                          ),
                        ),
                        const Spacer(),
                        ValueListenableBuilder<UserSession?>(
                          valueListenable: SessionManager.currentUser,
                          builder: (_, UserSession? user, __) {
                            if (user == null) return const SizedBox.shrink();
                            return TextButton(
                              onPressed: () async {
                                await SessionManager.signOut();
                                if (!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Çıkış yapıldı.')),
                                );
                              },
                              child: const Text(
                                'Çıkış Yap',
                                style: TextStyle(
                                  color: AppColors.accent,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Oyuna bağlan. Ekibinle buluş. Rekabete başla.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                        letterSpacing: 0.25,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _GlassPanel(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 54,
                                width: 54,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF101728),
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                    color: AppColors.accent.withOpacity(0.35),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.sports_esports_rounded,
                                  color: AppColors.accent,
                                  size: 34,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Text(
                                  'Hesabına giriş yap veya yeni bir profil aç.',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 22),
                          const Text(
                            'E-posta / Kullanıcı adı',
                            style: TextStyle(
                              color: AppColors.accent,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _emailController,
                            style: const TextStyle(color: Colors.white),
                            keyboardType: TextInputType.emailAddress,
                            decoration: _inputDecoration(
                              context: context,
                              hint: 'ornek@site.com veya nickname',
                              icon: Icons.alternate_email_rounded,
                            ),
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            'Şifre',
                            style: TextStyle(
                              color: AppColors.accent,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _passwordController,
                            obscureText: _obscure,
                            style: const TextStyle(color: Colors.white),
                            decoration: _inputDecoration(
                              context: context,
                              hint: '••••••••',
                              icon: Icons.lock_outline_rounded,
                              suffixIcon: IconButton(
                                onPressed: () =>
                                    setState(() => _obscure = !_obscure),
                                icon: Icon(
                                  _obscure
                                      ? Icons.visibility_off_rounded
                                      : Icons.visibility_rounded,
                                  color: Colors.white60,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Checkbox(
                                value: _rememberMe,
                                onChanged: (value) => setState(
                                  () => _rememberMe = value ?? true,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              const Text(
                                'Beni hatırla',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const Spacer(),
                              TextButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Şifre sıfırlama yakında.'),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Şifremi unuttum',
                                  style: TextStyle(
                                    color: AppColors.accent,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: _NeoActionButton(
                              text: 'Giriş Yap',
                              isLoading: _loading,
                              onPressed: _handleLogin,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: OutlinedButton(
                              onPressed: _handleRegister,
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: AppColors.accent.withOpacity(0.6),
                                  width: 1.2,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: const Text(
                                'Kayıt Ol',
                                style: TextStyle(
                                  color: AppColors.accent,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TermsConsentRow(
                            accepted: _termsAccepted,
                            onChanged: (bool accepted) {
                              setState(() => _termsAccepted = accepted);
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlassPanel extends StatelessWidget {
  final Widget child;

  const _GlassPanel({required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Colors.white.withOpacity(0.08),
            border: Border.all(color: Colors.white.withOpacity(0.16)),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  final double size;
  final Color color;

  const _GlowOrb({
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color,
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }
}

class _NeoActionButton extends StatefulWidget {
  final String text;
  final Future<void> Function() onPressed;
  final bool isLoading;

  const _NeoActionButton({
    required this.text,
    required this.onPressed,
    required this.isLoading,
  });

  @override
  State<_NeoActionButton> createState() => _NeoActionButtonState();
}

class _NeoActionButtonState extends State<_NeoActionButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.isLoading ? null : (_) => setState(() => _pressed = true),
      onTapCancel: widget.isLoading ? null : () => setState(() => _pressed = false),
      onTapUp: widget.isLoading
          ? null
          : (_) async {
              setState(() => _pressed = false);
              await widget.onPressed();
            },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF00D88E),
              Color(0xFF00B7FF),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: widget.isLoading ? 30 : (_pressed ? 10 : 22),
              spreadRadius: widget.isLoading ? 2 : (_pressed ? 0 : 1),
              offset: const Offset(0, 10),
              color: const Color(0xFF00D88E).withOpacity(
                widget.isLoading ? 0.55 : (_pressed ? 0.25 : 0.42),
              ),
            ),
          ],
        ),
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            child: widget.isLoading
                ? const SizedBox(
                    key: ValueKey('loading'),
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    widget.text,
                    key: const ValueKey('text'),
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
