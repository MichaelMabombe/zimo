import 'dart:async';
import 'dart:convert';
import 'dart:io' show File;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const ZimoApp());
}

class ZimoApp extends StatelessWidget {
  const ZimoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ZIMO',
      debugShowCheckedModeBanner: false,
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
          background: Color(0xFFF5F4EF),
          onBackground: Color(0xFF151515),
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
                  'Powered by Cetus Technologys',
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

enum UserRole { admin, proprietario, inquilino }

UserRole userRoleFromApi(String value) {
  switch (value) {
    case 'admin':
      return UserRole.admin;
    case 'inquilino':
      return UserRole.inquilino;
    default:
      return UserRole.proprietario;
  }
}

String userRoleToApi(UserRole role) {
  switch (role) {
    case UserRole.admin:
      return 'admin';
    case UserRole.inquilino:
      return 'inquilino';
    case UserRole.proprietario:
      return 'proprietario';
  }
}

String roleLabel(UserRole role) {
  switch (role) {
    case UserRole.admin:
      return 'Admin';
    case UserRole.inquilino:
      return 'Inquilino';
    case UserRole.proprietario:
      return 'Proprietario';
  }
}

class UserProfile {
  UserProfile({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.email,
    required this.password,
    required this.document,
    required this.role,
    this.avatarPath,
  });

  final String id;
  final String name;
  final String address;
  final String phone;
  final String email;
  final String password;
  final String document;
  final UserRole role;
  final String? avatarPath;

  factory UserProfile.fromApi(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      password: '',
      document: json['document']?.toString() ?? '',
      role: userRoleFromApi(json['role']?.toString() ?? 'proprietario'),
      avatarPath: json['avatar_path']?.toString(),
    );
  }

  UserProfile copyWith({
    String? id,
    String? name,
    String? address,
    String? phone,
    String? email,
    String? password,
    String? document,
    UserRole? role,
    String? avatarPath,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      password: password ?? this.password,
      document: document ?? this.document,
      role: role ?? this.role,
      avatarPath: avatarPath ?? this.avatarPath,
    );
  }
}

class ZimoStore extends ChangeNotifier {
  ZimoStore._();

  static final ZimoStore instance = ZimoStore._();

  final List<UserProfile> _users = [];
  UserProfile? _currentUser;

  List<UserProfile> get users => List.unmodifiable(_users);
  UserProfile? get currentUser => _currentUser;

  void setCurrentUser(UserProfile user) {
    _currentUser = user;
    notifyListeners();
  }

  void addUser(UserProfile user) {
    _users.add(user);
    _currentUser = user;
    notifyListeners();
  }

  void setUsers(List<UserProfile> users) {
    _users
      ..clear()
      ..addAll(users);
    notifyListeners();
  }

  void updateCurrentUser(UserProfile user) {
    _currentUser = user;
    final index = _users.indexWhere((item) => item.id == user.id);
    if (index >= 0) {
      _users[index] = user;
    }
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}

class AuthException implements Exception {
  AuthException(this.message);

  final String message;
}

Future<void> _confirmLogout(BuildContext context) async {
  final shouldLogout = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('Terminar sessao'),
        content: const Text('Deseja realmente fazer log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Log out'),
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
      tooltip: 'Log out',
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

class BackendService {
  BackendService._();

  static final BackendService instance = BackendService._();
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8080',
  );
  static const Duration _requestTimeout = Duration(seconds: 12);

  Future<void> registerUser(UserProfile profile) async {
    await Future.delayed(const Duration(milliseconds: 400));
    ZimoStore.instance.addUser(profile);
  }

  Future<UserProfile?> loginUser(String email, String password) async {
    final uri = Uri.parse('$baseUrl/api/login.php');
    try {
      final response = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'email': email,
              'password': password,
            }),
          )
          .timeout(_requestTimeout);

      final Map<String, dynamic> json =
          jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200 || json['ok'] != true) {
        throw AuthException(
          json['message']?.toString() ?? 'Falha ao autenticar no backend.',
        );
      }

      final user = UserProfile.fromApi(json['user'] as Map<String, dynamic>);
      ZimoStore.instance.setCurrentUser(user);
      return user;
    } on TimeoutException {
      throw AuthException(
        'O servidor demorou para responder. Verifique a ligacao e tente novamente.',
      );
    } on AuthException {
      rethrow;
    } catch (_) {
      throw AuthException(
        'Nao foi possivel conectar ao backend. Confirme se o servidor esta ativo.',
      );
    }
  }

  Future<List<UserProfile>> fetchUsers() async {
    final uri = Uri.parse('$baseUrl/api/users.php');
    try {
      final response = await http.get(uri).timeout(_requestTimeout);
      final Map<String, dynamic> json =
          jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200 || json['ok'] != true) {
        throw AuthException(
          json['message']?.toString() ?? 'Falha ao carregar usuarios.',
        );
      }

      final rawUsers = (json['users'] as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .map(UserProfile.fromApi)
          .toList();

      ZimoStore.instance.setUsers(rawUsers);
      return rawUsers;
    } on TimeoutException {
      throw AuthException(
        'O servidor demorou para responder. Tente novamente em instantes.',
      );
    } on AuthException {
      rethrow;
    } catch (_) {
      throw AuthException(
        'Nao foi possivel carregar os usuarios. Verifique o backend.',
      );
    }
  }

  Future<List<_OwnerProperty>> _fetchOwnerProperties(String ownerId) async {
    final uri = Uri.parse('$baseUrl/api/properties.php?owner_id=$ownerId');
    try {
      final response = await http.get(uri).timeout(_requestTimeout);
      final Map<String, dynamic> json =
          jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200 || json['ok'] != true) {
        throw AuthException(
          json['message']?.toString() ?? 'Falha ao carregar imoveis.',
        );
      }

      final rows = (json['properties'] as List<dynamic>? ?? [])
          .cast<Map<String, dynamic>>();
      return rows.map(_OwnerProperty.fromApi).toList();
    } on TimeoutException {
      throw AuthException(
        'O servidor demorou para responder. Tente novamente em instantes.',
      );
    } on AuthException {
      rethrow;
    } catch (_) {
      throw AuthException(
        'Nao foi possivel carregar os imoveis. Verifique o backend.',
      );
    }
  }

  Future<List<_OwnerProperty>> _fetchAvailableProperties({
    String? type,
    String? location,
    double? maxPrice,
  }) async {
    final query = <String, String>{};
    if (type != null && type.trim().isNotEmpty && type != 'Todos') {
      query['type'] = type.trim();
    }
    if (location != null && location.trim().isNotEmpty) {
      query['location'] = location.trim();
    }
    if (maxPrice != null && maxPrice > 0) {
      query['max_price'] = maxPrice.toStringAsFixed(0);
    }

    final uri = Uri.parse('$baseUrl/api/properties.php')
        .replace(queryParameters: query);
    try {
      final response = await http.get(uri).timeout(_requestTimeout);
      final Map<String, dynamic> json =
          jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode != 200 || json['ok'] != true) {
        throw AuthException(
          json['message']?.toString() ?? 'Falha ao carregar imoveis.',
        );
      }
      final rows = (json['properties'] as List<dynamic>? ?? [])
          .cast<Map<String, dynamic>>();
      return rows.map(_OwnerProperty.fromApi).toList();
    } on TimeoutException {
      throw AuthException(
        'O servidor demorou para responder. Tente novamente em instantes.',
      );
    } on AuthException {
      rethrow;
    } catch (_) {
      throw AuthException(
        'Nao foi possivel carregar os imoveis disponiveis.',
      );
    }
  }

  Future<_OwnerProperty> _createProperty({
    required String ownerId,
    required String name,
    required String propertyType,
    required int bedrooms,
    required String address,
    required String rent,
    required String description,
    required List<XFile> photos,
  }) async {
    final uri = Uri.parse('$baseUrl/api/properties.php');
    try {
      final request = http.MultipartRequest('POST', uri)
        ..fields['owner_id'] = ownerId
        ..fields['name'] = name
        ..fields['property_type'] = propertyType
        ..fields['bedrooms'] = bedrooms.toString()
        ..fields['address'] = address
        ..fields['rent'] = rent
        ..fields['description'] = description;

      for (final photo in photos) {
        request.files.add(
          await http.MultipartFile.fromPath('photos[]', photo.path),
        );
      }

      final streamed = await request.send().timeout(_requestTimeout);
      final response = await http.Response.fromStream(streamed);
      final Map<String, dynamic> json =
          jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 201 || json['ok'] != true) {
        throw AuthException(
          json['message']?.toString() ?? 'Falha ao cadastrar imovel.',
        );
      }

      return _OwnerProperty.fromApi(json['property'] as Map<String, dynamic>);
    } on TimeoutException {
      throw AuthException(
        'O servidor demorou para responder. Tente novamente em instantes.',
      );
    } on AuthException {
      rethrow;
    } catch (_) {
      throw AuthException(
        'Nao foi possivel salvar o imovel. Verifique o backend.',
      );
    }
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

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
                          'Alugue sem intermediarios e encontre seu proximo lar mais rapido.',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'A ZIMO conecta proprietarios e inquilinos em um processo simples, direto e seguro.',
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
                                    const Color(0xFF0E6E6E).withOpacity(0.20),
                                blurRadius: 24,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Comece em menos de 2 minutos',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Escolha seu perfil e acesse as funcoes principais rapidamente.',
                                style: TextStyle(
                                  color: Color(0xFFE4F3F3),
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 22),
                        const _FeatureTile(
                          icon: Icons.apartment_rounded,
                          title: 'Imoveis sob controle',
                          subtitle: 'Status, renda, fotos e documentos.',
                        ),
                        const _FeatureTile(
                          icon: Icons.receipt_long_rounded,
                          title: 'Pagamentos claros',
                          subtitle: 'Alertas de atraso e historico completo.',
                        ),
                        const _FeatureTile(
                          icon: Icons.build_circle_rounded,
                          title: 'Manutencao organizada',
                          subtitle: 'Pedidos, aprovacoes e tecnicos.',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Acesso rapido',
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
                    label: const Text('Comecar'),
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
                      backgroundColor: Colors.white.withOpacity(0.75),
                      side: const BorderSide(
                        color: Color(0xFF0E6E6E),
                        width: 1.3,
                      ),
                      textStyle: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    label: const Text('Ja tenho conta'),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tipo de usuario'),
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
                        'Como voce vai usar a ZIMO?',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Isso ajuda a personalizar o dashboard e as permissoes.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: const Color(0xFF4F4F4F),
                            ),
                      ),
                      const SizedBox(height: 24),
                      _RoleCard(
                        title: 'Proprietario',
                        subtitle: 'Gerencie imoveis, contratos e rendas.',
                        icon: Icons.key_rounded,
                        selected: _selectedRole == UserRole.proprietario,
                        onTap: () => setState(() {
                          _selectedRole = UserRole.proprietario;
                        }),
                      ),
                      _RoleCard(
                        title: 'Inquilino',
                        subtitle:
                            'Pagamentos, contrato e pedidos de manutencao.',
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
                  child: const Text('Continuar'),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entrar'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bem-vindo de volta',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Use seu email e senha para continuar.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF4F4F4F),
                  ),
            ),
            const SizedBox(height: 24),
            _TextField(
              label: 'Email',
              hint: 'exemplo@zimo.co.mz',
              controller: _emailController,
            ),
            const SizedBox(height: 16),
            _TextField(
              label: 'Senha',
              hint: '********',
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
                tooltip: _showPassword ? 'Ocultar senha' : 'Ver senha',
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Checkbox(value: true, onChanged: (_) {}),
                const Text('Lembrar-me'),
                const Spacer(),
                TextButton(
                  onPressed: () {},
                  child: const Text('Esqueci a senha'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _ZimoLoadingFilledButton(
              loading: _loading,
              label: 'Entrar',
              loadingLabel: 'A processar...',
              onPressed: () async {
                final email = _emailController.text.trim();
                final password = _passwordController.text.trim();
                if (email.isEmpty || password.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Informe email e senha.'),
                    ),
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(e.message)),
                  );
                  setState(() {
                    _loading = false;
                  });
                  return;
                } catch (_) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Erro ao conectar com o backend.'),
                    ),
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Conta nao encontrada.'),
                    ),
                  );
                  return;
                }
                final authenticatedUser = user!;
                if (authenticatedUser.role == UserRole.admin) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AdminDashboardScreen(),
                    ),
                  );
                  return;
                }
                Navigator.of(context).push(
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

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key, required this.user});

  final UserProfile user;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedTab = 0;
  late UserProfile _user;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
  }

  Future<void> _openSettings() async {
    final updated = await Navigator.of(context).push<UserProfile>(
      MaterialPageRoute(
        builder: (context) => _ProfileSettingsScreen(user: _user),
      ),
    );
    if (updated == null) {
      return;
    }
    setState(() {
      _user = updated;
    });
    ZimoStore.instance.updateCurrentUser(updated);
  }

  Future<void> _openChat() async {
    final isProprietario = _user.role == UserRole.proprietario;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _SupportChatScreen(
          title: isProprietario
              ? 'Chat de suporte do proprietario'
              : 'Chat de suporte do inquilino',
          currentUserName: _user.name,
          seedMessages: isProprietario
              ? _ownerSupportSeedMessages
              : _tenantSupportSeedMessages,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = _user;
    final isProprietario = user.role == UserRole.proprietario;
    final isInquilino = user.role == UserRole.inquilino;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard ZIMO'),
        actions: [
          IconButton(
            tooltip: 'Chat',
            onPressed: _openChat,
            icon: const Icon(Icons.forum_rounded),
          ),
          const _LogoutAppBarAction(),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: _openSettings,
              child: CircleAvatar(
                radius: 17,
                backgroundColor: const Color(0xFF0E6E6E),
                backgroundImage: user.avatarPath == null
                    ? null
                    : FileImage(File(user.avatarPath!)),
                child: user.avatarPath == null
                    ? Text(
                        _initialsFromName(user.name),
                        style: const TextStyle(color: Colors.white),
                      )
                    : null,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: isProprietario
              ? _OwnerDashboardContent(
                  selectedTab: _selectedTab,
                  ownerId: user.id,
                  onOpenPropertyForm: () async {
                    final created =
                        await Navigator.of(context).push<_OwnerProperty>(
                      MaterialPageRoute(
                        builder: (context) => PropertyFormScreen(owner: user),
                      ),
                    );
                    if (created == null) {
                      return;
                    }
                    setState(() {
                      _ownerProperties.insert(0, created);
                      _selectedTab = 1;
                    });
                  },
                )
              : _TenantDashboardContent(
                  selectedTab: _selectedTab,
                  tenant: user,
                ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedTab,
        onDestinationSelected: (index) {
          setState(() {
            _selectedTab = index;
          });
        },
        destinations: isProprietario
            ? const [
                NavigationDestination(
                    icon: Icon(Icons.grid_view_rounded), label: 'Home'),
                NavigationDestination(
                    icon: Icon(Icons.apartment_rounded), label: 'imoveis'),
                NavigationDestination(
                    icon: Icon(Icons.receipt_long_rounded),
                    label: 'Pagamentos'),
                NavigationDestination(
                    icon: Icon(Icons.build_rounded), label: 'Manutencao'),
              ]
            : isInquilino
                ? const [
                    NavigationDestination(
                        icon: Icon(Icons.travel_explore_rounded),
                        label: 'Explorar'),
                    NavigationDestination(
                        icon: Icon(Icons.bookmark_rounded), label: 'imoveis'),
                    NavigationDestination(
                        icon: Icon(Icons.account_balance_wallet_rounded),
                        label: 'Pagamentos'),
                    NavigationDestination(
                        icon: Icon(Icons.build_rounded), label: 'Manutencao'),
                  ]
                : const [
                    NavigationDestination(
                        icon: Icon(Icons.grid_view_rounded), label: 'Home'),
                    NavigationDestination(
                        icon: Icon(Icons.apartment_rounded), label: 'imoveis'),
                    NavigationDestination(
                        icon: Icon(Icons.receipt_long_rounded),
                        label: 'Pagamentos'),
                    NavigationDestination(
                        icon: Icon(Icons.build_rounded), label: 'Manutencao'),
                  ],
      ),
    );
  }
}

String _initialsFromName(String name) {
  final parts = name
      .trim()
      .split(RegExp(r'\s+'))
      .where((part) => part.isNotEmpty)
      .toList(growable: false);
  if (parts.isEmpty) {
    return 'ZM';
  }
  if (parts.length == 1) {
    return parts.first.substring(0, 1).toUpperCase();
  }
  return '${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}'
      .toUpperCase();
}

Widget _propertyImageFallback() {
  return Container(
    height: 150,
    width: double.infinity,
    color: const Color(0xFFE6EFEE),
    alignment: Alignment.center,
    child: const Icon(
      Icons.image_not_supported_outlined,
      color: Color(0xFF0E6E6E),
      size: 36,
    ),
  );
}

class _EmptyHintCard extends StatelessWidget {
  const _EmptyHintCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFDCE6E6)),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF4F4F4F),
            ),
      ),
    );
  }
}

