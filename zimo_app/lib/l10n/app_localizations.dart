import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt')
  ];

  /// No description provided for @appTitle.
  ///
  /// In pt, this message translates to:
  /// **'ZIMO'**
  String get appTitle;

  /// No description provided for @poweredByCetus.
  ///
  /// In pt, this message translates to:
  /// **'Powered by Cetus Technologys'**
  String get poweredByCetus;

  /// No description provided for @logoutTitle.
  ///
  /// In pt, this message translates to:
  /// **'Terminar sessao'**
  String get logoutTitle;

  /// No description provided for @logoutMessage.
  ///
  /// In pt, this message translates to:
  /// **'Deseja realmente fazer log out?'**
  String get logoutMessage;

  /// No description provided for @cancel.
  ///
  /// In pt, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// No description provided for @logout.
  ///
  /// In pt, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @roleAdmin.
  ///
  /// In pt, this message translates to:
  /// **'Admin'**
  String get roleAdmin;

  /// No description provided for @roleOwner.
  ///
  /// In pt, this message translates to:
  /// **'Proprietario'**
  String get roleOwner;

  /// No description provided for @roleTenant.
  ///
  /// In pt, this message translates to:
  /// **'Inquilino'**
  String get roleTenant;

  /// No description provided for @accountType.
  ///
  /// In pt, this message translates to:
  /// **'Tipo de conta: {role}'**
  String accountType(Object role);

  /// No description provided for @userEmailWithRole.
  ///
  /// In pt, this message translates to:
  /// **'{role} - {email}'**
  String userEmailWithRole(Object role, Object email);

  /// No description provided for @welcomeHeadline.
  ///
  /// In pt, this message translates to:
  /// **'Alugue sem intermediarios e encontre seu proximo lar mais rapido.'**
  String get welcomeHeadline;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'A ZIMO conecta proprietarios e inquilinos em um processo simples, direto e seguro.'**
  String get welcomeSubtitle;

  /// No description provided for @welcomeStartTitle.
  ///
  /// In pt, this message translates to:
  /// **'Comece em menos de 2 minutos'**
  String get welcomeStartTitle;

  /// No description provided for @welcomeStartSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Escolha seu perfil e acesse as funcoes principais rapidamente.'**
  String get welcomeStartSubtitle;

  /// No description provided for @welcomeFeaturePropertiesTitle.
  ///
  /// In pt, this message translates to:
  /// **'Imoveis sob controle'**
  String get welcomeFeaturePropertiesTitle;

  /// No description provided for @welcomeFeaturePropertiesSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Status, renda, fotos e documentos.'**
  String get welcomeFeaturePropertiesSubtitle;

  /// No description provided for @welcomeFeaturePaymentsTitle.
  ///
  /// In pt, this message translates to:
  /// **'Pagamentos claros'**
  String get welcomeFeaturePaymentsTitle;

  /// No description provided for @welcomeFeaturePaymentsSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Alertas de atraso e historico completo.'**
  String get welcomeFeaturePaymentsSubtitle;

  /// No description provided for @welcomeFeatureMaintenanceTitle.
  ///
  /// In pt, this message translates to:
  /// **'Manutencao organizada'**
  String get welcomeFeatureMaintenanceTitle;

  /// No description provided for @welcomeFeatureMaintenanceSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Pedidos, aprovacoes e tecnicos.'**
  String get welcomeFeatureMaintenanceSubtitle;

  /// No description provided for @quickAccess.
  ///
  /// In pt, this message translates to:
  /// **'Acesso rapido'**
  String get quickAccess;

  /// No description provided for @getStarted.
  ///
  /// In pt, this message translates to:
  /// **'Comecar'**
  String get getStarted;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In pt, this message translates to:
  /// **'Ja tenho conta'**
  String get alreadyHaveAccount;

  /// No description provided for @userTypeTitle.
  ///
  /// In pt, this message translates to:
  /// **'Tipo de usuario'**
  String get userTypeTitle;

  /// No description provided for @roleSelectQuestion.
  ///
  /// In pt, this message translates to:
  /// **'Como voce vai usar a ZIMO?'**
  String get roleSelectQuestion;

  /// No description provided for @roleSelectSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Isso ajuda a personalizar o dashboard e as permissoes.'**
  String get roleSelectSubtitle;

  /// No description provided for @ownerRoleTitle.
  ///
  /// In pt, this message translates to:
  /// **'Proprietario'**
  String get ownerRoleTitle;

  /// No description provided for @ownerRoleSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Gerencie imoveis, contratos e rendas.'**
  String get ownerRoleSubtitle;

  /// No description provided for @tenantRoleTitle.
  ///
  /// In pt, this message translates to:
  /// **'Inquilino'**
  String get tenantRoleTitle;

  /// No description provided for @tenantRoleSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Pagamentos, contrato e pedidos de manutencao.'**
  String get tenantRoleSubtitle;

  /// No description provided for @continueAction.
  ///
  /// In pt, this message translates to:
  /// **'Continuar'**
  String get continueAction;

  /// No description provided for @loginTitle.
  ///
  /// In pt, this message translates to:
  /// **'Entrar'**
  String get loginTitle;

  /// No description provided for @welcomeBack.
  ///
  /// In pt, this message translates to:
  /// **'Bem-vindo de volta'**
  String get welcomeBack;

  /// No description provided for @loginInstructions.
  ///
  /// In pt, this message translates to:
  /// **'Use seu email e senha para continuar.'**
  String get loginInstructions;

  /// No description provided for @emailLabel.
  ///
  /// In pt, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @emailHint.
  ///
  /// In pt, this message translates to:
  /// **'exemplo@zimo.co.mz'**
  String get emailHint;

  /// No description provided for @passwordLabel.
  ///
  /// In pt, this message translates to:
  /// **'Senha'**
  String get passwordLabel;

  /// No description provided for @passwordHint.
  ///
  /// In pt, this message translates to:
  /// **'********'**
  String get passwordHint;

  /// No description provided for @hidePassword.
  ///
  /// In pt, this message translates to:
  /// **'Ocultar senha'**
  String get hidePassword;

  /// No description provided for @showPassword.
  ///
  /// In pt, this message translates to:
  /// **'Ver senha'**
  String get showPassword;

  /// No description provided for @rememberMe.
  ///
  /// In pt, this message translates to:
  /// **'Lembrar-me'**
  String get rememberMe;

  /// No description provided for @forgotPassword.
  ///
  /// In pt, this message translates to:
  /// **'Esqueci a senha'**
  String get forgotPassword;

  /// No description provided for @processing.
  ///
  /// In pt, this message translates to:
  /// **'A processar...'**
  String get processing;

  /// No description provided for @informEmailAndPassword.
  ///
  /// In pt, this message translates to:
  /// **'Informe email e senha.'**
  String get informEmailAndPassword;

  /// No description provided for @backendConnectionError.
  ///
  /// In pt, this message translates to:
  /// **'Erro ao conectar com o backend.'**
  String get backendConnectionError;

  /// No description provided for @accountNotFound.
  ///
  /// In pt, this message translates to:
  /// **'Conta nao encontrada.'**
  String get accountNotFound;

  /// No description provided for @fillNamePhoneAddress.
  ///
  /// In pt, this message translates to:
  /// **'Preencha nome, telefone e endereco.'**
  String get fillNamePhoneAddress;

  /// No description provided for @profileSettingsTitle.
  ///
  /// In pt, this message translates to:
  /// **'Configuracoes do perfil'**
  String get profileSettingsTitle;

  /// No description provided for @changePhoto.
  ///
  /// In pt, this message translates to:
  /// **'Alterar foto'**
  String get changePhoto;

  /// No description provided for @nameLabel.
  ///
  /// In pt, this message translates to:
  /// **'Nome'**
  String get nameLabel;

  /// No description provided for @yourNameHint.
  ///
  /// In pt, this message translates to:
  /// **'Seu nome'**
  String get yourNameHint;

  /// No description provided for @phoneLabel.
  ///
  /// In pt, this message translates to:
  /// **'Telefone'**
  String get phoneLabel;

  /// No description provided for @phoneHint.
  ///
  /// In pt, this message translates to:
  /// **'+258 84 000 0000'**
  String get phoneHint;

  /// No description provided for @addressLabel.
  ///
  /// In pt, this message translates to:
  /// **'Endereco'**
  String get addressLabel;

  /// No description provided for @addressHint.
  ///
  /// In pt, this message translates to:
  /// **'Rua, bairro, cidade'**
  String get addressHint;

  /// No description provided for @saveChanges.
  ///
  /// In pt, this message translates to:
  /// **'Salvar alteracoes'**
  String get saveChanges;

  /// No description provided for @registerOwnerTitle.
  ///
  /// In pt, this message translates to:
  /// **'Criar conta de proprietario'**
  String get registerOwnerTitle;

  /// No description provided for @registerTenantTitle.
  ///
  /// In pt, this message translates to:
  /// **'Criar conta de inquilino'**
  String get registerTenantTitle;

  /// No description provided for @registerTitle.
  ///
  /// In pt, this message translates to:
  /// **'Criar conta'**
  String get registerTitle;

  /// No description provided for @fillAllFields.
  ///
  /// In pt, this message translates to:
  /// **'Preencha todos os campos.'**
  String get fillAllFields;

  /// No description provided for @fullNameLabel.
  ///
  /// In pt, this message translates to:
  /// **'Nome completo'**
  String get fullNameLabel;

  /// No description provided for @contactLabel.
  ///
  /// In pt, this message translates to:
  /// **'Contacto'**
  String get contactLabel;

  /// No description provided for @documentLabel.
  ///
  /// In pt, this message translates to:
  /// **'Documento (BI/NIF)'**
  String get documentLabel;

  /// No description provided for @documentHint.
  ///
  /// In pt, this message translates to:
  /// **'Numero do documento'**
  String get documentHint;

  /// No description provided for @createAccount.
  ///
  /// In pt, this message translates to:
  /// **'Criar conta'**
  String get createAccount;

  /// No description provided for @registerInfo.
  ///
  /// In pt, this message translates to:
  /// **'Os dados sao obrigatorios e serao enviados para a base de dados na integracao do backend.'**
  String get registerInfo;

  /// No description provided for @propertyFormTitle.
  ///
  /// In pt, this message translates to:
  /// **'Cadastrar imovel'**
  String get propertyFormTitle;

  /// No description provided for @newPropertyAutoStatusInfo.
  ///
  /// In pt, this message translates to:
  /// **'Imoveis novos entram automaticamente como Disponivel e so mudam de estado quando houver arrendamento.'**
  String get newPropertyAutoStatusInfo;

  /// No description provided for @propertyNameLabel.
  ///
  /// In pt, this message translates to:
  /// **'Nome do imovel'**
  String get propertyNameLabel;

  /// No description provided for @propertyNameHint.
  ///
  /// In pt, this message translates to:
  /// **'Ex: Casa Sol do Mar'**
  String get propertyNameHint;

  /// No description provided for @propertyTypeLabel.
  ///
  /// In pt, this message translates to:
  /// **'Tipo de imovel'**
  String get propertyTypeLabel;

  /// No description provided for @bedroomCountLabel.
  ///
  /// In pt, this message translates to:
  /// **'Quantidade de quartos'**
  String get bedroomCountLabel;

  /// No description provided for @rentValueLabel.
  ///
  /// In pt, this message translates to:
  /// **'Valor da renda (MT)'**
  String get rentValueLabel;

  /// No description provided for @rentValueHint.
  ///
  /// In pt, this message translates to:
  /// **'45000'**
  String get rentValueHint;

  /// No description provided for @statusLabel.
  ///
  /// In pt, this message translates to:
  /// **'Estado'**
  String get statusLabel;

  /// No description provided for @propertyAvailableAutomatic.
  ///
  /// In pt, this message translates to:
  /// **'Disponivel (automatico)'**
  String get propertyAvailableAutomatic;

  /// No description provided for @descriptionLabel.
  ///
  /// In pt, this message translates to:
  /// **'Descricao'**
  String get descriptionLabel;

  /// No description provided for @propertyDescriptionHint.
  ///
  /// In pt, this message translates to:
  /// **'Informacoes adicionais do imovel'**
  String get propertyDescriptionHint;

  /// No description provided for @facadePhotosTitle.
  ///
  /// In pt, this message translates to:
  /// **'Fotos da fachada'**
  String get facadePhotosTitle;

  /// No description provided for @facadePhotosSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Adicione a foto principal do exterior do imovel.'**
  String get facadePhotosSubtitle;

  /// No description provided for @interiorPhotosTitle.
  ///
  /// In pt, this message translates to:
  /// **'Fotos internas'**
  String get interiorPhotosTitle;

  /// No description provided for @interiorPhotosSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Adicione sala, quartos, cozinha e wc.'**
  String get interiorPhotosSubtitle;

  /// No description provided for @saveProperty.
  ///
  /// In pt, this message translates to:
  /// **'Salvar imovel'**
  String get saveProperty;

  /// No description provided for @detectedCity.
  ///
  /// In pt, this message translates to:
  /// **'Cidade detectada para o cadastro: {city}'**
  String detectedCity(Object city);

  /// No description provided for @tenantFormTitle.
  ///
  /// In pt, this message translates to:
  /// **'Cadastrar inquilino'**
  String get tenantFormTitle;

  /// No description provided for @tenantNameHint.
  ///
  /// In pt, this message translates to:
  /// **'Nome do inquilino'**
  String get tenantNameHint;

  /// No description provided for @associatedPropertyLabel.
  ///
  /// In pt, this message translates to:
  /// **'Imovel associado'**
  String get associatedPropertyLabel;

  /// No description provided for @saveTenant.
  ///
  /// In pt, this message translates to:
  /// **'Salvar inquilino'**
  String get saveTenant;

  /// No description provided for @contractFormTitle.
  ///
  /// In pt, this message translates to:
  /// **'Criar contrato'**
  String get contractFormTitle;

  /// No description provided for @propertyLabel.
  ///
  /// In pt, this message translates to:
  /// **'Imovel'**
  String get propertyLabel;

  /// No description provided for @tenantLabel.
  ///
  /// In pt, this message translates to:
  /// **'Inquilino'**
  String get tenantLabel;

  /// No description provided for @startLabel.
  ///
  /// In pt, this message translates to:
  /// **'Inicio'**
  String get startLabel;

  /// No description provided for @endLabel.
  ///
  /// In pt, this message translates to:
  /// **'Fim'**
  String get endLabel;

  /// No description provided for @monthlyValueLabel.
  ///
  /// In pt, this message translates to:
  /// **'Valor mensal (MT)'**
  String get monthlyValueLabel;

  /// No description provided for @monthlyValueHint.
  ///
  /// In pt, this message translates to:
  /// **'45.000'**
  String get monthlyValueHint;

  /// No description provided for @contractDocumentLabel.
  ///
  /// In pt, this message translates to:
  /// **'Documento do contrato'**
  String get contractDocumentLabel;

  /// No description provided for @contractDocumentHint.
  ///
  /// In pt, this message translates to:
  /// **'Upload do PDF (futuro)'**
  String get contractDocumentHint;

  /// No description provided for @saveContract.
  ///
  /// In pt, this message translates to:
  /// **'Salvar contrato'**
  String get saveContract;

  /// No description provided for @changePhotos.
  ///
  /// In pt, this message translates to:
  /// **'Alterar ({count})'**
  String changePhotos(Object count);

  /// No description provided for @add.
  ///
  /// In pt, this message translates to:
  /// **'Adicionar'**
  String get add;

  /// No description provided for @dashboardTitle.
  ///
  /// In pt, this message translates to:
  /// **'Dashboard ZIMO'**
  String get dashboardTitle;

  /// No description provided for @chatTooltip.
  ///
  /// In pt, this message translates to:
  /// **'Chat'**
  String get chatTooltip;

  /// No description provided for @homeNav.
  ///
  /// In pt, this message translates to:
  /// **'Home'**
  String get homeNav;

  /// No description provided for @propertiesNav.
  ///
  /// In pt, this message translates to:
  /// **'imoveis'**
  String get propertiesNav;

  /// No description provided for @paymentsNav.
  ///
  /// In pt, this message translates to:
  /// **'Pagamentos'**
  String get paymentsNav;

  /// No description provided for @maintenanceNav.
  ///
  /// In pt, this message translates to:
  /// **'Manutencao'**
  String get maintenanceNav;

  /// No description provided for @exploreNav.
  ///
  /// In pt, this message translates to:
  /// **'Explorar'**
  String get exploreNav;

  /// No description provided for @propertyUnavailableNow.
  ///
  /// In pt, this message translates to:
  /// **'Este imovel nao esta disponivel agora.'**
  String get propertyUnavailableNow;

  /// No description provided for @reservationStartedVia.
  ///
  /// In pt, this message translates to:
  /// **'Reserva e pagamento iniciados via {paymentMethod}.'**
  String reservationStartedVia(Object paymentMethod);

  /// No description provided for @reserveAndPay.
  ///
  /// In pt, this message translates to:
  /// **'Reservar e pagar'**
  String get reserveAndPay;

  /// No description provided for @dayLabel.
  ///
  /// In pt, this message translates to:
  /// **'Dia'**
  String get dayLabel;

  /// No description provided for @monthLabel.
  ///
  /// In pt, this message translates to:
  /// **'Mes'**
  String get monthLabel;

  /// No description provided for @filterPeriodLabel.
  ///
  /// In pt, this message translates to:
  /// **'Filtrar periodo'**
  String get filterPeriodLabel;

  /// No description provided for @fillMaintenanceFields.
  ///
  /// In pt, this message translates to:
  /// **'Preencha os campos da manutencao.'**
  String get fillMaintenanceFields;

  /// No description provided for @maintenanceRequestSent.
  ///
  /// In pt, this message translates to:
  /// **'Pedido de manutencao enviado.'**
  String get maintenanceRequestSent;

  /// No description provided for @problemTitleLabel.
  ///
  /// In pt, this message translates to:
  /// **'Titulo do problema'**
  String get problemTitleLabel;

  /// No description provided for @problemTitleHint.
  ///
  /// In pt, this message translates to:
  /// **'Ex: Fuga de agua'**
  String get problemTitleHint;

  /// No description provided for @problemDescriptionHint.
  ///
  /// In pt, this message translates to:
  /// **'Detalhe o problema'**
  String get problemDescriptionHint;

  /// No description provided for @requestMaintenance.
  ///
  /// In pt, this message translates to:
  /// **'Requisitar manutencao'**
  String get requestMaintenance;

  /// No description provided for @openTechnicalChat.
  ///
  /// In pt, this message translates to:
  /// **'Abrir chat tecnico'**
  String get openTechnicalChat;

  /// No description provided for @quickActionsTitle.
  ///
  /// In pt, this message translates to:
  /// **'Acoes rapidas'**
  String get quickActionsTitle;

  /// No description provided for @quickActionsSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Registre os detalhes e fotos do imovel. O numero de contacto do proprietario nao e preenchido aqui.'**
  String get quickActionsSubtitle;

  /// No description provided for @tenantActionsTitle.
  ///
  /// In pt, this message translates to:
  /// **'Acoes do inquilino'**
  String get tenantActionsTitle;

  /// No description provided for @requestMaintenanceShort.
  ///
  /// In pt, this message translates to:
  /// **'Solicitar manutencao'**
  String get requestMaintenanceShort;

  /// No description provided for @viewMyContract.
  ///
  /// In pt, this message translates to:
  /// **'Ver meu contrato'**
  String get viewMyContract;

  /// No description provided for @kpiTotalProperties.
  ///
  /// In pt, this message translates to:
  /// **'Total de imoveis'**
  String get kpiTotalProperties;

  /// No description provided for @kpiReceivedRent.
  ///
  /// In pt, this message translates to:
  /// **'Rendas recebidas'**
  String get kpiReceivedRent;

  /// No description provided for @kpiLateRent.
  ///
  /// In pt, this message translates to:
  /// **'Rendas em atraso'**
  String get kpiLateRent;

  /// No description provided for @kpiActiveAlerts.
  ///
  /// In pt, this message translates to:
  /// **'Alertas ativos'**
  String get kpiActiveAlerts;

  /// No description provided for @addAtLeastOnePropertyPhoto.
  ///
  /// In pt, this message translates to:
  /// **'Adicione pelo menos uma foto do imovel.'**
  String get addAtLeastOnePropertyPhoto;

  /// No description provided for @filterPropertiesTitle.
  ///
  /// In pt, this message translates to:
  /// **'Filtrar imoveis'**
  String get filterPropertiesTitle;

  /// No description provided for @typeLabel.
  ///
  /// In pt, this message translates to:
  /// **'Tipo'**
  String get typeLabel;

  /// No description provided for @locationLabel.
  ///
  /// In pt, this message translates to:
  /// **'Localizacao'**
  String get locationLabel;

  /// No description provided for @locationHint.
  ///
  /// In pt, this message translates to:
  /// **'Cidade ou bairro'**
  String get locationHint;

  /// No description provided for @applyFilter.
  ///
  /// In pt, this message translates to:
  /// **'Aplicar filtro'**
  String get applyFilter;

  /// No description provided for @tenantEmailHint.
  ///
  /// In pt, this message translates to:
  /// **'inquilino@email.com'**
  String get tenantEmailHint;

  /// No description provided for @contractStartHint.
  ///
  /// In pt, this message translates to:
  /// **'01/03/2026'**
  String get contractStartHint;

  /// No description provided for @contractEndHint.
  ///
  /// In pt, this message translates to:
  /// **'01/03/2027'**
  String get contractEndHint;

  /// No description provided for @adminDashboardTitle.
  ///
  /// In pt, this message translates to:
  /// **'Painel Admin'**
  String get adminDashboardTitle;

  /// No description provided for @adminControlCenter.
  ///
  /// In pt, this message translates to:
  /// **'Centro de controlo'**
  String get adminControlCenter;

  /// No description provided for @adminSupervisionSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Supervisao de utilizadores, uploads e sinais de risco.'**
  String get adminSupervisionSubtitle;

  /// No description provided for @adminMysqlLoadFailure.
  ///
  /// In pt, this message translates to:
  /// **'Falha ao carregar usuarios do MySQL.'**
  String get adminMysqlLoadFailure;

  /// No description provided for @noUsersRegisteredYet.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum utilizador cadastrado ainda.'**
  String get noUsersRegisteredYet;

  /// No description provided for @quickSummary.
  ///
  /// In pt, this message translates to:
  /// **'Resumo rapido'**
  String get quickSummary;

  /// No description provided for @adminUsersLabel.
  ///
  /// In pt, this message translates to:
  /// **'Utilizadores'**
  String get adminUsersLabel;

  /// No description provided for @adminsLabel.
  ///
  /// In pt, this message translates to:
  /// **'Admins'**
  String get adminsLabel;

  /// No description provided for @riskyUploadsLabel.
  ///
  /// In pt, this message translates to:
  /// **'Uploads em risco'**
  String get riskyUploadsLabel;

  /// No description provided for @openAlertsLabel.
  ///
  /// In pt, this message translates to:
  /// **'Alertas abertos'**
  String get openAlertsLabel;

  /// No description provided for @needsAttentionNow.
  ///
  /// In pt, this message translates to:
  /// **'Requer atencao agora'**
  String get needsAttentionNow;

  /// No description provided for @recentUsers.
  ///
  /// In pt, this message translates to:
  /// **'Utilizadores recentes'**
  String get recentUsers;

  /// No description provided for @viewAllUsers.
  ///
  /// In pt, this message translates to:
  /// **'Ver todos utilizadores'**
  String get viewAllUsers;

  /// No description provided for @systemUsersTitle.
  ///
  /// In pt, this message translates to:
  /// **'Utilizadores do sistema'**
  String get systemUsersTitle;

  /// No description provided for @searchUsersHint.
  ///
  /// In pt, this message translates to:
  /// **'Pesquisar por nome, email ou documento'**
  String get searchUsersHint;

  /// No description provided for @filtersTitle.
  ///
  /// In pt, this message translates to:
  /// **'Filtros'**
  String get filtersTitle;

  /// No description provided for @clear.
  ///
  /// In pt, this message translates to:
  /// **'Limpar'**
  String get clear;

  /// No description provided for @allLabel.
  ///
  /// In pt, this message translates to:
  /// **'Todos'**
  String get allLabel;

  /// No description provided for @activeLabel.
  ///
  /// In pt, this message translates to:
  /// **'Ativos'**
  String get activeLabel;

  /// No description provided for @suspendedLabel.
  ///
  /// In pt, this message translates to:
  /// **'Suspensos'**
  String get suspendedLabel;

  /// No description provided for @resultsCount.
  ///
  /// In pt, this message translates to:
  /// **'{count} resultado(s)'**
  String resultsCount(Object count);

  /// No description provided for @noUsersForSelectedFilters.
  ///
  /// In pt, this message translates to:
  /// **'Sem utilizadores para os filtros selecionados.'**
  String get noUsersForSelectedFilters;

  /// No description provided for @accountSuspendedMessage.
  ///
  /// In pt, this message translates to:
  /// **'Conta de {name} suspensa.'**
  String accountSuspendedMessage(Object name);

  /// No description provided for @accountReactivatedMessage.
  ///
  /// In pt, this message translates to:
  /// **'Conta de {name} reativada.'**
  String accountReactivatedMessage(Object name);

  /// No description provided for @passwordResetLinkSent.
  ///
  /// In pt, this message translates to:
  /// **'Link de reset enviado para {email}.'**
  String passwordResetLinkSent(Object email);

  /// No description provided for @historyOpenedMessage.
  ///
  /// In pt, this message translates to:
  /// **'Historico de {name} aberto.'**
  String historyOpenedMessage(Object name);

  /// No description provided for @usersLoadError.
  ///
  /// In pt, this message translates to:
  /// **'Nao foi possivel carregar utilizadores.'**
  String get usersLoadError;

  /// No description provided for @noPendingAlerts.
  ///
  /// In pt, this message translates to:
  /// **'Sem alertas pendentes.'**
  String get noPendingAlerts;

  /// No description provided for @suspendedAccount.
  ///
  /// In pt, this message translates to:
  /// **'Suspender conta'**
  String get suspendedAccount;

  /// No description provided for @reactivateAccount.
  ///
  /// In pt, this message translates to:
  /// **'Reativar conta'**
  String get reactivateAccount;

  /// No description provided for @resetPassword.
  ///
  /// In pt, this message translates to:
  /// **'Resetar senha'**
  String get resetPassword;

  /// No description provided for @viewHistory.
  ///
  /// In pt, this message translates to:
  /// **'Ver historico'**
  String get viewHistory;

  /// No description provided for @uploadMonitorTitle.
  ///
  /// In pt, this message translates to:
  /// **'Monitor de uploads'**
  String get uploadMonitorTitle;

  /// No description provided for @uploadMonitorSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Acompanhe ficheiros enviados e identifique documentos suspeitos.'**
  String get uploadMonitorSubtitle;

  /// No description provided for @searchUploadHint.
  ///
  /// In pt, this message translates to:
  /// **'Pesquisar por utilizador ou ficheiro'**
  String get searchUploadHint;

  /// No description provided for @showOnlyRiskUploads.
  ///
  /// In pt, this message translates to:
  /// **'Mostrar apenas uploads com risco'**
  String get showOnlyRiskUploads;

  /// No description provided for @uploadsFound.
  ///
  /// In pt, this message translates to:
  /// **'{count} upload(s) encontrado(s)'**
  String uploadsFound(Object count);

  /// No description provided for @riskCenterTitle.
  ///
  /// In pt, this message translates to:
  /// **'Central de risco'**
  String get riskCenterTitle;

  /// No description provided for @riskCenterSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Monitore atividades fora do padrao e resolva alertas rapidamente.'**
  String get riskCenterSubtitle;

  /// No description provided for @resolvedAlertsLabel.
  ///
  /// In pt, this message translates to:
  /// **'Alertas resolvidos'**
  String get resolvedAlertsLabel;

  /// No description provided for @openAlertsSection.
  ///
  /// In pt, this message translates to:
  /// **'Abertos'**
  String get openAlertsSection;

  /// No description provided for @markAsResolved.
  ///
  /// In pt, this message translates to:
  /// **'Marcar como resolvido'**
  String get markAsResolved;

  /// No description provided for @adminActionsTitle.
  ///
  /// In pt, this message translates to:
  /// **'Acoes de administracao'**
  String get adminActionsTitle;

  /// No description provided for @viewUsers.
  ///
  /// In pt, this message translates to:
  /// **'Ver utilizadores'**
  String get viewUsers;

  /// No description provided for @monitorUploads.
  ///
  /// In pt, this message translates to:
  /// **'Monitorar uploads'**
  String get monitorUploads;

  /// No description provided for @suspiciousBehaviors.
  ///
  /// In pt, this message translates to:
  /// **'Comportamentos suspeitos'**
  String get suspiciousBehaviors;

  /// No description provided for @availablePropertiesTitle.
  ///
  /// In pt, this message translates to:
  /// **'Imoveis disponiveis'**
  String get availablePropertiesTitle;

  /// No description provided for @availablePropertiesSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Pesquise, filtre e avalie imoveis para arrendar sem intermediarios.'**
  String get availablePropertiesSubtitle;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
