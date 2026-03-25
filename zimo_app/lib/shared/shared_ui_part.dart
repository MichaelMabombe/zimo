part of '../app/zimo_app.dart';

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
              color: const Color(0xFF0E6E6E).withValues(alpha: 0.1),
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
                backgroundColor: const Color(0xFF0E6E6E).withValues(
                  alpha: 0.1,
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

// ignore: unused_element
class _DashboardKpiGrid extends StatelessWidget {
  const _DashboardKpiGrid();

  @override
  Widget build(BuildContext context) {
    final strings = l10n(context);
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _KpiCard(
          label: strings.kpiTotalProperties,
          value: '12',
          accent: const Color(0xFF0E6E6E),
        ),
        _KpiCard(
          label: strings.kpiReceivedRent,
          value: '420.000 MT',
          accent: const Color(0xFFB6452C),
        ),
        _KpiCard(
          label: strings.kpiLateRent,
          value: '3',
          accent: const Color(0xFFB3261E),
        ),
        _KpiCard(
          label: strings.kpiActiveAlerts,
          value: '5',
          accent: const Color(0xFF7A5C2E),
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
            color: Colors.black.withValues(alpha: 0.04),
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
            color: Colors.black.withValues(alpha: 0.04),
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
              color: statusColor.withValues(alpha: 0.12),
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
              color: statusColor.withValues(alpha: 0.12),
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
              color: statusColor.withValues(alpha: 0.14),
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
    final strings = l10n(context);
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
            strings.quickActionsTitle,
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
              label: Text(strings.propertyFormTitle),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            strings.quickActionsSubtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: const Color(0xFFD8F5F5),
                ),
          ),
        ],
      ),
    );
  }
}

// ignore: unused_element
class _InquilinoActions extends StatelessWidget {
  const _InquilinoActions({
    required this.onRequestMaintenance,
    required this.onViewContract,
  });

  final VoidCallback onRequestMaintenance;
  final VoidCallback onViewContract;

  @override
  Widget build(BuildContext context) {
    final strings = l10n(context);
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
            strings.tenantActionsTitle,
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
            child: Text(strings.requestMaintenanceShort),
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.white),
            ),
            onPressed: onViewContract,
            child: Text(strings.viewMyContract),
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
    final strings = l10n(context);
    final name = _nameController.text.trim();
    final address = _addressController.text.trim();
    final rent = _rentController.text.trim();
    final description = _descriptionController.text.trim();
    final allPhotos = [..._facadePhotos, ..._interiorPhotos];

    if (name.isEmpty || address.isEmpty || rent.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(strings.fillAllFields)),
      );
      return;
    }

    if (allPhotos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(strings.addAtLeastOnePropertyPhoto)),
      );
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      final created = await BackendService.instance.createProperty(
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
        SnackBar(content: Text(strings.saveProperty)),
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
        SnackBar(content: Text(strings.backendConnectionError)),
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
    final strings = l10n(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.propertyFormTitle),
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
              strings.newPropertyAutoStatusInfo,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF274060),
                  ),
            ),
          ),
          const SizedBox(height: 16),
          _TextField(
            label: strings.propertyNameLabel,
            hint: strings.propertyNameHint,
            controller: _nameController,
          ),
          const SizedBox(height: 16),
          _DropdownField(
            label: strings.propertyTypeLabel,
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
            label: strings.bedroomCountLabel,
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
            label: strings.addressLabel,
            hint: strings.addressHint,
            controller: _addressController,
          ),
          const SizedBox(height: 16),
          _TextField(
            label: strings.rentValueLabel,
            hint: strings.rentValueHint,
            controller: _rentController,
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                strings.statusLabel,
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
                  strings.propertyAvailableAutomatic,
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
            label: strings.descriptionLabel,
            hint: strings.propertyDescriptionHint,
            controller: _descriptionController,
          ),
          const SizedBox(height: 16),
          _PhotoUploadTile(
            title: strings.facadePhotosTitle,
            subtitle: strings.facadePhotosSubtitle,
            count: _facadePhotos.length,
            onPressed: _pickFacadePhotos,
          ),
          if (_facadePhotos.isNotEmpty) ...[
            const SizedBox(height: 8),
            _SelectedPhotoPreview(photos: _facadePhotos),
          ],
          const SizedBox(height: 12),
          _PhotoUploadTile(
            title: strings.interiorPhotosTitle,
            subtitle: strings.interiorPhotosSubtitle,
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
            label: strings.saveProperty,
            loadingLabel: strings.processing,
          ),
          const SizedBox(height: 10),
          Text(
            strings.detectedCity(ownerCity),
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
    final strings = l10n(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.tenantFormTitle),
        actions: const [_LogoutAppBarAction()],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _TextField(
            label: strings.fullNameLabel,
            hint: strings.tenantNameHint,
          ),
          const SizedBox(height: 16),
          _TextField(
            label: strings.emailLabel,
            hint: strings.tenantEmailHint,
          ),
          const SizedBox(height: 16),
          _TextField(
            label: strings.phoneLabel,
            hint: strings.phoneHint,
          ),
          const SizedBox(height: 16),
          _DropdownField(
            label: strings.associatedPropertyLabel,
            items: ['Edificio Maputo View', 'Residencial Lumina', 'Outro'],
          ),
          const SizedBox(height: 16),
          _TextField(
            label: strings.documentLabel,
            hint: strings.documentHint,
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () {},
            child: Text(strings.saveTenant),
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
    final strings = l10n(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.contractFormTitle),
        actions: const [_LogoutAppBarAction()],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _DropdownField(
            label: strings.propertyLabel,
            items: ['Edificio Maputo View', 'Residencial Lumina'],
          ),
          const SizedBox(height: 16),
          _DropdownField(
            label: strings.tenantLabel,
            items: ['Ana Mabote', 'Carlos Langa', 'Outro'],
          ),
          const SizedBox(height: 16),
          _TextField(
            label: strings.startLabel,
            hint: strings.contractStartHint,
          ),
          const SizedBox(height: 16),
          _TextField(
            label: strings.endLabel,
            hint: strings.contractEndHint,
          ),
          const SizedBox(height: 16),
          _TextField(
            label: strings.monthlyValueLabel,
            hint: strings.monthlyValueHint,
          ),
          const SizedBox(height: 16),
          _TextField(
            label: strings.contractDocumentLabel,
            hint: strings.contractDocumentHint,
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () {},
            child: Text(strings.saveContract),
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
    final strings = l10n(context);
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
              color: const Color(0xFF0E6E6E).withValues(alpha: 0.12),
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
            label: Text(count > 0 ? strings.changePhotos(count) : strings.add),
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
          initialValue: value ?? items.first,
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