enum _PaymentFilterType { day, month }

class _TenantDashboardContent extends StatelessWidget {
  const _TenantDashboardContent({
    required this.selectedTab,
    required this.tenant,
  });

  final int selectedTab;
  final UserProfile tenant;

  @override
  Widget build(BuildContext context) {
    switch (selectedTab) {
      case 1:
        return _TenantReservedPropertiesTab(tenantId: tenant.id);
      case 2:
        return _TenantPaymentsTab(tenantId: tenant.id);
      case 3:
        return _TenantMaintenanceTab(tenant: tenant);
      default:
        return _TenantExploreTab(tenant: tenant);
    }
  }
}

class _TenantExploreTab extends StatefulWidget {
  const _TenantExploreTab({required this.tenant});

  final UserProfile tenant;

  @override
  State<_TenantExploreTab> createState() => _TenantExploreTabState();
}

class _TenantExploreTabState extends State<_TenantExploreTab> {
  final TextEditingController _searchController = TextEditingController();
  bool _loading = true;
  String? _error;
  List<_OwnerProperty> _properties = const [];
  String _selectedType = 'Todos';
  String _locationFilter = '';
  double _maxPriceFilter = 150000;

  @override
  void initState() {
    super.initState();
    _loadProperties();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadProperties() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final items = await BackendService.instance._fetchAvailableProperties(
        type: _selectedType,
        location: _locationFilter,
        maxPrice: _maxPriceFilter,
      );
      if (!mounted) {
        return;
      }
      setState(() {
        _properties = items;
        _loading = false;
      });
    } on AuthException catch (e) {
      if (!mounted) {
        return;
      }
      setState(() {
        _loading = false;
        _error = e.message;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _loading = false;
        _error = 'Falha ao carregar imoveis.';
      });
    }
  }

  Future<void> _openFilterSheet() async {
    final locationController = TextEditingController(text: _locationFilter);
    String tempType = _selectedType;
    double tempPrice = _maxPriceFilter;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Filtrar imoveis',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 12),
                  _DropdownField(
                    label: 'Tipo',
                    items: const [
                      'Todos',
                      'Casa familiar',
                      'Casa de praia',
                      'Apartamento',
                      'Vivenda',
                      'Studio',
                      'Loja',
                      'Escritorio',
                      'Terreno',
                    ],
                    value: tempType,
                    onChanged: (value) {
                      if (value == null) return;
                      setModalState(() {
                        tempType = value;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  _TextField(
                    label: 'Localizacao',
                    hint: 'Cidade ou bairro',
                    controller: locationController,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Preco maximo: ${tempPrice.toStringAsFixed(0)} MT',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  Slider(
                    min: 10000,
                    max: 250000,
                    divisions: 24,
                    value: tempPrice,
                    onChanged: (value) {
                      setModalState(() {
                        tempPrice = value;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  _ZimoLoadingFilledButton(
                    onPressed: () {
                      setState(() {
                        _selectedType = tempType;
                        _locationFilter = locationController.text.trim();
                        _maxPriceFilter = tempPrice;
                      });
                      Navigator.of(context).pop();
                      _loadProperties();
                    },
                    loading: false,
                    label: 'Aplicar filtro',
                    loadingLabel: 'A processar...',
                  ),
                ],
              ),
            );
          },
        );
      },
    );
    locationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.trim().toLowerCase();
    final filtered = _properties.where((property) {
      if (query.isEmpty) {
        return true;
      }
      return property.name.toLowerCase().contains(query) ||
          property.propertyType.toLowerCase().contains(query) ||
          property.address.toLowerCase().contains(query);
    }).toList(growable: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Imoveis disponiveis',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 6),
        Text(
          'Pesquise, filtre e avalie imoveis para arrendar sem intermediarios.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF4F4F4F),
              ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Pesquisar imovel',
                  prefixIcon: const Icon(Icons.search_rounded),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filledTonal(
              onPressed: _openFilterSheet,
              icon: const Icon(Icons.filter_alt_rounded),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (_loading) ...[
          const LinearProgressIndicator(minHeight: 3),
          const SizedBox(height: 12),
        ],
        if (_error != null) ...[
          Text(
            _error!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: const Color(0xFFB3261E),
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 12),
        ],
        Text(
          '${filtered.length} imovel(is) encontrado(s)',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: const Color(0xFF4F4F4F),
              ),
        ),
        const SizedBox(height: 10),
        ...filtered.map(
          (property) => _TenantExplorePropertyCard(
            property: property,
            onTap: () async {
              final reserved = await Navigator.of(context).push<bool>(
                MaterialPageRoute(
                  builder: (context) => _TenantPropertyDetailsScreen(
                    tenant: widget.tenant,
                    property: property,
                  ),
                ),
              );
              if (reserved == true && mounted) {
                setState(() {});
              }
            },
          ),
        ),
      ],
    );
  }
}

