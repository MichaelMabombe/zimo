import 'dart:async';
import 'dart:io' show File;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:image_picker/image_picker.dart';

import '../application/state/zimo_store.dart';
import '../data/exceptions/auth_exception.dart';
import '../data/services/backend_service.dart';
import '../domain/entities/owner_property.dart';
import '../domain/entities/user_profile.dart';
import '../domain/entities/user_role.dart';
import '../l10n/app_localizations.dart';

part '../core/app_core_part.dart';
part '../features/auth/auth_part.dart';
part '../features/dashboard/dashboard_shell_part.dart';
part '../features/tenant/tenant_part.dart';
part '../features/profile/profile_part.dart';
part '../features/owner/owner_part.dart';
part '../features/admin/admin_part.dart';
part '../shared/shared_ui_part.dart';
