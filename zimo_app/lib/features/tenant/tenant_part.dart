part of '../../app/zimo_app.dart';

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
  List<OwnerProperty> _properties = const [];
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
      final items = await BackendService.instance.fetchAvailableProperties(
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
    final strings = l10n(context);
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
                    strings.filterPropertiesTitle,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 12),
                  _DropdownField(
                    label: strings.typeLabel,
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
                    label: strings.locationLabel,
                    hint: strings.locationHint,
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
                    label: strings.applyFilter,
                    loadingLabel: strings.processing,
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
    final strings = l10n(context);
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
          strings.availablePropertiesTitle,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 6),
        Text(
          strings.availablePropertiesSubtitle,
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

  final OwnerProperty property;
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
                          color: ownerPropertyStatusColor(property.status),
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
  final OwnerProperty property;

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
    final strings = l10n(context);
    if (widget.property.status.toLowerCase() != 'disponivel') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(strings.propertyUnavailableNow)),
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
      SnackBar(content: Text(strings.reservationStartedVia(_paymentMethod))),
    );
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final property = widget.property;
    final strings = l10n(context);
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
                  color: ownerPropertyStatusColor(property.status),
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
            label: strings.reserveAndPay,
            loadingLabel: strings.processing,
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
            statusColor: ownerPropertyStatusColor(item.status),
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
    final strings = l10n(context);
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
              label: Text(strings.dayLabel),
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
              label: Text(strings.monthLabel),
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
          label: strings.filterPeriodLabel,
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
    final strings = l10n(context);
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    final property = _propertyController.text.trim();
    if (title.isEmpty || description.isEmpty || property.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(strings.fillMaintenanceFields)),
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
      SnackBar(content: Text(strings.maintenanceRequestSent)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = l10n(context);
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
          label: strings.propertyLabel,
          hint: strings.propertyNameLabel,
          controller: _propertyController,
        ),
        const SizedBox(height: 12),
        _TextField(
          label: strings.problemTitleLabel,
          hint: strings.problemTitleHint,
          controller: _titleController,
        ),
        const SizedBox(height: 12),
        _TextField(
          label: strings.descriptionLabel,
          hint: strings.problemDescriptionHint,
          controller: _descriptionController,
        ),
        const SizedBox(height: 12),
        _ZimoLoadingFilledButton(
          onPressed: _submitRequest,
          loading: false,
          label: strings.requestMaintenance,
          loadingLabel: strings.processing,
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
          label: Text(strings.openTechnicalChat),
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