class _TenantExplorePropertyCard extends StatelessWidget {
  const _TenantExplorePropertyCard({
    required this.property,
    required this.onTap,
  });

  final _OwnerProperty property;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final photoUrl = property.photos.isNotEmpty ? property.photos.first : null;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (photoUrl != null)
              Image.network(
                photoUrl,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _propertyImageFallback(),
              )
            else
              _propertyImageFallback(),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${property.propertyType} - ${property.bedrooms} quarto(s)',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: const Color(0xFF4F4F4F),
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Estado: ${property.status}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: _ownerPropertyStatusColor(property.status),
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    property.address,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: const Color(0xFF4F4F4F),
                        ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        property.rent,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF0E6E6E),
                            ),
                      ),
                      const Spacer(),
                      const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TenantPropertyDetailsScreen extends StatefulWidget {
  const _TenantPropertyDetailsScreen({
    required this.tenant,
    required this.property,
  });

  final UserProfile tenant;
  final _OwnerProperty property;

  @override
  State<_TenantPropertyDetailsScreen> createState() =>
      _TenantPropertyDetailsScreenState();
}

class _TenantPropertyDetailsScreenState
    extends State<_TenantPropertyDetailsScreen> {
  double _rating = 4.0;
  bool _loading = false;
  String _paymentMethod = 'eMola';

  Future<void> _reserveAndPay() async {
    if (widget.property.status.toLowerCase() != 'disponivel') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Este imovel nao esta disponivel agora.')),
      );
      return;
    }
    setState(() {
      _loading = true;
    });
    await Future.delayed(const Duration(milliseconds: 900));
    _reservePropertyWithPayment(
      tenantId: widget.tenant.id,
      tenantName: widget.tenant.name,
      property: widget.property,
      paymentMethod: _paymentMethod,
    );
    if (!mounted) {
      return;
    }
    setState(() {
      _loading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text('Reserva e pagamento iniciados via $_paymentMethod.')),
    );
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final property = widget.property;
    return Scaffold(
      appBar: AppBar(title: Text(property.name)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          SizedBox(
            height: 180,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: property.photos.isEmpty ? 1 : property.photos.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                if (property.photos.isEmpty) {
                  return SizedBox(width: 260, child: _propertyImageFallback());
                }
                return ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.network(
                    property.photos[index],
                    width: 260,
                    height: 180,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _propertyImageFallback(),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 14),
          Text(
            '${property.propertyType} - ${property.bedrooms} quarto(s)',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            property.address,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF4F4F4F),
                ),
          ),
          const SizedBox(height: 10),
          Text(
            'Renda mensal: ${property.rent}',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: const Color(0xFF0E6E6E),
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 18),
          Text(
            'Estado atual: ${property.status}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: _ownerPropertyStatusColor(property.status),
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 12),
          Text(
            'Avalie este imovel',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          Slider(
            value: _rating,
            min: 1,
            max: 5,
            divisions: 8,
            label: _rating.toStringAsFixed(1),
            onChanged: (value) {
              setState(() {
                _rating = value;
              });
            },
          ),
          const SizedBox(height: 8),
          Text(
            'Metodo de pagamento',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          _PaymentMethodTile(
            title: 'eMola',
            logoLabel: 'eM',
            selected: _paymentMethod == 'eMola',
            onTap: () => setState(() => _paymentMethod = 'eMola'),
          ),
          _PaymentMethodTile(
            title: 'mPesa',
            logoLabel: 'mP',
            selected: _paymentMethod == 'mPesa',
            onTap: () => setState(() => _paymentMethod = 'mPesa'),
          ),
          _PaymentMethodTile(
            title: 'Banco (transferencia)',
            logoLabel: 'BK',
            selected: _paymentMethod == 'Banco',
            onTap: () => setState(() => _paymentMethod = 'Banco'),
          ),
          const SizedBox(height: 16),
          _ZimoLoadingFilledButton(
            onPressed: property.status.toLowerCase() == 'disponivel'
                ? _reserveAndPay
                : null,
            loading: _loading,
            label: 'Reservar e pagar',
            loadingLabel: 'A processar...',
          ),
        ],
      ),
    );
  }
}

class _PaymentMethodTile extends StatelessWidget {
  const _PaymentMethodTile({
    required this.title,
    required this.logoLabel,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String logoLabel;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFE5F0EC) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  selected ? const Color(0xFF0E6E6E) : const Color(0xFFD9E3E3),
            ),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 15,
                backgroundColor: const Color(0xFF0E6E6E),
                child: Text(
                  logoLabel,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(child: Text(title)),
              Icon(
                selected ? Icons.check_circle_rounded : Icons.circle_outlined,
                color: selected
                    ? const Color(0xFF0E6E6E)
                    : const Color(0xFF808080),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TenantReservedPropertiesTab extends StatelessWidget {
  const _TenantReservedPropertiesTab({required this.tenantId});

  final String tenantId;

  @override
  Widget build(BuildContext context) {
    final reservations = _tenantReservations
        .where((item) => item.tenantId == tenantId)
        .toList(growable: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Meus imoveis reservados',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 6),
        Text(
          'Imoveis que voce reservou para arrendamento.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF4F4F4F),
              ),
        ),
        const SizedBox(height: 12),
        if (reservations.isEmpty)
          const _EmptyHintCard(
            text: 'Ainda nao existem reservas para este inquilino.',
          ),
        ...reservations.map(
          (item) => _PropertyCard(
            title: '${item.propertyName} (${item.propertyType})',
            subtitle:
                '${item.address} - ${item.bedrooms} quarto(s) - ${item.status}',
            statusColor: _ownerPropertyStatusColor(item.status),
            rent: item.rentLabel,
          ),
        ),
      ],
    );
  }
}

class _TenantPaymentsTab extends StatefulWidget {
  const _TenantPaymentsTab({required this.tenantId});

  final String tenantId;

  @override
  State<_TenantPaymentsTab> createState() => _TenantPaymentsTabState();
}

class _TenantPaymentsTabState extends State<_TenantPaymentsTab> {
  final TextEditingController _searchController = TextEditingController();
  _PaymentFilterType _filterType = _PaymentFilterType.month;
  String _selectedPeriod = 'Todos';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final payments = _tenantPayments
        .where((item) => item.tenantId == widget.tenantId)
        .toList(growable: false);
    final periods = _buildPaymentPeriods(payments, _filterType);
    final query = _searchController.text.trim().toLowerCase();
    final filtered = payments.where((item) {
      final passQuery = query.isEmpty ||
          item.propertyName.toLowerCase().contains(query) ||
          item.paymentMethod.toLowerCase().contains(query) ||
          item.referenceCode.toLowerCase().contains(query);
      if (!passQuery) {
        return false;
      }
      if (_selectedPeriod == 'Todos') {
        return true;
      }
      return _filterType == _PaymentFilterType.day
          ? _paymentDayLabel(item.createdAt) == _selectedPeriod
          : _paymentMonthLabel(item.createdAt) == _selectedPeriod;
    }).toList(growable: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Meus pagamentos',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _searchController,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            hintText: 'Pesquisar pagamento',
            prefixIcon: const Icon(Icons.search_rounded),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            ChoiceChip(
              label: const Text('Dia'),
              selected: _filterType == _PaymentFilterType.day,
              onSelected: (_) {
                setState(() {
                  _filterType = _PaymentFilterType.day;
                  _selectedPeriod = 'Todos';
                });
              },
            ),
            const SizedBox(width: 8),
            ChoiceChip(
              label: const Text('Mes'),
              selected: _filterType == _PaymentFilterType.month,
              onSelected: (_) {
                setState(() {
                  _filterType = _PaymentFilterType.month;
                  _selectedPeriod = 'Todos';
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        _DropdownField(
          label: 'Filtrar periodo',
          items: periods,
          value: periods.contains(_selectedPeriod) ? _selectedPeriod : 'Todos',
          onChanged: (value) {
            if (value == null) return;
            setState(() {
              _selectedPeriod = value;
            });
          },
        ),
        const SizedBox(height: 10),
        if (filtered.isEmpty)
          const _EmptyHintCard(
            text: 'Nenhum pagamento encontrado com os filtros atuais.',
          ),
        ...filtered.map((item) {
          return _MaintenanceCard(
            title: '${item.propertyName} - ${item.amountLabel}',
            location: '${item.paymentMethod} | ref ${item.referenceCode}',
            status: item.statusLabel,
            statusColor: item.statusColor,
          );
        }),
      ],
    );
  }
}

class _TenantMaintenanceTab extends StatefulWidget {
  const _TenantMaintenanceTab({required this.tenant});

  final UserProfile tenant;

  @override
  State<_TenantMaintenanceTab> createState() => _TenantMaintenanceTabState();
}

class _TenantMaintenanceTabState extends State<_TenantMaintenanceTab> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _propertyController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _propertyController.dispose();
    super.dispose();
  }

  void _submitRequest() {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    final property = _propertyController.text.trim();
    if (title.isEmpty || description.isEmpty || property.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha os campos da manutencao.')),
      );
      return;
    }
    setState(() {
      _tenantMaintenanceRequests.insert(
        0,
        _TenantMaintenanceRequestRecord(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          tenantId: widget.tenant.id,
          propertyName: property,
          title: title,
          description: description,
          createdAt: DateTime.now(),
          status: _TenantMaintenanceStatus.aberto,
        ),
      );
      _titleController.clear();
      _descriptionController.clear();
      _propertyController.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pedido de manutencao enviado.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final requests = _tenantMaintenanceRequests
        .where((item) => item.tenantId == widget.tenant.id)
        .toList(growable: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Manutencao',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 8),
        _TextField(
          label: 'Imovel',
          hint: 'Nome do imovel',
          controller: _propertyController,
        ),
        const SizedBox(height: 12),
        _TextField(
          label: 'Titulo do problema',
          hint: 'Ex: Fuga de agua',
          controller: _titleController,
        ),
        const SizedBox(height: 12),
        _TextField(
          label: 'Descricao',
          hint: 'Detalhe o problema',
          controller: _descriptionController,
        ),
        const SizedBox(height: 12),
        _ZimoLoadingFilledButton(
          onPressed: _submitRequest,
          loading: false,
          label: 'Requisitar manutencao',
          loadingLabel: 'A processar...',
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => _SupportChatScreen(
                  title: 'Assistencia tecnica',
                  currentUserName: widget.tenant.name,
                  seedMessages: _tenantSupportSeedMessages,
                ),
              ),
            );
          },
          icon: const Icon(Icons.support_agent_rounded),
          label: const Text('Abrir chat tecnico'),
        ),
        const SizedBox(height: 14),
        if (requests.isEmpty)
          const _EmptyHintCard(
            text: 'Sem pedidos de manutencao para este inquilino.',
          ),
        ...requests.map(
          (item) => _MaintenanceCard(
            title: '${item.propertyName} - ${item.title}',
            location: item.description,
            status: item.statusLabel,
            statusColor: item.statusColor,
          ),
        ),
      ],
    );
  }
}

