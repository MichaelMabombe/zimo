part of '../../app/zimo_app.dart';

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
    final strings = l10n(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.dashboardTitle),
        actions: [
          IconButton(
            tooltip: strings.chatTooltip,
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
                        await Navigator.of(context).push<OwnerProperty>(
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
            ? [
                NavigationDestination(
                    icon: const Icon(Icons.grid_view_rounded),
                    label: strings.homeNav),
                NavigationDestination(
                    icon: const Icon(Icons.apartment_rounded),
                    label: strings.propertiesNav),
                NavigationDestination(
                    icon: const Icon(Icons.receipt_long_rounded),
                    label: strings.paymentsNav),
                NavigationDestination(
                    icon: const Icon(Icons.build_rounded),
                    label: strings.maintenanceNav),
              ]
            : isInquilino
                ? [
                    NavigationDestination(
                        icon: const Icon(Icons.travel_explore_rounded),
                        label: strings.exploreNav),
                    NavigationDestination(
                        icon: const Icon(Icons.bookmark_rounded),
                        label: strings.propertiesNav),
                    NavigationDestination(
                        icon: const Icon(Icons.account_balance_wallet_rounded),
                        label: strings.paymentsNav),
                    NavigationDestination(
                        icon: const Icon(Icons.build_rounded),
                        label: strings.maintenanceNav),
                  ]
                : [
                    NavigationDestination(
                        icon: const Icon(Icons.grid_view_rounded),
                        label: strings.homeNav),
                    NavigationDestination(
                        icon: const Icon(Icons.apartment_rounded),
                        label: strings.propertiesNav),
                    NavigationDestination(
                        icon: const Icon(Icons.receipt_long_rounded),
                        label: strings.paymentsNav),
                    NavigationDestination(
                        icon: const Icon(Icons.build_rounded),
                        label: strings.maintenanceNav),
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

