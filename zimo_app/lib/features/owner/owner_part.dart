part of '../../app/zimo_app.dart';

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
  List<OwnerProperty> _properties = const [];

  @override
  void initState() {
    super.initState();
    _loadOwnerProperties();
  }

  Future<void> _loadOwnerProperties() async {
    try {
      final items =
          await BackendService.instance.fetchOwnerProperties(widget.ownerId);
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
        _properties = List<OwnerProperty>.from(_ownerProperties);
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _loading = false;
        _error = 'Nao foi possivel carregar os imoveis.';
        _properties = List<OwnerProperty>.from(_ownerProperties);
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

  String _title(BuildContext context) {
    final strings = l10n(context);
    switch (widget.role) {
      case UserRole.proprietario:
        return strings.registerOwnerTitle;
      case UserRole.inquilino:
        return strings.registerTenantTitle;
      case UserRole.admin:
        return strings.registerTitle;
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
    final strings = l10n(context);
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
        SnackBar(content: Text(strings.fillAllFields)),
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
    final strings = l10n(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(_title(context)),
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
                    l10n(context).accountType(roleLabel(context, widget.role)),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          const SizedBox(height: 16),
          _TextField(
            label: strings.fullNameLabel,
            hint: strings.yourNameHint,
            controller: _nameController,
          ),
          const SizedBox(height: 16),
          _TextField(
            label: strings.addressLabel,
            hint: strings.addressHint,
            controller: _addressController,
          ),
          const SizedBox(height: 16),
          _TextField(
            label: strings.contactLabel,
            hint: strings.phoneHint,
            controller: _phoneController,
          ),
          const SizedBox(height: 16),
          _TextField(
            label: strings.emailLabel,
            hint: strings.emailHint,
            controller: _emailController,
          ),
          const SizedBox(height: 16),
          _TextField(
            label: strings.documentLabel,
            hint: strings.documentHint,
            controller: _documentController,
          ),
          const SizedBox(height: 16),
          _TextField(
            label: strings.passwordLabel,
            hint: strings.passwordHint,
            obscure: true,
            controller: _passwordController,
          ),
          const SizedBox(height: 24),
          _ZimoLoadingFilledButton(
            onPressed: _submit,
            loading: _loading,
            label: strings.createAccount,
            loadingLabel: strings.processing,
          ),
          const SizedBox(height: 10),
          Text(
            strings.registerInfo,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: const Color(0xFF4F4F4F),
                ),
          ),
        ],
      ),
    );
  }
}