class _SupportChatScreen extends StatefulWidget {
  const _SupportChatScreen({
    required this.title,
    required this.currentUserName,
    required this.seedMessages,
  });

  final String title;
  final String currentUserName;
  final List<_SupportMessage> seedMessages;

  @override
  State<_SupportChatScreen> createState() => _SupportChatScreenState();
}

class _SupportChatScreenState extends State<_SupportChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  late List<_SupportMessage> _messages;

  @override
  void initState() {
    super.initState();
    _messages = List<_SupportMessage>.from(widget.seedMessages);
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) {
      return;
    }
    setState(() {
      _messages.add(
        _SupportMessage(
          author: widget.currentUserName,
          text: text,
          createdAt: DateTime.now(),
          isSupport: false,
        ),
      );
      _messages.add(
        _SupportMessage(
          author: 'Suporte ZIMO',
          text: 'Recebemos sua mensagem. Nossa equipa tecnica vai responder.',
          createdAt: DateTime.now().add(const Duration(seconds: 1)),
          isSupport: true,
        ),
      );
    });
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final item = _messages[index];
                return Align(
                  alignment: item.isSupport
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    constraints: const BoxConstraints(maxWidth: 280),
                    decoration: BoxDecoration(
                      color: item.isSupport
                          ? const Color(0xFFE8F2FF)
                          : const Color(0xFFE5F0EC),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.author,
                          style:
                              Theme.of(context).textTheme.labelMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),
                        const SizedBox(height: 4),
                        Text(item.text),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Escreva sua mensagem',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: _sendMessage,
                    icon: const Icon(Icons.send_rounded),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileSettingsScreen extends StatefulWidget {
  const _ProfileSettingsScreen({required this.user});

  final UserProfile user;

  @override
  State<_ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<_ProfileSettingsScreen> {
  final ImagePicker _picker = ImagePicker();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  String? _avatarPath;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _phoneController = TextEditingController(text: widget.user.phone);
    _addressController = TextEditingController(text: widget.user.address);
    _avatarPath = widget.user.avatarPath;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 1000,
    );
    if (picked == null || !mounted) {
      return;
    }
    setState(() {
      _avatarPath = picked.path;
    });
  }

  void _saveProfile() {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final address = _addressController.text.trim();
    if (name.isEmpty || phone.isEmpty || address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha nome, telefone e endereco.')),
      );
      return;
    }
    setState(() {
      _loading = true;
    });
    final updated = widget.user.copyWith(
      name: name,
      phone: phone,
      address: address,
      avatarPath: _avatarPath,
    );
    Navigator.of(context).pop(updated);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuracoes do perfil')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 42,
                  backgroundColor: const Color(0xFF0E6E6E),
                  backgroundImage: _avatarPath == null
                      ? null
                      : FileImage(File(_avatarPath!)),
                  child: _avatarPath == null
                      ? Text(
                          _initialsFromName(widget.user.name),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        )
                      : null,
                ),
                TextButton.icon(
                  onPressed: _pickAvatar,
                  icon: const Icon(Icons.photo_camera_rounded),
                  label: const Text('Alterar foto'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _TextField(
            label: 'Nome',
            hint: 'Seu nome',
            controller: _nameController,
          ),
          const SizedBox(height: 12),
          _TextField(
            label: 'Telefone',
            hint: '+258 84 000 0000',
            controller: _phoneController,
          ),
          const SizedBox(height: 12),
          _TextField(
            label: 'Endereco',
            hint: 'Rua, bairro, cidade',
            controller: _addressController,
          ),
          const SizedBox(height: 16),
          _ZimoLoadingFilledButton(
            onPressed: _saveProfile,
            loading: _loading,
            label: 'Salvar alteracoes',
            loadingLabel: 'A processar...',
          ),
        ],
      ),
    );
  }
}

class _OwnerDashboardContent extends StatelessWidget {
  const _OwnerDashboardContent({
    required this.selectedTab,
    required this.onOpenPropertyForm,
    required this.ownerId,
  });

  final int selectedTab;
  final VoidCallback onOpenPropertyForm;
  final String ownerId;

  @override
  Widget build(BuildContext context) {
    switch (selectedTab) {
      case 1:
        return _OwnerPropertiesTab(ownerId: ownerId);
      case 2:
        return const _OwnerPaymentsTab();
      case 3:
        return const _OwnerMaintenanceTab();
      default:
        return _OwnerHomeTab(onOpenPropertyForm: onOpenPropertyForm);
    }
  }
}

class _OwnerHomeTab extends StatelessWidget {
  const _OwnerHomeTab({required this.onOpenPropertyForm});

  final VoidCallback onOpenPropertyForm;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gestao do proprietario',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 6),
        Text(
          'Acompanhe requisicoes dos seus imoveis, pagamentos e manutencao.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF4F4F4F),
              ),
        ),
        const SizedBox(height: 16),
        _QuickActions(onAddProperty: onOpenPropertyForm),
        const SizedBox(height: 20),
        Text(
          'Alertas de requisicao de imovel',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 10),
        ..._ownerRequestAlerts.map(
          (alert) => _MaintenanceCard(
            title: alert.title,
            location: '${alert.property} - ${alert.requester}',
            status: alert.status,
            statusColor: alert.statusColor,
          ),
        ),
      ],
    );
  }
}

class _OwnerPropertiesTab extends StatefulWidget {
  const _OwnerPropertiesTab({required this.ownerId});

  final String ownerId;

  @override
  State<_OwnerPropertiesTab> createState() => _OwnerPropertiesTabState();
}

class _OwnerPropertiesTabState extends State<_OwnerPropertiesTab> {
  final TextEditingController _searchController = TextEditingController();
  bool _loading = true;
  String? _error;
  List<_OwnerProperty> _properties = const [];

  @override
  void initState() {
    super.initState();
    _loadOwnerProperties();
  }

  Future<void> _loadOwnerProperties() async {
    try {
      final items =
          await BackendService.instance._fetchOwnerProperties(widget.ownerId);
      if (!mounted) {
        return;
      }
      setState(() {
        _properties = items;
        _loading = false;
        _error = null;
      });
    } on AuthException catch (e) {
      if (!mounted) {
        return;
      }
      setState(() {
        _loading = false;
        _error = e.message;
        _properties = List<_OwnerProperty>.from(_ownerProperties);
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _loading = false;
        _error = 'Nao foi possivel carregar os imoveis.';
        _properties = List<_OwnerProperty>.from(_ownerProperties);
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.trim().toLowerCase();
    final filtered = _properties.where((property) {
      if (query.isEmpty) {
        return true;
      }
      return property.name.toLowerCase().contains(query) ||
          property.propertyType.toLowerCase().contains(query) ||
          property.address.toLowerCase().contains(query);
    }).toList(growable: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Todos os meus imoveis',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 6),
        Text(
          'Pesquise por nome, tipo de imovel ou endereco.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF4F4F4F),
              ),
        ),
        const SizedBox(height: 12),
        if (_loading) ...[
          const LinearProgressIndicator(minHeight: 3),
          const SizedBox(height: 12),
        ],
        if (_error != null) ...[
          Text(
            _error!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: const Color(0xFFB3261E),
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 10),
        ],
        TextField(
          controller: _searchController,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            hintText: 'Pesquisar imovel',
            prefixIcon: const Icon(Icons.search_rounded),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          '${filtered.length} imovel(is) encontrado(s)',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: const Color(0xFF4F4F4F),
              ),
        ),
        const SizedBox(height: 10),
        ...filtered.map(
          (property) => _PropertyCard(
            title: '${property.name} (${property.propertyType})',
            subtitle:
                '${property.address} - ${property.bedrooms} quarto(s) - ${property.status}',
            statusColor: property.statusColor,
            rent: property.rent,
          ),
        ),
      ],
    );
  }
}

class _OwnerPaymentsTab extends StatelessWidget {
  const _OwnerPaymentsTab();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pagamentos',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F2FF),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            'No fluxo ZIMO, o pagamento do inquilino entra primeiro na ZIMO. Depois da confirmacao das condicoes do imovel, o valor e liberado ao proprietario.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: const Color(0xFF274060),
                ),
          ),
        ),
        const SizedBox(height: 14),
        ..._ownerPayments.map(
          (payment) => _MaintenanceCard(
            title: '${payment.property} - ${payment.tenant}',
            location: '${payment.amount} - ${payment.referenceDate}',
            status: payment.statusLabel,
            statusColor: payment.statusColor,
          ),
        ),
      ],
    );
  }
}

