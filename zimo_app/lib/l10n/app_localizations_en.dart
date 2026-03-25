// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'ZIMO';

  @override
  String get poweredByCetus => 'Powered by Cetus Technologys';

  @override
  String get logoutTitle => 'End session';

  @override
  String get logoutMessage => 'Do you really want to log out?';

  @override
  String get cancel => 'Cancel';

  @override
  String get logout => 'Log out';

  @override
  String get roleAdmin => 'Admin';

  @override
  String get roleOwner => 'Owner';

  @override
  String get roleTenant => 'Tenant';

  @override
  String accountType(Object role) {
    return 'Account type: $role';
  }

  @override
  String userEmailWithRole(Object role, Object email) {
    return '$role - $email';
  }

  @override
  String get welcomeHeadline =>
      'Rent without middlemen and find your next home faster.';

  @override
  String get welcomeSubtitle =>
      'ZIMO connects owners and tenants in a simple, direct, and secure process.';

  @override
  String get welcomeStartTitle => 'Get started in under 2 minutes';

  @override
  String get welcomeStartSubtitle =>
      'Choose your profile and quickly access the main features.';

  @override
  String get welcomeFeaturePropertiesTitle => 'Properties under control';

  @override
  String get welcomeFeaturePropertiesSubtitle =>
      'Status, rent, photos, and documents.';

  @override
  String get welcomeFeaturePaymentsTitle => 'Clear payments';

  @override
  String get welcomeFeaturePaymentsSubtitle => 'Late alerts and full history.';

  @override
  String get welcomeFeatureMaintenanceTitle => 'Organized maintenance';

  @override
  String get welcomeFeatureMaintenanceSubtitle =>
      'Requests, approvals, and technicians.';

  @override
  String get quickAccess => 'Quick access';

  @override
  String get getStarted => 'Get started';

  @override
  String get alreadyHaveAccount => 'I already have an account';

  @override
  String get userTypeTitle => 'User type';

  @override
  String get roleSelectQuestion => 'How will you use ZIMO?';

  @override
  String get roleSelectSubtitle =>
      'This helps personalize the dashboard and permissions.';

  @override
  String get ownerRoleTitle => 'Owner';

  @override
  String get ownerRoleSubtitle => 'Manage properties, contracts, and rent.';

  @override
  String get tenantRoleTitle => 'Tenant';

  @override
  String get tenantRoleSubtitle =>
      'Payments, contract, and maintenance requests.';

  @override
  String get continueAction => 'Continue';

  @override
  String get loginTitle => 'Sign in';

  @override
  String get welcomeBack => 'Welcome back';

  @override
  String get loginInstructions => 'Use your email and password to continue.';

  @override
  String get emailLabel => 'Email';

  @override
  String get emailHint => 'example@zimo.co.mz';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordHint => '********';

  @override
  String get hidePassword => 'Hide password';

  @override
  String get showPassword => 'Show password';

  @override
  String get rememberMe => 'Remember me';

  @override
  String get forgotPassword => 'Forgot password';

  @override
  String get processing => 'Processing...';

  @override
  String get informEmailAndPassword => 'Enter your email and password.';

  @override
  String get backendConnectionError => 'Error connecting to the backend.';

  @override
  String get accountNotFound => 'Account not found.';

  @override
  String get fillNamePhoneAddress => 'Fill in name, phone, and address.';

  @override
  String get profileSettingsTitle => 'Profile settings';

  @override
  String get changePhoto => 'Change photo';

  @override
  String get nameLabel => 'Name';

  @override
  String get yourNameHint => 'Your name';

  @override
  String get phoneLabel => 'Phone';

  @override
  String get phoneHint => '+258 84 000 0000';

  @override
  String get addressLabel => 'Address';

  @override
  String get addressHint => 'Street, neighborhood, city';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get registerOwnerTitle => 'Create owner account';

  @override
  String get registerTenantTitle => 'Create tenant account';

  @override
  String get registerTitle => 'Create account';

  @override
  String get fillAllFields => 'Fill in all fields.';

  @override
  String get fullNameLabel => 'Full name';

  @override
  String get contactLabel => 'Contact';

  @override
  String get documentLabel => 'Document (ID/TIN)';

  @override
  String get documentHint => 'Document number';

  @override
  String get createAccount => 'Create account';

  @override
  String get registerInfo =>
      'The data is required and will be sent to the database during backend integration.';

  @override
  String get propertyFormTitle => 'Register property';

  @override
  String get newPropertyAutoStatusInfo =>
      'New properties are automatically marked as Available and only change status when rented.';

  @override
  String get propertyNameLabel => 'Property name';

  @override
  String get propertyNameHint => 'Example: Casa Sol do Mar';

  @override
  String get propertyTypeLabel => 'Property type';

  @override
  String get bedroomCountLabel => 'Number of bedrooms';

  @override
  String get rentValueLabel => 'Rent amount (MT)';

  @override
  String get rentValueHint => '45000';

  @override
  String get statusLabel => 'Status';

  @override
  String get propertyAvailableAutomatic => 'Available (automatic)';

  @override
  String get descriptionLabel => 'Description';

  @override
  String get propertyDescriptionHint => 'Additional property information';

  @override
  String get facadePhotosTitle => 'Facade photos';

  @override
  String get facadePhotosSubtitle =>
      'Add the main exterior photo of the property.';

  @override
  String get interiorPhotosTitle => 'Interior photos';

  @override
  String get interiorPhotosSubtitle =>
      'Add living room, bedrooms, kitchen, and bathroom.';

  @override
  String get saveProperty => 'Save property';

  @override
  String detectedCity(Object city) {
    return 'Detected city for registration: $city';
  }

  @override
  String get tenantFormTitle => 'Register tenant';

  @override
  String get tenantNameHint => 'Tenant name';

  @override
  String get associatedPropertyLabel => 'Associated property';

  @override
  String get saveTenant => 'Save tenant';

  @override
  String get contractFormTitle => 'Create contract';

  @override
  String get propertyLabel => 'Property';

  @override
  String get tenantLabel => 'Tenant';

  @override
  String get startLabel => 'Start';

  @override
  String get endLabel => 'End';

  @override
  String get monthlyValueLabel => 'Monthly amount (MT)';

  @override
  String get monthlyValueHint => '45.000';

  @override
  String get contractDocumentLabel => 'Contract document';

  @override
  String get contractDocumentHint => 'PDF upload (future)';

  @override
  String get saveContract => 'Save contract';

  @override
  String changePhotos(Object count) {
    return 'Change ($count)';
  }

  @override
  String get add => 'Add';

  @override
  String get dashboardTitle => 'ZIMO Dashboard';

  @override
  String get chatTooltip => 'Chat';

  @override
  String get homeNav => 'Home';

  @override
  String get propertiesNav => 'properties';

  @override
  String get paymentsNav => 'Payments';

  @override
  String get maintenanceNav => 'Maintenance';

  @override
  String get exploreNav => 'Explore';

  @override
  String get propertyUnavailableNow =>
      'This property is not available right now.';

  @override
  String reservationStartedVia(Object paymentMethod) {
    return 'Reservation and payment started via $paymentMethod.';
  }

  @override
  String get reserveAndPay => 'Reserve and pay';

  @override
  String get dayLabel => 'Day';

  @override
  String get monthLabel => 'Month';

  @override
  String get filterPeriodLabel => 'Filter period';

  @override
  String get fillMaintenanceFields => 'Fill in the maintenance fields.';

  @override
  String get maintenanceRequestSent => 'Maintenance request sent.';

  @override
  String get problemTitleLabel => 'Problem title';

  @override
  String get problemTitleHint => 'Example: Water leak';

  @override
  String get problemDescriptionHint => 'Describe the problem';

  @override
  String get requestMaintenance => 'Request maintenance';

  @override
  String get openTechnicalChat => 'Open technical chat';

  @override
  String get quickActionsTitle => 'Quick actions';

  @override
  String get quickActionsSubtitle =>
      'Register the property details and photos. The owner\'s contact number is not filled in here.';

  @override
  String get tenantActionsTitle => 'Tenant actions';

  @override
  String get requestMaintenanceShort => 'Request maintenance';

  @override
  String get viewMyContract => 'View my contract';

  @override
  String get kpiTotalProperties => 'Total properties';

  @override
  String get kpiReceivedRent => 'Received rent';

  @override
  String get kpiLateRent => 'Late rent';

  @override
  String get kpiActiveAlerts => 'Active alerts';

  @override
  String get addAtLeastOnePropertyPhoto => 'Add at least one property photo.';

  @override
  String get filterPropertiesTitle => 'Filter properties';

  @override
  String get typeLabel => 'Type';

  @override
  String get locationLabel => 'Location';

  @override
  String get locationHint => 'City or neighborhood';

  @override
  String get applyFilter => 'Apply filter';

  @override
  String get tenantEmailHint => 'tenant@email.com';

  @override
  String get contractStartHint => '03/01/2026';

  @override
  String get contractEndHint => '03/01/2027';

  @override
  String get adminDashboardTitle => 'Admin Dashboard';

  @override
  String get adminControlCenter => 'Control center';

  @override
  String get adminSupervisionSubtitle =>
      'User, upload, and risk signal supervision.';

  @override
  String get adminMysqlLoadFailure => 'Failed to load users from MySQL.';

  @override
  String get noUsersRegisteredYet => 'No registered users yet.';

  @override
  String get quickSummary => 'Quick summary';

  @override
  String get adminUsersLabel => 'Users';

  @override
  String get adminsLabel => 'Admins';

  @override
  String get riskyUploadsLabel => 'Risky uploads';

  @override
  String get openAlertsLabel => 'Open alerts';

  @override
  String get needsAttentionNow => 'Needs attention now';

  @override
  String get recentUsers => 'Recent users';

  @override
  String get viewAllUsers => 'View all users';

  @override
  String get systemUsersTitle => 'System users';

  @override
  String get searchUsersHint => 'Search by name, email, or document';

  @override
  String get filtersTitle => 'Filters';

  @override
  String get clear => 'Clear';

  @override
  String get allLabel => 'All';

  @override
  String get activeLabel => 'Active';

  @override
  String get suspendedLabel => 'Suspended';

  @override
  String resultsCount(Object count) {
    return '$count result(s)';
  }

  @override
  String get noUsersForSelectedFilters => 'No users for the selected filters.';

  @override
  String accountSuspendedMessage(Object name) {
    return 'Account for $name suspended.';
  }

  @override
  String accountReactivatedMessage(Object name) {
    return 'Account for $name reactivated.';
  }

  @override
  String passwordResetLinkSent(Object email) {
    return 'Reset link sent to $email.';
  }

  @override
  String historyOpenedMessage(Object name) {
    return 'History for $name opened.';
  }

  @override
  String get usersLoadError => 'Could not load users.';

  @override
  String get noPendingAlerts => 'No pending alerts.';

  @override
  String get suspendedAccount => 'Suspend account';

  @override
  String get reactivateAccount => 'Reactivate account';

  @override
  String get resetPassword => 'Reset password';

  @override
  String get viewHistory => 'View history';

  @override
  String get uploadMonitorTitle => 'Upload monitor';

  @override
  String get uploadMonitorSubtitle =>
      'Track uploaded files and identify suspicious documents.';

  @override
  String get searchUploadHint => 'Search by user or file';

  @override
  String get showOnlyRiskUploads => 'Show only risky uploads';

  @override
  String uploadsFound(Object count) {
    return '$count upload(s) found';
  }

  @override
  String get riskCenterTitle => 'Risk center';

  @override
  String get riskCenterSubtitle =>
      'Monitor unusual activity and resolve alerts quickly.';

  @override
  String get resolvedAlertsLabel => 'Resolved alerts';

  @override
  String get openAlertsSection => 'Open';

  @override
  String get markAsResolved => 'Mark as resolved';

  @override
  String get adminActionsTitle => 'Admin actions';

  @override
  String get viewUsers => 'View users';

  @override
  String get monitorUploads => 'Monitor uploads';

  @override
  String get suspiciousBehaviors => 'Suspicious behavior';

  @override
  String get availablePropertiesTitle => 'Available properties';

  @override
  String get availablePropertiesSubtitle =>
      'Search, filter, and review properties to rent without middlemen.';
}
