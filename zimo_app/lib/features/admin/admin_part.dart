part of '../../app/zimo_app.dart';

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
    final strings = l10n(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.adminDashboardTitle),
        actions: const [_LogoutAppBarAction()],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            strings.adminControlCenter,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            strings.adminSupervisionSubtitle,
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
                  strings.adminMysqlLoadFailure,
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
                  strings.noUsersRegisteredYet,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF4F4F4F),
                      ),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    strings.quickSummary,
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
                        label: strings.adminUsersLabel,
                        value: '${users.length}',
                        accent: const Color(0xFF0E6E6E),
                      ),
                      _AdminSummaryCard(
                        label: strings.adminsLabel,
                        value: '$adminCount',
                        accent: const Color(0xFF7A5C2E),
                      ),
                      _AdminSummaryCard(
                        label: strings.ownerRoleTitle,
                        value: '$proprietarioCount',
                        accent: const Color(0xFF0E6E6E),
                      ),
                      _AdminSummaryCard(
                        label: strings.tenantRoleTitle,
                        value: '$inquilinoCount',
                        accent: const Color(0xFFB6452C),
                      ),
                      _AdminSummaryCard(
                        label: strings.riskyUploadsLabel,
                        value: '$riskUploads',
                        accent: const Color(0xFFB3261E),
                      ),
                      _AdminSummaryCard(
                        label: strings.openAlertsLabel,
                        value: '$openAlerts',
                        accent: const Color(0xFFAA3A1E),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    strings.needsAttentionNow,
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
                    strings.recentUsers,
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
                      label: Text(strings.viewAllUsers),
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
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFF0E6E6E).withValues(alpha: 0.1),
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
                      l10n(context).userEmailWithRole(
                        roleLabel(context, user.role),
                        user.email,
                      ),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF4F4F4F),
                      ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
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
    final strings = l10n(context);
    switch (value) {
      case _AdminRoleFilter.todos:
        return strings.allLabel;
      case _AdminRoleFilter.admin:
        return strings.adminsLabel;
      case _AdminRoleFilter.proprietario:
        return strings.ownerRoleTitle;
      case _AdminRoleFilter.inquilino:
        return strings.tenantRoleTitle;
    }
  }

  String _statusLabel(_AdminStatusFilter value) {
    final strings = l10n(context);
    switch (value) {
      case _AdminStatusFilter.todos:
        return strings.allLabel;
      case _AdminStatusFilter.ativos:
        return strings.activeLabel;
      case _AdminStatusFilter.suspensos:
        return strings.suspendedLabel;
    }
  }

  void _handleUserAction(UserProfile user, String action) {
    if (action == 'suspender') {
      setState(() {
        _suspendedUserIds.add(user.id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n(context).accountSuspendedMessage(user.name))),
      );
      return;
    }

    if (action == 'reativar') {
      setState(() {
        _suspendedUserIds.remove(user.id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n(context).accountReactivatedMessage(user.name))),
      );
      return;
    }

    if (action == 'senha') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n(context).passwordResetLinkSent(user.email))),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n(context).historyOpenedMessage(user.name))),
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = l10n(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.systemUsersTitle),
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
                  strings.usersLoadError,
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
                  hintText: strings.searchUsersHint,
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
                    strings.filtersTitle,
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
                    child: Text(strings.clear),
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
                strings.resultsCount(filteredUsers.length),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF4F4F4F),
                    ),
              ),
              const SizedBox(height: 10),
              if (filteredUsers.isEmpty)
                Text(
                  strings.noUsersForSelectedFilters,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF4F4F4F),
                      ),
                )
              else
                ...filteredUsers.map((user) {
                  final suspended = _suspendedUserIds.contains(user.id);
                  return _AdminUserCard(
                    user: user,
                    statusLabel: suspended
                        ? strings.suspendedLabel
                        : strings.activeLabel,
                    statusColor: suspended
                        ? const Color(0xFFB3261E)
                        : const Color(0xFF0E6E6E),
                    trailing: PopupMenuButton<String>(
                      onSelected: (action) => _handleUserAction(user, action),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: suspended ? 'reativar' : 'suspender',
                          child: Text(
                              suspended
                                  ? strings.reactivateAccount
                                  : strings.suspendedAccount),
                        ),
                        PopupMenuItem(
                          value: 'senha',
                          child: Text(strings.resetPassword),
                        ),
                        PopupMenuItem(
                          value: 'historico',
                          child: Text(strings.viewHistory),
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
    final strings = l10n(context);
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
        title: Text(strings.uploadMonitorTitle),
        actions: const [_LogoutAppBarAction()],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            strings.uploadMonitorSubtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF4F4F4F),
                ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _searchController,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: strings.searchUploadHint,
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
            title: Text(strings.showOnlyRiskUploads),
            value: _onlyFlagged,
            onChanged: (value) {
              setState(() {
                _onlyFlagged = value;
              });
            },
          ),
          const SizedBox(height: 8),
          Text(
            strings.uploadsFound(events.length),
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
                          ? const Color(0xFFB3261E).withValues(alpha: 0.12)
                          : const Color(0xFF0E6E6E).withValues(alpha: 0.12),
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
    final strings = l10n(context);
    final open =
        _events.where((event) => !event.resolved).toList(growable: false);
    final resolved =
        _events.where((event) => event.resolved).toList(growable: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.riskCenterTitle),
        actions: const [_LogoutAppBarAction()],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            strings.riskCenterSubtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF4F4F4F),
                ),
          ),
          const SizedBox(height: 14),
          _KpiCard(
            label: strings.openAlertsLabel,
            value: '${open.length}',
            accent: const Color(0xFFB3261E),
          ),
          const SizedBox(height: 12),
          _KpiCard(
            label: strings.resolvedAlertsLabel,
            value: '${resolved.length}',
            accent: const Color(0xFF0E6E6E),
          ),
          const SizedBox(height: 18),
          Text(
            strings.openAlertsSection,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 10),
          if (open.isEmpty)
            Text(strings.noPendingAlerts)
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
                            color: event.severityColor.withValues(alpha: 0.12),
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
                          child: Text(strings.markAsResolved),
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
    final strings = l10n(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            strings.adminActionsTitle,
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
              label: Text(strings.viewUsers),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onOpenUploads,
              icon: const Icon(Icons.upload_file_rounded),
              label: Text(strings.monitorUploads),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onOpenRiskCenter,
              icon: const Icon(Icons.gpp_maybe_rounded),
              label: Text(strings.suspiciousBehaviors),
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
        border: Border.all(color: accent.withValues(alpha: 0.24)),
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

final List<OwnerProperty> _ownerProperties = [
  const OwnerProperty(
    name: 'Residencial Lumina',
    propertyType: 'Apartamento',
    address: 'Av. Julius Nyerere, Maputo',
    status: 'Disponivel',
    statusColor: Color(0xFF0E6E6E),
    rent: '72.000 MT',
  ),
  const OwnerProperty(
    name: 'Maputo View',
    propertyType: 'Apartamento',
    address: 'Baixa, Maputo',
    status: 'Ocupado',
    statusColor: Color(0xFF7A5C2E),
    rent: '45.000 MT',
  ),
  const OwnerProperty(
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
  required OwnerProperty property,
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