class _OwnerMaintenanceTab extends StatelessWidget {
  const _OwnerMaintenanceTab();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Requisicoes de manutencao',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 6),
        Text(
          'Pedidos enviados pelos inquilinos dos seus imoveis.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF4F4F4F),
              ),
        ),
        const SizedBox(height: 12),
        ..._ownerMaintenanceRequests.map(
          (request) => _MaintenanceCard(
            title: request.title,
            location: '${request.property} - ${request.tenant}',
            status: request.status,
            statusColor: request.statusColor,
          ),
        ),
      ],
    );
  }
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key, required this.role});

  final UserRole role;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _documentController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loading = false;

  String get _title {
    switch (widget.role) {
      case UserRole.proprietario:
        return 'Criar conta de proprietario';
      case UserRole.inquilino:
        return 'Criar conta de inquilino';
      case UserRole.admin:
        return 'Criar conta';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _documentController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (widget.role == UserRole.admin) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
      return;
    }
    final name = _nameController.text.trim();
    final address = _addressController.text.trim();
    final phone = _phoneController.text.trim();
    final email = _emailController.text.trim();
    final document = _documentController.text.trim();
    final password = _passwordController.text.trim();
    if (name.isEmpty ||
        address.isEmpty ||
        phone.isEmpty ||
        email.isEmpty ||
        document.isEmpty ||
        password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos.')),
      );
      return;
    }
    setState(() {
      _loading = true;
    });
    final profile = UserProfile(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      address: address,
      phone: phone,
      email: email,
      password: password,
      document: document,
      role: widget.role,
    );
    await BackendService.instance.registerUser(profile);
    if (!mounted) return;
    setState(() {
      _loading = false;
    });
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DashboardScreen(user: profile),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFE6F3F2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Tipo de conta: ${roleLabel(widget.role)}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          const SizedBox(height: 16),
          _TextField(
            label: 'Nome completo',
            hint: 'Seu nome',
            controller: _nameController,
          ),
          const SizedBox(height: 16),
          _TextField(
            label: 'Endereco',
            hint: 'Rua, bairro, cidade',
            controller: _addressController,
          ),
          const SizedBox(height: 16),
          _TextField(
            label: 'Contacto',
            hint: '+258 84 000 0000',
            controller: _phoneController,
          ),
          const SizedBox(height: 16),
          _TextField(
            label: 'Email',
            hint: 'exemplo@zimo.co.mz',
            controller: _emailController,
          ),
          const SizedBox(height: 16),
          _TextField(
            label: 'Documento (BI/NIF)',
            hint: 'Numero do documento',
            controller: _documentController,
          ),
          const SizedBox(height: 16),
          _TextField(
            label: 'Senha',
            hint: '********',
            obscure: true,
            controller: _passwordController,
          ),
          const SizedBox(height: 24),
          _ZimoLoadingFilledButton(
            onPressed: _submit,
            loading: _loading,
            label: 'Criar conta',
            loadingLabel: 'A processar...',
          ),
          const SizedBox(height: 10),
          Text(
            'Os dados sao obrigatorios e serao enviados para a base de dados na integracao do backend.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: const Color(0xFF4F4F4F),
                ),
          ),
        ],
      ),
    );
  }
}

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  late Future<List<UserProfile>> _usersFuture;

  @override
  void initState() {
    super.initState();
    _usersFuture = BackendService.instance.fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Painel Admin'),
        actions: const [_LogoutAppBarAction()],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'Centro de controlo',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Supervisao de utilizadores, uploads e sinais de risco.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF4F4F4F),
                ),
          ),
          const SizedBox(height: 20),
          _AdminQuickActions(
            onOpenUsers: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AdminUsersScreen(),
                ),
              );
            },
            onOpenUploads: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AdminUploadsScreen(),
                ),
              );
            },
            onOpenRiskCenter: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AdminRiskCenterScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          FutureBuilder<List<UserProfile>>(
            future: _usersFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (snapshot.hasError) {
                return Text(
                  'Falha ao carregar usuarios do MySQL.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFFB3261E),
                      ),
                );
              }

              final users = snapshot.data ?? [];
              final adminCount =
                  users.where((user) => user.role == UserRole.admin).length;
              final proprietarioCount = users
                  .where((user) => user.role == UserRole.proprietario)
                  .length;
              final inquilinoCount =
                  users.where((user) => user.role == UserRole.inquilino).length;
              final riskUploads =
                  _adminUploadEvents.where((event) => event.flagged).length;
              final openAlerts = _adminSuspiciousEvents
                  .where((event) => !event.resolved)
                  .length;
              if (users.isEmpty) {
                return Text(
                  'Nenhum utilizador cadastrado ainda.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF4F4F4F),
                      ),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Resumo rapido',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _AdminSummaryCard(
                        label: 'Utilizadores',
                        value: '${users.length}',
                        accent: const Color(0xFF0E6E6E),
                      ),
                      _AdminSummaryCard(
                        label: 'Admins',
                        value: '$adminCount',
                        accent: const Color(0xFF7A5C2E),
                      ),
                      _AdminSummaryCard(
                        label: 'Proprietarios',
                        value: '$proprietarioCount',
                        accent: const Color(0xFF0E6E6E),
                      ),
                      _AdminSummaryCard(
                        label: 'Inquilinos',
                        value: '$inquilinoCount',
                        accent: const Color(0xFFB6452C),
                      ),
                      _AdminSummaryCard(
                        label: 'Uploads em risco',
                        value: '$riskUploads',
                        accent: const Color(0xFFB3261E),
                      ),
                      _AdminSummaryCard(
                        label: 'Alertas abertos',
                        value: '$openAlerts',
                        accent: const Color(0xFFAA3A1E),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Requer atencao agora',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 10),
                  ..._adminSuspiciousEvents
                      .where((event) => !event.resolved)
                      .take(2)
                      .map(
                        (event) => _MaintenanceCard(
                          title: event.title,
                          location: event.userName,
                          status: event.severityLabel,
                          statusColor: event.severityColor,
                        ),
                      ),
                  const SizedBox(height: 20),
                  Text(
                    'Utilizadores recentes',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 10),
                  ...users.take(5).map((user) => _AdminUserCard(user: user)),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const AdminUsersScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.open_in_new_rounded, size: 18),
                      label: const Text('Ver todos utilizadores'),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _AdminUserCard extends StatelessWidget {
  const _AdminUserCard({
    required this.user,
    this.statusLabel = 'Ativa',
    this.statusColor = const Color(0xFF0E6E6E),
    this.trailing,
  });

  final UserProfile user;
  final String statusLabel;
  final Color statusColor;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFF0E6E6E).withOpacity(0.1),
            child: Text(
              user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
              style: const TextStyle(color: Color(0xFF0E6E6E)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                Text(
                  '${roleLabel(user.role)} - ${user.email}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF4F4F4F),
                      ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    statusLabel,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 10),
            trailing!,
          ],
        ],
      ),
    );
  }
}

enum _AdminRoleFilter { todos, admin, proprietario, inquilino }

enum _AdminStatusFilter { todos, ativos, suspensos }

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  late Future<List<UserProfile>> _usersFuture;
  final TextEditingController _searchController = TextEditingController();
  _AdminRoleFilter _roleFilter = _AdminRoleFilter.todos;
  _AdminStatusFilter _statusFilter = _AdminStatusFilter.todos;
  final Set<String> _suspendedUserIds = {};

  @override
  void initState() {
    super.initState();
    _usersFuture = BackendService.instance.fetchUsers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<UserProfile> _filtered(List<UserProfile> users) {
    final query = _searchController.text.trim().toLowerCase();
    return users.where((user) {
      final roleMatches = switch (_roleFilter) {
        _AdminRoleFilter.todos => true,
        _AdminRoleFilter.admin => user.role == UserRole.admin,
        _AdminRoleFilter.proprietario => user.role == UserRole.proprietario,
        _AdminRoleFilter.inquilino => user.role == UserRole.inquilino,
      };
      if (!roleMatches) return false;

      final suspended = _suspendedUserIds.contains(user.id);
      final statusMatches = switch (_statusFilter) {
        _AdminStatusFilter.todos => true,
        _AdminStatusFilter.ativos => !suspended,
        _AdminStatusFilter.suspensos => suspended,
      };
      if (!statusMatches) return false;

      if (query.isEmpty) return true;
      return user.name.toLowerCase().contains(query) ||
          user.email.toLowerCase().contains(query) ||
          user.document.toLowerCase().contains(query);
    }).toList(growable: false);
  }

  String _roleLabel(_AdminRoleFilter value) {
    switch (value) {
      case _AdminRoleFilter.todos:
        return 'Todos';
      case _AdminRoleFilter.admin:
        return 'Admins';
      case _AdminRoleFilter.proprietario:
        return 'Proprietarios';
      case _AdminRoleFilter.inquilino:
        return 'Inquilinos';
    }
  }

  String _statusLabel(_AdminStatusFilter value) {
    switch (value) {
      case _AdminStatusFilter.todos:
        return 'Todos';
      case _AdminStatusFilter.ativos:
        return 'Ativos';
      case _AdminStatusFilter.suspensos:
        return 'Suspensos';
    }
  }

  void _handleUserAction(UserProfile user, String action) {
    if (action == 'suspender') {
      setState(() {
        _suspendedUserIds.add(user.id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Conta de ${user.name} suspensa.')),
      );
      return;
    }

    if (action == 'reativar') {
      setState(() {
        _suspendedUserIds.remove(user.id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Conta de ${user.name} reativada.')),
      );
      return;
    }

    if (action == 'senha') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Link de reset enviado para ${user.email}.')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Historico de ${user.name} aberto.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Utilizadores do sistema'),
        actions: const [_LogoutAppBarAction()],
      ),
      body: FutureBuilder<List<UserProfile>>(
        future: _usersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Nao foi possivel carregar utilizadores.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFFB3261E),
                      ),
                ),
              ),
            );
          }

          final users = snapshot.data ?? [];
          final filteredUsers = _filtered(users);
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Pesquisar por nome, email ou documento',
                  prefixIcon: const Icon(Icons.search_rounded),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Text(
                    'Filtros',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _searchController.clear();
                        _roleFilter = _AdminRoleFilter.todos;
                        _statusFilter = _AdminStatusFilter.todos;
                      });
                    },
                    child: const Text('Limpar'),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _AdminRoleFilter.values
                    .map(
                      (filter) => ChoiceChip(
                        label: Text(_roleLabel(filter)),
                        selected: _roleFilter == filter,
                        onSelected: (_) {
                          setState(() {
                            _roleFilter = filter;
                          });
                        },
                      ),
                    )
                    .toList(growable: false),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _AdminStatusFilter.values
                    .map(
                      (filter) => ChoiceChip(
                        label: Text(_statusLabel(filter)),
                        selected: _statusFilter == filter,
                        onSelected: (_) {
                          setState(() {
                            _statusFilter = filter;
                          });
                        },
                      ),
                    )
                    .toList(growable: false),
              ),
              const SizedBox(height: 16),
              Text(
                '${filteredUsers.length} resultado(s)',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF4F4F4F),
                    ),
              ),
              const SizedBox(height: 10),
              if (filteredUsers.isEmpty)
                Text(
                  'Sem utilizadores para os filtros selecionados.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF4F4F4F),
                      ),
                )
              else
                ...filteredUsers.map((user) {
                  final suspended = _suspendedUserIds.contains(user.id);
                  return _AdminUserCard(
                    user: user,
                    statusLabel: suspended ? 'Suspensa' : 'Ativa',
                    statusColor: suspended
                        ? const Color(0xFFB3261E)
                        : const Color(0xFF0E6E6E),
                    trailing: PopupMenuButton<String>(
                      onSelected: (action) => _handleUserAction(user, action),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: suspended ? 'reativar' : 'suspender',
                          child: Text(
                              suspended ? 'Reativar conta' : 'Suspender conta'),
                        ),
                        const PopupMenuItem(
                          value: 'senha',
                          child: Text('Resetar senha'),
                        ),
                        const PopupMenuItem(
                          value: 'historico',
                          child: Text('Ver historico'),
                        ),
                      ],
                      icon: const Icon(Icons.more_vert_rounded),
                    ),
                  );
                }),
            ],
          );
        },
      ),
    );
  }
}

class AdminUploadsScreen extends StatefulWidget {
  const AdminUploadsScreen({super.key});

  @override
  State<AdminUploadsScreen> createState() => _AdminUploadsScreenState();
}

