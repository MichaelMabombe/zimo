part of '../../app/zimo_app.dart';

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
    final strings = l10n(context);
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final address = _addressController.text.trim();
    if (name.isEmpty || phone.isEmpty || address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(strings.fillNamePhoneAddress)),
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
    final strings = l10n(context);
    return Scaffold(
      appBar: AppBar(title: Text(strings.profileSettingsTitle)),
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
                  label: Text(strings.changePhoto),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _TextField(
            label: strings.nameLabel,
            hint: strings.yourNameHint,
            controller: _nameController,
          ),
          const SizedBox(height: 12),
          _TextField(
            label: strings.phoneLabel,
            hint: strings.phoneHint,
            controller: _phoneController,
          ),
          const SizedBox(height: 12),
          _TextField(
            label: strings.addressLabel,
            hint: strings.addressHint,
            controller: _addressController,
          ),
          const SizedBox(height: 16),
          _ZimoLoadingFilledButton(
            onPressed: _saveProfile,
            loading: _loading,
            label: strings.saveChanges,
            loadingLabel: strings.processing,
          ),
        ],
      ),
    );
  }
}

