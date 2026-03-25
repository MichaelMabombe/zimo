part of '../app/zimo_app.dart';

AppLocalizations l10n(BuildContext context) => AppLocalizations.of(context)!;

class ZimoApp extends StatelessWidget {
  const ZimoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => l10n(context).appTitle,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFF0E6E6E),
          onPrimary: Colors.white,
          secondary: Color(0xFFB6452C),
          onSecondary: Colors.white,
          error: Color(0xFFB3261E),
          onError: Colors.white,
          surface: Color(0xFFFFFFFF),
          onSurface: Color(0xFF1F1F1F),
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F4EF),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF5F4EF),
          foregroundColor: Color(0xFF151515),
          elevation: 0,
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            side: const BorderSide(color: Color(0xFF0E6E6E)),
          ),
        ),
      ),
      home: const BrandSplashScreen(),
    );
  }
}

class BrandSplashScreen extends StatefulWidget {
  const BrandSplashScreen({super.key});

  @override
  State<BrandSplashScreen> createState() => _BrandSplashScreenState();
}

class _BrandSplashScreenState extends State<BrandSplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) {
        return;
      }
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF5F4EF), Color(0xFFE5F0EC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _ZimoLogo(),
                const SizedBox(height: 14),
                Text(
                  l10n(context).poweredByCetus,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: const Color(0xFF4F4F4F),
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: 8),
                Image.asset(
                  'assets/logo/cetus.png',
                  height: 28,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String roleLabel(BuildContext context, UserRole role) {
  final strings = l10n(context);
  switch (role) {
    case UserRole.admin:
      return strings.roleAdmin;
    case UserRole.inquilino:
      return strings.roleTenant;
    case UserRole.proprietario:
      return strings.roleOwner;
  }
}

Future<void> _confirmLogout(BuildContext context) async {
  final strings = l10n(context);
  final shouldLogout = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text(strings.logoutTitle),
        content: Text(strings.logoutMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(strings.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(strings.logout),
          ),
        ],
      );
    },
  );

  if (shouldLogout != true || !context.mounted) {
    return;
  }

  ZimoStore.instance.logout();
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (context) => const WelcomeScreen()),
    (route) => false,
  );
}

class _LogoutAppBarAction extends StatelessWidget {
  const _LogoutAppBarAction();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: l10n(context).logout,
      onPressed: () => _confirmLogout(context),
      icon: const Icon(Icons.logout_rounded),
    );
  }
}

class _ZimoLoadingFilledButton extends StatelessWidget {
  const _ZimoLoadingFilledButton({
    required this.onPressed,
    required this.loading,
    required this.label,
    required this.loadingLabel,
  });

  final VoidCallback? onPressed;
  final bool loading;
  final String label;
  final String loadingLabel;

  @override
  Widget build(BuildContext context) {
    final button = FilledButton(
      onPressed: loading ? null : onPressed,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 220),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        child: loading
            ? Row(
                key: const ValueKey('loading'),
                mainAxisSize: MainAxisSize.min,
                children: [
                  const _ZimoProcessingDots(),
                  const SizedBox(width: 10),
                  Text(loadingLabel),
                ],
              )
            : Text(
                label,
                key: const ValueKey('idle'),
              ),
      ),
    );

    return SizedBox(
      width: double.infinity,
      child: button,
    );
  }
}

class _ZimoProcessingDots extends StatefulWidget {
  const _ZimoProcessingDots();

  @override
  State<_ZimoProcessingDots> createState() => _ZimoProcessingDotsState();
}

class _ZimoProcessingDotsState extends State<_ZimoProcessingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final progress = _controller.value;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            final wave = (progress * 3 - index).abs();
            final t = (1 - wave).clamp(0.0, 1.0);
            final size = 6.0 + (3.0 * t);
            final color = Color.lerp(
              const Color(0xFFE5F0EC),
              index.isEven ? const Color(0xFF0E6E6E) : const Color(0xFFB6452C),
              t,
            );
            return Container(
              width: size,
              height: size,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            );
          }),
        );
      },
    );
  }
}