class _AdminUploadsScreenState extends State<AdminUploadsScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _onlyFlagged = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.trim().toLowerCase();
    final events = _adminUploadEvents.where((event) {
      if (_onlyFlagged && !event.flagged) return false;
      if (query.isEmpty) return true;
      return event.userName.toLowerCase().contains(query) ||
          event.fileName.toLowerCase().contains(query) ||
          event.category.toLowerCase().contains(query);
    }).toList(growable: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Monitor de uploads'),
        actions: const [_LogoutAppBarAction()],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'Acompanhe ficheiros enviados e identifique documentos suspeitos.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF4F4F4F),
                ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _searchController,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'Pesquisar por utilizador ou ficheiro',
              prefixIcon: const Icon(Icons.search_rounded),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 10),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Mostrar apenas uploads com risco'),
            value: _onlyFlagged,
            onChanged: (value) {
              setState(() {
                _onlyFlagged = value;
              });
            },
          ),
          const SizedBox(height: 8),
          Text(
            '${events.length} upload(s) encontrado(s)',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: const Color(0xFF4F4F4F),
                ),
          ),
          const SizedBox(height: 8),
          ...events.map(
            (event) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: event.flagged
                      ? const Color(0xFFFFD5CF)
                      : const Color(0xFFE8ECEC),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 36,
                    width: 36,
                    decoration: BoxDecoration(
                      color: event.flagged
                          ? const Color(0xFFB3261E).withOpacity(0.12)
                          : const Color(0xFF0E6E6E).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      event.flagged
                          ? Icons.warning_amber_rounded
                          : Icons.upload_file_rounded,
                      color: event.flagged
                          ? const Color(0xFFB3261E)
                          : const Color(0xFF0E6E6E),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.fileName,
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${event.userName} - ${event.category}',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: const Color(0xFF4F4F4F),
                                  ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _timeAgo(event.createdAt),
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: const Color(0xFF5A5A5A),
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AdminRiskCenterScreen extends StatefulWidget {
  const AdminRiskCenterScreen({super.key});

  @override
  State<AdminRiskCenterScreen> createState() => _AdminRiskCenterScreenState();
}

class _AdminRiskCenterScreenState extends State<AdminRiskCenterScreen> {
  late List<_AdminSuspiciousEvent> _events;

  @override
  void initState() {
    super.initState();
    _events = _adminSuspiciousEvents
        .map(
          (event) => _AdminSuspiciousEvent(
            id: event.id,
            userName: event.userName,
            title: event.title,
            details: event.details,
            severity: event.severity,
            createdAt: event.createdAt,
            resolved: event.resolved,
          ),
        )
        .toList(growable: false);
  }

  void _resolve(String id) {
    setState(() {
      _events = _events
          .map(
            (event) => event.id == id
                ? _AdminSuspiciousEvent(
                    id: event.id,
                    userName: event.userName,
                    title: event.title,
                    details: event.details,
                    severity: event.severity,
                    createdAt: event.createdAt,
                    resolved: true,
                  )
                : event,
          )
          .toList(growable: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final open =
        _events.where((event) => !event.resolved).toList(growable: false);
    final resolved =
        _events.where((event) => event.resolved).toList(growable: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Central de risco'),
        actions: const [_LogoutAppBarAction()],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'Monitore atividades fora do padrao e resolva alertas rapidamente.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF4F4F4F),
                ),
          ),
          const SizedBox(height: 14),
          _KpiCard(
            label: 'Alertas abertos',
            value: '${open.length}',
            accent: const Color(0xFFB3261E),
          ),
          const SizedBox(height: 12),
          _KpiCard(
            label: 'Alertas resolvidos',
            value: '${resolved.length}',
            accent: const Color(0xFF0E6E6E),
          ),
          const SizedBox(height: 18),
          Text(
            'Abertos',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 10),
          if (open.isEmpty)
            const Text('Sem alertas pendentes.')
          else
            ...open.map(
              (event) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFFFD6CF)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            event.title,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: event.severityColor.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            event.severityLabel,
                            style: TextStyle(
                              color: event.severityColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${event.userName} - ${event.details}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: const Color(0xFF4F4F4F),
                          ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          _timeAgo(event.createdAt),
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: const Color(0xFF5A5A5A),
                                  ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () => _resolve(event.id),
                          child: const Text('Marcar como resolvido'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _AdminQuickActions extends StatelessWidget {
  const _AdminQuickActions({
    required this.onOpenUsers,
    required this.onOpenUploads,
    required this.onOpenRiskCenter,
  });

  final VoidCallback onOpenUsers;
  final VoidCallback onOpenUploads;
  final VoidCallback onOpenRiskCenter;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Acoes de administracao',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onOpenUsers,
              icon: const Icon(Icons.groups_rounded),
              label: const Text('Ver utilizadores'),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onOpenUploads,
              icon: const Icon(Icons.upload_file_rounded),
              label: const Text('Monitorar uploads'),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onOpenRiskCenter,
              icon: const Icon(Icons.gpp_maybe_rounded),
              label: const Text('Comportamentos suspeitos'),
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminSummaryCard extends StatelessWidget {
  const _AdminSummaryCard({
    required this.label,
    required this.value,
    required this.accent,
  });

  final String label;
  final String value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accent.withOpacity(0.24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: accent,
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: const Color(0xFF4F4F4F),
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

class _AdminUploadEvent {
  const _AdminUploadEvent({
    required this.userName,
    required this.fileName,
    required this.category,
    required this.createdAt,
    required this.flagged,
  });

  final String userName;
  final String fileName;
  final String category;
  final DateTime createdAt;
  final bool flagged;
}

enum _RiskSeverity { alto, medio, baixo }

class _AdminSuspiciousEvent {
  const _AdminSuspiciousEvent({
    required this.id,
    required this.userName,
    required this.title,
    required this.details,
    required this.severity,
    required this.createdAt,
    required this.resolved,
  });

  final String id;
  final String userName;
  final String title;
  final String details;
  final _RiskSeverity severity;
  final DateTime createdAt;
  final bool resolved;

  String get severityLabel {
    switch (severity) {
      case _RiskSeverity.alto:
        return 'Alto';
      case _RiskSeverity.medio:
        return 'Medio';
      case _RiskSeverity.baixo:
        return 'Baixo';
    }
  }

  Color get severityColor {
    switch (severity) {
      case _RiskSeverity.alto:
        return const Color(0xFFB3261E);
      case _RiskSeverity.medio:
        return const Color(0xFFB6452C);
      case _RiskSeverity.baixo:
        return const Color(0xFF0E6E6E);
    }
  }
}

String _timeAgo(DateTime dateTime) {
  final diff = DateTime.now().difference(dateTime);
  if (diff.inMinutes < 1) return 'agora';
  if (diff.inMinutes < 60) return 'ha ${diff.inMinutes} min';
  if (diff.inHours < 24) return 'ha ${diff.inHours} h';
  return 'ha ${diff.inDays} dia(s)';
}

final List<_AdminUploadEvent> _adminUploadEvents = [
  _AdminUploadEvent(
    userName: 'Proprietario 02',
    fileName: 'contrato_lumina_assinado.pdf',
    category: 'Contrato',
    createdAt: DateTime(2026, 2, 12, 7, 20),
    flagged: false,
  ),
  _AdminUploadEvent(
    userName: 'Inquilino 04',
    fileName: 'comprovativo_pagamento_fev.png',
    category: 'Comprovativo',
    createdAt: DateTime(2026, 2, 12, 6, 42),
    flagged: false,
  ),
  _AdminUploadEvent(
    userName: 'Inquilino 09',
    fileName: 'novo_doc_banco.zip',
    category: 'Documento',
    createdAt: DateTime(2026, 2, 12, 6, 15),
    flagged: true,
  ),
  _AdminUploadEvent(
    userName: 'Proprietario 12',
    fileName: 'recibo_alterado_12.pdf',
    category: 'Recibo',
    createdAt: DateTime(2026, 2, 12, 5, 57),
    flagged: true,
  ),
];

final List<_AdminSuspiciousEvent> _adminSuspiciousEvents = [
  _AdminSuspiciousEvent(
    id: 'risk_001',
    userName: 'Inquilino 09',
    title: 'Padrao de upload fora da rotina',
    details: '7 uploads em 4 minutos com ficheiros compactados.',
    severity: _RiskSeverity.alto,
    createdAt: DateTime(2026, 2, 12, 6, 16),
    resolved: false,
  ),
  _AdminSuspiciousEvent(
    id: 'risk_002',
    userName: 'Proprietario 12',
    title: 'Tentativas repetidas de alteracao',
    details: 'Alterou 3 vezes o mesmo recibo em menos de 30 minutos.',
    severity: _RiskSeverity.medio,
    createdAt: DateTime(2026, 2, 12, 5, 59),
    resolved: false,
  ),
  _AdminSuspiciousEvent(
    id: 'risk_003',
    userName: 'michael.admin@zimo.co.mz',
    title: 'Login em novo dispositivo',
    details: 'Sessao administrativa iniciada em dispositivo nao reconhecido.',
    severity: _RiskSeverity.baixo,
    createdAt: DateTime(2026, 2, 11, 21, 10),
    resolved: true,
  ),
];

class _OwnerRequestAlert {
  const _OwnerRequestAlert({
    required this.title,
    required this.property,
    required this.requester,
    required this.status,
    required this.statusColor,
  });

  final String title;
  final String property;
  final String requester;
  final String status;
  final Color statusColor;
}

class _OwnerProperty {
  const _OwnerProperty({
    this.id = '',
    required this.name,
    required this.propertyType,
    this.bedrooms = 1,
    required this.address,
    required this.status,
    required this.statusColor,
    required this.rent,
    this.photos = const [],
  });

  final String id;
  final String name;
  final String propertyType;
  final int bedrooms;
  final String address;
  final String status;
  final Color statusColor;
  final String rent;
  final List<String> photos;

  factory _OwnerProperty.fromApi(Map<String, dynamic> json) {
    return _OwnerProperty(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      propertyType: json['property_type']?.toString() ?? 'Apartamento',
      bedrooms: int.tryParse(json['bedrooms']?.toString() ?? '') ?? 1,
      address: json['address']?.toString() ?? '',
      status: json['status']?.toString() ?? 'Disponivel',
      statusColor: _ownerPropertyStatusColor(
        json['status_key']?.toString() ?? json['status']?.toString() ?? '',
      ),
      rent: '${json['rent']?.toString() ?? '0'} MT',
      photos: (json['photos'] as List<dynamic>? ?? [])
          .map((photo) => photo.toString())
          .toList(growable: false),
    );
  }
}

enum _OwnerPaymentStatus {
  recebidoPelaZimo,
  emVerificacaoDeCondicoes,
  liberadoAoProprietario
}

class _OwnerPayment {
  const _OwnerPayment({
    required this.property,
    required this.tenant,
    required this.amount,
    required this.referenceDate,
    required this.status,
  });

  final String property;
  final String tenant;
  final String amount;
  final String referenceDate;
  final _OwnerPaymentStatus status;

  String get statusLabel {
    switch (status) {
      case _OwnerPaymentStatus.recebidoPelaZimo:
        return 'Recebido pela ZIMO';
      case _OwnerPaymentStatus.emVerificacaoDeCondicoes:
        return 'Em verificacao';
      case _OwnerPaymentStatus.liberadoAoProprietario:
        return 'Liberado ao proprietario';
    }
  }

  Color get statusColor {
    switch (status) {
      case _OwnerPaymentStatus.recebidoPelaZimo:
        return const Color(0xFF7A5C2E);
      case _OwnerPaymentStatus.emVerificacaoDeCondicoes:
        return const Color(0xFFB6452C);
      case _OwnerPaymentStatus.liberadoAoProprietario:
        return const Color(0xFF0E6E6E);
    }
  }
}

class _OwnerMaintenanceRequest {
  const _OwnerMaintenanceRequest({
    required this.title,
    required this.property,
    required this.tenant,
    required this.status,
    required this.statusColor,
  });

  final String title;
  final String property;
  final String tenant;
  final String status;
  final Color statusColor;
}

Color _ownerPropertyStatusColor(String rawStatus) {
  final normalized = rawStatus.trim().toLowerCase();
  if (normalized.contains('ocup')) {
    return const Color(0xFF7A5C2E);
  }
  if (normalized.contains('manut')) {
    return const Color(0xFFB6452C);
  }
  return const Color(0xFF0E6E6E);
}

final List<_OwnerRequestAlert> _ownerRequestAlerts = [
  const _OwnerRequestAlert(
    title: 'Nova requisicao de visita',
    property: 'Residencial Lumina',
    requester: 'Joaquim Cossa',
    status: 'Aguardando resposta',
    statusColor: Color(0xFFB6452C),
  ),
  const _OwnerRequestAlert(
    title: 'Pedido de arrendamento',
    property: 'Maputo View - Apto 302',
    requester: 'Amina Mucavele',
    status: 'Documentos enviados',
    statusColor: Color(0xFF0E6E6E),
  ),
];

final List<_OwnerProperty> _ownerProperties = [
  const _OwnerProperty(
    name: 'Residencial Lumina',
    propertyType: 'Apartamento',
    address: 'Av. Julius Nyerere, Maputo',
    status: 'Disponivel',
    statusColor: Color(0xFF0E6E6E),
    rent: '72.000 MT',
  ),
  const _OwnerProperty(
    name: 'Maputo View',
    propertyType: 'Apartamento',
    address: 'Baixa, Maputo',
    status: 'Ocupado',
    statusColor: Color(0xFF7A5C2E),
    rent: '45.000 MT',
  ),
  const _OwnerProperty(
    name: 'Moradia Triunfo',
    propertyType: 'Vivenda',
    address: 'Triunfo, Maputo',
    status: 'Em manutencao',
    statusColor: Color(0xFFB6452C),
    rent: '95.000 MT',
  ),
];

final List<_OwnerPayment> _ownerPayments = [
  const _OwnerPayment(
    property: 'Maputo View',
    tenant: 'Carlos Langa',
    amount: '45.000 MT',
    referenceDate: 'Fev/2026',
    status: _OwnerPaymentStatus.recebidoPelaZimo,
  ),
  const _OwnerPayment(
    property: 'Moradia Triunfo',
    tenant: 'Ana Mabote',
    amount: '95.000 MT',
    referenceDate: 'Fev/2026',
    status: _OwnerPaymentStatus.emVerificacaoDeCondicoes,
  ),
  const _OwnerPayment(
    property: 'Residencial Lumina',
    tenant: 'Marta Mussa',
    amount: '72.000 MT',
    referenceDate: 'Jan/2026',
    status: _OwnerPaymentStatus.liberadoAoProprietario,
  ),
];

final List<_OwnerMaintenanceRequest> _ownerMaintenanceRequests = [
  const _OwnerMaintenanceRequest(
    title: 'Fuga de agua na cozinha',
    property: 'Maputo View',
    tenant: 'Carlos Langa',
    status: 'Pendente',
    statusColor: Color(0xFFB3261E),
  ),
  const _OwnerMaintenanceRequest(
    title: 'Tomadas sem energia',
    property: 'Moradia Triunfo',
    tenant: 'Ana Mabote',
    status: 'Em andamento',
    statusColor: Color(0xFFB6452C),
  ),
  const _OwnerMaintenanceRequest(
    title: 'Pintura da sala',
    property: 'Residencial Lumina',
    tenant: 'Marta Mussa',
    status: 'Concluido',
    statusColor: Color(0xFF0E6E6E),
  ),
];

class _TenantReservationRecord {
  const _TenantReservationRecord({
    required this.id,
    required this.tenantId,
    required this.tenantName,
    required this.propertyId,
    required this.propertyName,
    required this.propertyType,
    required this.bedrooms,
    required this.address,
    required this.rentLabel,
    required this.status,
    required this.photos,
    required this.createdAt,
  });

  final String id;
  final String tenantId;
  final String tenantName;
  final String propertyId;
  final String propertyName;
  final String propertyType;
  final int bedrooms;
  final String address;
  final String rentLabel;
  final String status;
  final List<String> photos;
  final DateTime createdAt;
}

enum _TenantPaymentStatus { pendente, pago, emAnalise }

class _TenantPaymentRecord {
  const _TenantPaymentRecord({
    required this.id,
    required this.tenantId,
    required this.propertyId,
    required this.propertyName,
    required this.amountLabel,
    required this.paymentMethod,
    required this.referenceCode,
    required this.createdAt,
    required this.status,
  });

  final String id;
  final String tenantId;
  final String propertyId;
  final String propertyName;
  final String amountLabel;
  final String paymentMethod;
  final String referenceCode;
  final DateTime createdAt;
  final _TenantPaymentStatus status;

  String get statusLabel {
    switch (status) {
      case _TenantPaymentStatus.pago:
        return 'Pago';
      case _TenantPaymentStatus.emAnalise:
        return 'Em analise';
      case _TenantPaymentStatus.pendente:
        return 'Pendente';
    }
  }

  Color get statusColor {
    switch (status) {
      case _TenantPaymentStatus.pago:
        return const Color(0xFF0E6E6E);
      case _TenantPaymentStatus.emAnalise:
        return const Color(0xFFB6452C);
      case _TenantPaymentStatus.pendente:
        return const Color(0xFF7A5C2E);
    }
  }
}

enum _TenantMaintenanceStatus { aberto, emAndamento, concluido }

class _TenantMaintenanceRequestRecord {
  const _TenantMaintenanceRequestRecord({
    required this.id,
    required this.tenantId,
    required this.propertyName,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.status,
  });

  final String id;
  final String tenantId;
  final String propertyName;
  final String title;
  final String description;
  final DateTime createdAt;
  final _TenantMaintenanceStatus status;

  String get statusLabel {
    switch (status) {
      case _TenantMaintenanceStatus.aberto:
        return 'Aberto';
      case _TenantMaintenanceStatus.emAndamento:
        return 'Em andamento';
      case _TenantMaintenanceStatus.concluido:
        return 'Concluido';
    }
  }

  Color get statusColor {
    switch (status) {
      case _TenantMaintenanceStatus.aberto:
        return const Color(0xFFB3261E);
      case _TenantMaintenanceStatus.emAndamento:
        return const Color(0xFFB6452C);
      case _TenantMaintenanceStatus.concluido:
        return const Color(0xFF0E6E6E);
    }
  }
}

class _SupportMessage {
  const _SupportMessage({
    required this.author,
    required this.text,
    required this.createdAt,
    required this.isSupport,
  });

  final String author;
  final String text;
  final DateTime createdAt;
  final bool isSupport;
}

final List<_TenantReservationRecord> _tenantReservations = [];
final List<_TenantPaymentRecord> _tenantPayments = [];
final List<_TenantMaintenanceRequestRecord> _tenantMaintenanceRequests = [];

final List<_SupportMessage> _tenantSupportSeedMessages = [
  _SupportMessage(
    author: 'Suporte ZIMO',
    text: 'Bem-vindo ao chat tecnico. Em que podemos ajudar?',
    createdAt: DateTime(2026, 2, 12, 10, 5),
    isSupport: true,
  ),
];

final List<_SupportMessage> _ownerSupportSeedMessages = [
  _SupportMessage(
    author: 'Suporte ZIMO',
    text: 'Canal do proprietario ativo. Pode enviar suas duvidas.',
    createdAt: DateTime(2026, 2, 12, 9, 20),
    isSupport: true,
  ),
];

void _reservePropertyWithPayment({
  required String tenantId,
  required String tenantName,
  required _OwnerProperty property,
  required String paymentMethod,
}) {
  final alreadyReserved = _tenantReservations.any(
    (item) => item.tenantId == tenantId && item.propertyId == property.id,
  );
  if (!alreadyReserved) {
    _tenantReservations.insert(
      0,
      _TenantReservationRecord(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        tenantId: tenantId,
        tenantName: tenantName,
        propertyId: property.id,
        propertyName: property.name,
        propertyType: property.propertyType,
        bedrooms: property.bedrooms,
        address: property.address,
        rentLabel: property.rent,
        status: 'Reservado',
        photos: property.photos,
        createdAt: DateTime.now(),
      ),
    );
  }

  _tenantPayments.insert(
    0,
    _TenantPaymentRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      tenantId: tenantId,
      propertyId: property.id,
      propertyName: property.name,
      amountLabel: property.rent,
      paymentMethod: paymentMethod,
      referenceCode: 'ZIMO-${DateTime.now().millisecondsSinceEpoch % 1000000}',
      createdAt: DateTime.now(),
      status: _TenantPaymentStatus.emAnalise,
    ),
  );
}

String _paymentDayLabel(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '$day/$month/${date.year}';
}

String _paymentMonthLabel(DateTime date) {
  final month = date.month.toString().padLeft(2, '0');
  return '$month/${date.year}';
}

List<String> _buildPaymentPeriods(
  List<_TenantPaymentRecord> payments,
  _PaymentFilterType type,
) {
  final labels = payments
      .map(
        (item) => type == _PaymentFilterType.day
            ? _paymentDayLabel(item.createdAt)
            : _paymentMonthLabel(item.createdAt),
      )
      .toSet()
      .toList()
    ..sort((a, b) => b.compareTo(a));
  return ['Todos', ...labels];
}

class _ZimoLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 44,
          width: 44,
          decoration: BoxDecoration(
            color: const Color(0xFF0E6E6E),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(Icons.location_city_rounded, color: Colors.white),
        ),
        const SizedBox(width: 12),
        Text(
          'ZIMO',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: 1.1,
              ),
        ),
      ],
    );
  }
}

class _FeatureTile extends StatelessWidget {
  const _FeatureTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF0E6E6E).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF0E6E6E)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF4F4F4F),
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final borderColor = selected ? const Color(0xFF0E6E6E) : Colors.transparent;
    final background =
        selected ? const Color(0xFFE6F3F2) : const Color(0xFFFFFFFF);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: 1.2),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFF0E6E6E).withOpacity(0.1),
                child: Icon(icon, color: const Color(0xFF0E6E6E)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: const Color(0xFF4F4F4F),
                          ),
                    ),
                  ],
                ),
              ),
              Icon(
                selected ? Icons.check_circle_rounded : Icons.circle_outlined,
                color: selected
                    ? const Color(0xFF0E6E6E)
                    : const Color(0xFFB0B0B0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TextField extends StatelessWidget {
  const _TextField({
    required this.label,
    required this.hint,
    this.obscure = false,
    this.controller,
    this.suffixIcon,
  });

  final String label;
  final String hint;
  final bool obscure;
  final TextEditingController? controller;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        TextField(
          obscureText: obscure,
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}

class _DashboardKpiGrid extends StatelessWidget {
  const _DashboardKpiGrid();

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        _KpiCard(
          label: 'Total de imoveis',
          value: '12',
          accent: Color(0xFF0E6E6E),
        ),
        _KpiCard(
          label: 'Rendas recebidas',
          value: '420.000 MT',
          accent: Color(0xFFB6452C),
        ),
        _KpiCard(
          label: 'Rendas em atraso',
          value: '3',
          accent: Color(0xFFB3261E),
        ),
        _KpiCard(
          label: 'Alertas ativos',
          value: '5',
          accent: Color(0xFF7A5C2E),
        ),
      ],
    );
  }
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({
    required this.label,
    required this.value,
    required this.accent,
  });

  final String label;
  final String value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 6,
            width: 36,
            decoration: BoxDecoration(
              color: accent,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: const Color(0xFF4F4F4F),
                ),
          ),
        ],
      ),
    );
  }
}

