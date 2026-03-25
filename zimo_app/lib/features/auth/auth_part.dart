part of '../../app/zimo_app.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = l10n(context);
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
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        _ZimoLogo(),
                        const SizedBox(height: 24),
                        Text(
                          strings.welcomeHeadline,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          strings.welcomeSubtitle,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: const Color(0xFF3C3C3C),
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0E6E6E),
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    const Color(0xFF0E6E6E).withValues(
                                      alpha: 0.20,
                                    ),
                                blurRadius: 24,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                strings.welcomeStartTitle,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                strings.welcomeStartSubtitle,
                                style: const TextStyle(
                                  color: Color(0xFFE4F3F3),
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 22),
                        _FeatureTile(
                          icon: Icons.apartment_rounded,
                          title: strings.welcomeFeaturePropertiesTitle,
                          subtitle: strings.welcomeFeaturePropertiesSubtitle,
                        ),
                        _FeatureTile(
                          icon: Icons.receipt_long_rounded,
                          title: strings.welcomeFeaturePaymentsTitle,
                          subtitle: strings.welcomeFeaturePaymentsSubtitle,
                        ),
                        _FeatureTile(
                          icon: Icons.build_circle_rounded,
                          title: strings.welcomeFeatureMaintenanceTitle,
                          subtitle: strings.welcomeFeatureMaintenanceSubtitle,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  strings.quickAccess,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: const Color(0xFF4F4F4F),
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const RoleSelectScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.arrow_forward_rounded),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(56),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    label: Text(strings.getStarted),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.login_rounded),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(54),
                      backgroundColor: Colors.white.withValues(alpha: 0.75),
                      side: const BorderSide(
                        color: Color(0xFF0E6E6E),
                        width: 1.3,
                      ),
                      textStyle: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    label: Text(strings.alreadyHaveAccount),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RoleSelectScreen extends StatefulWidget {
  const RoleSelectScreen({super.key});

  @override
  State<RoleSelectScreen> createState() => _RoleSelectScreenState();
}

class _RoleSelectScreenState extends State<RoleSelectScreen> {
  UserRole? _selectedRole = UserRole.proprietario;

  @override
  Widget build(BuildContext context) {
    final strings = l10n(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.userTypeTitle),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        strings.roleSelectQuestion,
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        strings.roleSelectSubtitle,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: const Color(0xFF4F4F4F),
                            ),
                      ),
                      const SizedBox(height: 24),
                      _RoleCard(
                        title: strings.ownerRoleTitle,
                        subtitle: strings.ownerRoleSubtitle,
                        icon: Icons.key_rounded,
                        selected: _selectedRole == UserRole.proprietario,
                        onTap: () => setState(() {
                          _selectedRole = UserRole.proprietario;
                        }),
                      ),
                      _RoleCard(
                        title: strings.tenantRoleTitle,
                        subtitle: strings.tenantRoleSubtitle,
                        icon: Icons.person_rounded,
                        selected: _selectedRole == UserRole.inquilino,
                        onTap: () => setState(() {
                          _selectedRole = UserRole.inquilino;
                        }),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => RegisterScreen(
                          role: _selectedRole ?? UserRole.proprietario,
                        ),
                      ),
                    );
                  },
                  child: Text(strings.continueAction),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loading = false;
  bool _showPassword = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = l10n(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.loginTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              strings.welcomeBack,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              strings.loginInstructions,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF4F4F4F),
                  ),
            ),
            const SizedBox(height: 24),
            _TextField(
              label: strings.emailLabel,
              hint: strings.emailHint,
              controller: _emailController,
            ),
            const SizedBox(height: 16),
            _TextField(
              label: strings.passwordLabel,
              hint: strings.passwordHint,
              obscure: !_showPassword,
              controller: _passwordController,
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _showPassword = !_showPassword;
                  });
                },
                icon: Icon(
                  _showPassword
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_rounded,
                ),
                tooltip: _showPassword
                    ? strings.hidePassword
                    : strings.showPassword,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Checkbox(value: true, onChanged: (_) {}),
                Text(strings.rememberMe),
                const Spacer(),
                TextButton(
                  onPressed: () {},
                  child: Text(strings.forgotPassword),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _ZimoLoadingFilledButton(
              loading: _loading,
              label: strings.loginTitle,
              loadingLabel: strings.processing,
              onPressed: () async {
                final messenger = ScaffoldMessenger.of(context);
                final navigator = Navigator.of(context);
                final email = _emailController.text.trim();
                final password = _passwordController.text.trim();
                if (email.isEmpty || password.isEmpty) {
                  messenger.showSnackBar(
                    SnackBar(content: Text(strings.informEmailAndPassword)),
                  );
                  return;
                }
                setState(() {
                  _loading = true;
                });
                UserProfile? user;
                try {
                  user =
                      await BackendService.instance.loginUser(email, password);
                } on AuthException catch (e) {
                  if (!mounted) return;
                  messenger.showSnackBar(
                    SnackBar(content: Text(e.message)),
                  );
                  setState(() {
                    _loading = false;
                  });
                  return;
                } catch (_) {
                  if (!mounted) return;
                  messenger.showSnackBar(
                    SnackBar(content: Text(strings.backendConnectionError)),
                  );
                  setState(() {
                    _loading = false;
                  });
                  return;
                }
                setState(() {
                  _loading = false;
                });
                if (!mounted) return;
                if (user == null) {
                  messenger.showSnackBar(
                    SnackBar(content: Text(strings.accountNotFound)),
                  );
                  return;
                }
                final authenticatedUser = user;
                if (authenticatedUser.role == UserRole.admin) {
                  navigator.push(
                    MaterialPageRoute(
                      builder: (context) => const AdminDashboardScreen(),
                    ),
                  );
                  return;
                }
                navigator.push(
                  MaterialPageRoute(
                    builder: (context) =>
                        DashboardScreen(user: authenticatedUser),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