class _PropertyCard extends StatelessWidget {
  const _PropertyCard({
    required this.title,
    required this.subtitle,
    required this.statusColor,
    required this.rent,
  });

  final String title;
  final String subtitle;
  final Color statusColor;
  final String rent;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.home_rounded, color: statusColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF4F4F4F),
                      ),
                ),
              ],
            ),
          ),
          Text(
            rent,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: statusColor,
                ),
          ),
        ],
      ),
    );
  }
}

class _MaintenanceCard extends StatelessWidget {
  const _MaintenanceCard({
    required this.title,
    required this.location,
    required this.status,
    required this.statusColor,
  });

  final String title;
  final String location;
  final String status;
  final Color statusColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.build_rounded, color: statusColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                Text(
                  location,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF4F4F4F),
                      ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.14),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({
    required this.onAddProperty,
  });

  final VoidCallback onAddProperty;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0E6E6E),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Acoes rapidas',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF0E6E6E),
              ),
              onPressed: onAddProperty,
              icon: const Icon(Icons.add_home_work_rounded),
              label: const Text('Cadastrar imovel'),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Registre os detalhes e fotos do imovel. O numero de contacto do proprietario nao e preenchido aqui.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: const Color(0xFFD8F5F5),
                ),
          ),
        ],
      ),
    );
  }
}

class _InquilinoActions extends StatelessWidget {
  const _InquilinoActions({
    required this.onRequestMaintenance,
    required this.onViewContract,
  });

  final VoidCallback onRequestMaintenance;
  final VoidCallback onViewContract;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1F3D3D),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Acoes do inquilino',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 12),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF1F3D3D),
            ),
            onPressed: onRequestMaintenance,
            child: const Text('Solicitar manutencao'),
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.white),
            ),
            onPressed: onViewContract,
            child: const Text('Ver meu contrato'),
          ),
        ],
      ),
    );
  }
}

class PropertyFormScreen extends StatefulWidget {
  const PropertyFormScreen({super.key, required this.owner});

  final UserProfile owner;

  @override
  State<PropertyFormScreen> createState() => _PropertyFormScreenState();
}

class _PropertyFormScreenState extends State<PropertyFormScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _rentController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  bool _loading = false;
  String _selectedType = _propertyTypeOptions.first;
  int _bedrooms = 1;
  List<XFile> _facadePhotos = [];
  List<XFile> _interiorPhotos = [];

  static const List<String> _propertyTypeOptions = [
    'Casa familiar',
    'Casa de praia',
    'Apartamento',
    'Vivenda',
    'Studio',
    'Loja',
    'Escritorio',
    'Terreno',
  ];

  static const List<String> _bedroomsOptions = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _rentController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickFacadePhotos() async {
    final picked = await _imagePicker.pickMultiImage(
      imageQuality: 85,
      maxWidth: 1800,
    );
    if (!mounted || picked.isEmpty) {
      return;
    }
    setState(() {
      _facadePhotos = picked;
    });
  }

  Future<void> _pickInteriorPhotos() async {
    final picked = await _imagePicker.pickMultiImage(
      imageQuality: 85,
      maxWidth: 1800,
    );
    if (!mounted || picked.isEmpty) {
      return;
    }
    setState(() {
      _interiorPhotos = picked;
    });
  }

  String _extractCity(String address) {
    final parts = address
        .split(',')
        .map((part) => part.trim())
        .where((part) => part.isNotEmpty)
        .toList(growable: false);
    if (parts.isEmpty) {
      return 'Maputo';
    }
    return parts.last;
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    final address = _addressController.text.trim();
    final rent = _rentController.text.trim();
    final description = _descriptionController.text.trim();
    final allPhotos = [..._facadePhotos, ..._interiorPhotos];

    if (name.isEmpty || address.isEmpty || rent.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha os campos obrigatorios.')),
      );
      return;
    }

    if (allPhotos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Adicione pelo menos uma foto do imovel.')),
      );
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      final created = await BackendService.instance._createProperty(
        ownerId: widget.owner.id,
        name: name,
        propertyType: _selectedType,
        bedrooms: _bedrooms,
        address: address,
        rent: rent,
        description: description,
        photos: allPhotos,
      );
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Imovel salvo com sucesso.')),
      );
      Navigator.of(context).pop(created);
    } on AuthException catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro inesperado ao salvar imovel.')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ownerCity = _extractCity(_addressController.text.trim());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar imovel'),
        actions: const [_LogoutAppBarAction()],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F2FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Imoveis novos entram automaticamente como Disponivel e so mudam de estado quando houver arrendamento.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF274060),
                  ),
            ),
          ),
          const SizedBox(height: 16),
          _TextField(
            label: 'Nome do imovel',
            hint: 'Ex: Casa Sol do Mar',
            controller: _nameController,
          ),
          const SizedBox(height: 16),
          _DropdownField(
            label: 'Tipo de imovel',
            items: _propertyTypeOptions,
            value: _selectedType,
            onChanged: (value) {
              if (value == null) {
                return;
              }
              setState(() {
                _selectedType = value;
              });
            },
          ),
          const SizedBox(height: 16),
          _DropdownField(
            label: 'Quantidade de quartos',
            items: _bedroomsOptions,
            value: _bedrooms.toString(),
            onChanged: (value) {
              final parsed = int.tryParse(value ?? '');
              if (parsed == null) {
                return;
              }
              setState(() {
                _bedrooms = parsed;
              });
            },
          ),
          const SizedBox(height: 16),
          _TextField(
            label: 'Endereco',
            hint: 'Rua, bairro, cidade',
            controller: _addressController,
          ),
          const SizedBox(height: 16),
          _TextField(
            label: 'Valor da renda (MT)',
            hint: '45000',
            controller: _rentController,
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Estado',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F4F4),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  'Disponivel (automatico)',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF4F4F4F),
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _TextField(
            label: 'Descricao',
            hint: 'Informacoes adicionais do imovel',
            controller: _descriptionController,
          ),
          const SizedBox(height: 16),
          _PhotoUploadTile(
            title: 'Fotos da fachada',
            subtitle: 'Adicione a foto principal do exterior do imovel.',
            count: _facadePhotos.length,
            onPressed: _pickFacadePhotos,
          ),
          if (_facadePhotos.isNotEmpty) ...[
            const SizedBox(height: 8),
            _SelectedPhotoPreview(photos: _facadePhotos),
          ],
          const SizedBox(height: 12),
          _PhotoUploadTile(
            title: 'Fotos internas',
            subtitle: 'Adicione sala, quartos, cozinha e wc.',
            count: _interiorPhotos.length,
            onPressed: _pickInteriorPhotos,
          ),
          if (_interiorPhotos.isNotEmpty) ...[
            const SizedBox(height: 8),
            _SelectedPhotoPreview(photos: _interiorPhotos),
          ],
          const SizedBox(height: 24),
          _ZimoLoadingFilledButton(
            onPressed: _submit,
            loading: _loading,
            label: 'Salvar imovel',
            loadingLabel: 'A processar...',
          ),
          const SizedBox(height: 10),
          Text(
            'Cidade detectada para o cadastro: $ownerCity',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: const Color(0xFF4F4F4F),
                ),
          ),
        ],
      ),
    );
  }
}

class TenantFormScreen extends StatelessWidget {
  const TenantFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar inquilino'),
        actions: const [_LogoutAppBarAction()],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const _TextField(
            label: 'Nome completo',
            hint: 'Nome do inquilino',
          ),
          const SizedBox(height: 16),
          const _TextField(
            label: 'Email',
            hint: 'inquilino@email.com',
          ),
          const SizedBox(height: 16),
          const _TextField(
            label: 'Telefone',
            hint: '+258 84 000 0000',
          ),
          const SizedBox(height: 16),
          const _DropdownField(
            label: 'Imovel associado',
            items: ['Edificio Maputo View', 'Residencial Lumina', 'Outro'],
          ),
          const SizedBox(height: 16),
          const _TextField(
            label: 'Documento (BI/NIF)',
            hint: 'Numero do documento',
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () {},
            child: const Text('Salvar inquilino'),
          ),
        ],
      ),
    );
  }
}

class ContractFormScreen extends StatelessWidget {
  const ContractFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar contrato'),
        actions: const [_LogoutAppBarAction()],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const _DropdownField(
            label: 'Imovel',
            items: ['Edificio Maputo View', 'Residencial Lumina'],
          ),
          const SizedBox(height: 16),
          const _DropdownField(
            label: 'Inquilino',
            items: ['Ana Mabote', 'Carlos Langa', 'Outro'],
          ),
          const SizedBox(height: 16),
          const _TextField(
            label: 'Inicio',
            hint: '01/03/2026',
          ),
          const SizedBox(height: 16),
          const _TextField(
            label: 'Fim',
            hint: '01/03/2027',
          ),
          const SizedBox(height: 16),
          const _TextField(
            label: 'Valor mensal (MT)',
            hint: '45.000',
          ),
          const SizedBox(height: 16),
          const _TextField(
            label: 'Documento do contrato',
            hint: 'Upload do PDF (futuro)',
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () {},
            child: const Text('Salvar contrato'),
          ),
        ],
      ),
    );
  }
}

class _PhotoUploadTile extends StatelessWidget {
  const _PhotoUploadTile({
    required this.title,
    required this.subtitle,
    required this.count,
    required this.onPressed,
  });

  final String title;
  final String subtitle;
  final int count;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFD9E3E3)),
      ),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF0E6E6E).withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.photo_library_outlined,
              color: Color(0xFF0E6E6E),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF4F4F4F),
                      ),
                ),
              ],
            ),
          ),
          TextButton.icon(
            onPressed: onPressed,
            icon: const Icon(Icons.add_photo_alternate_outlined),
            label: Text(count > 0 ? 'Alterar ($count)' : 'Adicionar'),
          ),
        ],
      ),
    );
  }
}

class _SelectedPhotoPreview extends StatelessWidget {
  const _SelectedPhotoPreview({required this.photos});

  final List<XFile> photos;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 72,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: photos.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final photo = photos[index];
          return ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.file(
              File(photo.path),
              width: 72,
              height: 72,
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  const _DropdownField({
    required this.label,
    required this.items,
    this.value,
    this.onChanged,
  });

  final String label;
  final List<String> items;
  final String? value;
  final ValueChanged<String?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value ?? items.first,
          items: items
              .map(
                (item) => DropdownMenuItem(
                  value: item,
                  child: Text(item),
                ),
              )
              .toList(),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
