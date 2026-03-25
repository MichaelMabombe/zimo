// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'ZIMO';

  @override
  String get poweredByCetus => 'Powered by Cetus Technologys';

  @override
  String get logoutTitle => 'Terminar sessao';

  @override
  String get logoutMessage => 'Deseja realmente fazer log out?';

  @override
  String get cancel => 'Cancelar';

  @override
  String get logout => 'Log out';

  @override
  String get roleAdmin => 'Admin';

  @override
  String get roleOwner => 'Proprietario';

  @override
  String get roleTenant => 'Inquilino';

  @override
  String accountType(Object role) {
    return 'Tipo de conta: $role';
  }

  @override
  String userEmailWithRole(Object role, Object email) {
    return '$role - $email';
  }

  @override
  String get welcomeHeadline =>
      'Alugue sem intermediarios e encontre seu proximo lar mais rapido.';

  @override
  String get welcomeSubtitle =>
      'A ZIMO conecta proprietarios e inquilinos em um processo simples, direto e seguro.';

  @override
  String get welcomeStartTitle => 'Comece em menos de 2 minutos';

  @override
  String get welcomeStartSubtitle =>
      'Escolha seu perfil e acesse as funcoes principais rapidamente.';

  @override
  String get welcomeFeaturePropertiesTitle => 'Imoveis sob controle';

  @override
  String get welcomeFeaturePropertiesSubtitle =>
      'Status, renda, fotos e documentos.';

  @override
  String get welcomeFeaturePaymentsTitle => 'Pagamentos claros';

  @override
  String get welcomeFeaturePaymentsSubtitle =>
      'Alertas de atraso e historico completo.';

  @override
  String get welcomeFeatureMaintenanceTitle => 'Manutencao organizada';

  @override
  String get welcomeFeatureMaintenanceSubtitle =>
      'Pedidos, aprovacoes e tecnicos.';

  @override
  String get quickAccess => 'Acesso rapido';

  @override
  String get getStarted => 'Comecar';

  @override
  String get alreadyHaveAccount => 'Ja tenho conta';

  @override
  String get userTypeTitle => 'Tipo de usuario';

  @override
  String get roleSelectQuestion => 'Como voce vai usar a ZIMO?';

  @override
  String get roleSelectSubtitle =>
      'Isso ajuda a personalizar o dashboard e as permissoes.';

  @override
  String get ownerRoleTitle => 'Proprietario';

  @override
  String get ownerRoleSubtitle => 'Gerencie imoveis, contratos e rendas.';

  @override
  String get tenantRoleTitle => 'Inquilino';

  @override
  String get tenantRoleSubtitle =>
      'Pagamentos, contrato e pedidos de manutencao.';

  @override
  String get continueAction => 'Continuar';

  @override
  String get loginTitle => 'Entrar';

  @override
  String get welcomeBack => 'Bem-vindo de volta';

  @override
  String get loginInstructions => 'Use seu email e senha para continuar.';

  @override
  String get emailLabel => 'Email';

  @override
  String get emailHint => 'exemplo@zimo.co.mz';

  @override
  String get passwordLabel => 'Senha';

  @override
  String get passwordHint => '********';

  @override
  String get hidePassword => 'Ocultar senha';

  @override
  String get showPassword => 'Ver senha';

  @override
  String get rememberMe => 'Lembrar-me';

  @override
  String get forgotPassword => 'Esqueci a senha';

  @override
  String get processing => 'A processar...';

  @override
  String get informEmailAndPassword => 'Informe email e senha.';

  @override
  String get backendConnectionError => 'Erro ao conectar com o backend.';

  @override
  String get accountNotFound => 'Conta nao encontrada.';

  @override
  String get fillNamePhoneAddress => 'Preencha nome, telefone e endereco.';

  @override
  String get profileSettingsTitle => 'Configuracoes do perfil';

  @override
  String get changePhoto => 'Alterar foto';

  @override
  String get nameLabel => 'Nome';

  @override
  String get yourNameHint => 'Seu nome';

  @override
  String get phoneLabel => 'Telefone';

  @override
  String get phoneHint => '+258 84 000 0000';

  @override
  String get addressLabel => 'Endereco';

  @override
  String get addressHint => 'Rua, bairro, cidade';

  @override
  String get saveChanges => 'Salvar alteracoes';

  @override
  String get registerOwnerTitle => 'Criar conta de proprietario';

  @override
  String get registerTenantTitle => 'Criar conta de inquilino';

  @override
  String get registerTitle => 'Criar conta';

  @override
  String get fillAllFields => 'Preencha todos os campos.';

  @override
  String get fullNameLabel => 'Nome completo';

  @override
  String get contactLabel => 'Contacto';

  @override
  String get documentLabel => 'Documento (BI/NIF)';

  @override
  String get documentHint => 'Numero do documento';

  @override
  String get createAccount => 'Criar conta';

  @override
  String get registerInfo =>
      'Os dados sao obrigatorios e serao enviados para a base de dados na integracao do backend.';

  @override
  String get propertyFormTitle => 'Cadastrar imovel';

  @override
  String get newPropertyAutoStatusInfo =>
      'Imoveis novos entram automaticamente como Disponivel e so mudam de estado quando houver arrendamento.';

  @override
  String get propertyNameLabel => 'Nome do imovel';

  @override
  String get propertyNameHint => 'Ex: Casa Sol do Mar';

  @override
  String get propertyTypeLabel => 'Tipo de imovel';

  @override
  String get bedroomCountLabel => 'Quantidade de quartos';

  @override
  String get rentValueLabel => 'Valor da renda (MT)';

  @override
  String get rentValueHint => '45000';

  @override
  String get statusLabel => 'Estado';

  @override
  String get propertyAvailableAutomatic => 'Disponivel (automatico)';

  @override
  String get descriptionLabel => 'Descricao';

  @override
  String get propertyDescriptionHint => 'Informacoes adicionais do imovel';

  @override
  String get facadePhotosTitle => 'Fotos da fachada';

  @override
  String get facadePhotosSubtitle =>
      'Adicione a foto principal do exterior do imovel.';

  @override
  String get interiorPhotosTitle => 'Fotos internas';

  @override
  String get interiorPhotosSubtitle => 'Adicione sala, quartos, cozinha e wc.';

  @override
  String get saveProperty => 'Salvar imovel';

  @override
  String detectedCity(Object city) {
    return 'Cidade detectada para o cadastro: $city';
  }

  @override
  String get tenantFormTitle => 'Cadastrar inquilino';

  @override
  String get tenantNameHint => 'Nome do inquilino';

  @override
  String get associatedPropertyLabel => 'Imovel associado';

  @override
  String get saveTenant => 'Salvar inquilino';

  @override
  String get contractFormTitle => 'Criar contrato';

  @override
  String get propertyLabel => 'Imovel';

  @override
  String get tenantLabel => 'Inquilino';

  @override
  String get startLabel => 'Inicio';

  @override
  String get endLabel => 'Fim';

  @override
  String get monthlyValueLabel => 'Valor mensal (MT)';

  @override
  String get monthlyValueHint => '45.000';

  @override
  String get contractDocumentLabel => 'Documento do contrato';

  @override
  String get contractDocumentHint => 'Upload do PDF (futuro)';

  @override
  String get saveContract => 'Salvar contrato';

  @override
  String changePhotos(Object count) {
    return 'Alterar ($count)';
  }

  @override
  String get add => 'Adicionar';

  @override
  String get dashboardTitle => 'Dashboard ZIMO';

  @override
  String get chatTooltip => 'Chat';

  @override
  String get homeNav => 'Home';

  @override
  String get propertiesNav => 'imoveis';

  @override
  String get paymentsNav => 'Pagamentos';

  @override
  String get maintenanceNav => 'Manutencao';

  @override
  String get exploreNav => 'Explorar';

  @override
  String get propertyUnavailableNow => 'Este imovel nao esta disponivel agora.';

  @override
  String reservationStartedVia(Object paymentMethod) {
    return 'Reserva e pagamento iniciados via $paymentMethod.';
  }

  @override
  String get reserveAndPay => 'Reservar e pagar';

  @override
  String get dayLabel => 'Dia';

  @override
  String get monthLabel => 'Mes';

  @override
  String get filterPeriodLabel => 'Filtrar periodo';

  @override
  String get fillMaintenanceFields => 'Preencha os campos da manutencao.';

  @override
  String get maintenanceRequestSent => 'Pedido de manutencao enviado.';

  @override
  String get problemTitleLabel => 'Titulo do problema';

  @override
  String get problemTitleHint => 'Ex: Fuga de agua';

  @override
  String get problemDescriptionHint => 'Detalhe o problema';

  @override
  String get requestMaintenance => 'Requisitar manutencao';

  @override
  String get openTechnicalChat => 'Abrir chat tecnico';

  @override
  String get quickActionsTitle => 'Acoes rapidas';

  @override
  String get quickActionsSubtitle =>
      'Registre os detalhes e fotos do imovel. O numero de contacto do proprietario nao e preenchido aqui.';

  @override
  String get tenantActionsTitle => 'Acoes do inquilino';

  @override
  String get requestMaintenanceShort => 'Solicitar manutencao';

  @override
  String get viewMyContract => 'Ver meu contrato';

  @override
  String get kpiTotalProperties => 'Total de imoveis';

  @override
  String get kpiReceivedRent => 'Rendas recebidas';

  @override
  String get kpiLateRent => 'Rendas em atraso';

  @override
  String get kpiActiveAlerts => 'Alertas ativos';

  @override
  String get addAtLeastOnePropertyPhoto =>
      'Adicione pelo menos uma foto do imovel.';

  @override
  String get filterPropertiesTitle => 'Filtrar imoveis';

  @override
  String get typeLabel => 'Tipo';

  @override
  String get locationLabel => 'Localizacao';

  @override
  String get locationHint => 'Cidade ou bairro';

  @override
  String get applyFilter => 'Aplicar filtro';

  @override
  String get tenantEmailHint => 'inquilino@email.com';

  @override
  String get contractStartHint => '01/03/2026';

  @override
  String get contractEndHint => '01/03/2027';

  @override
  String get adminDashboardTitle => 'Painel Admin';

  @override
  String get adminControlCenter => 'Centro de controlo';

  @override
  String get adminSupervisionSubtitle =>
      'Supervisao de utilizadores, uploads e sinais de risco.';

  @override
  String get adminMysqlLoadFailure => 'Falha ao carregar usuarios do MySQL.';

  @override
  String get noUsersRegisteredYet => 'Nenhum utilizador cadastrado ainda.';

  @override
  String get quickSummary => 'Resumo rapido';

  @override
  String get adminUsersLabel => 'Utilizadores';

  @override
  String get adminsLabel => 'Admins';

  @override
  String get riskyUploadsLabel => 'Uploads em risco';

  @override
  String get openAlertsLabel => 'Alertas abertos';

  @override
  String get needsAttentionNow => 'Requer atencao agora';

  @override
  String get recentUsers => 'Utilizadores recentes';

  @override
  String get viewAllUsers => 'Ver todos utilizadores';

  @override
  String get systemUsersTitle => 'Utilizadores do sistema';

  @override
  String get searchUsersHint => 'Pesquisar por nome, email ou documento';

  @override
  String get filtersTitle => 'Filtros';

  @override
  String get clear => 'Limpar';

  @override
  String get allLabel => 'Todos';

  @override
  String get activeLabel => 'Ativos';

  @override
  String get suspendedLabel => 'Suspensos';

  @override
  String resultsCount(Object count) {
    return '$count resultado(s)';
  }

  @override
  String get noUsersForSelectedFilters =>
      'Sem utilizadores para os filtros selecionados.';

  @override
  String accountSuspendedMessage(Object name) {
    return 'Conta de $name suspensa.';
  }

  @override
  String accountReactivatedMessage(Object name) {
    return 'Conta de $name reativada.';
  }

  @override
  String passwordResetLinkSent(Object email) {
    return 'Link de reset enviado para $email.';
  }

  @override
  String historyOpenedMessage(Object name) {
    return 'Historico de $name aberto.';
  }

  @override
  String get usersLoadError => 'Nao foi possivel carregar utilizadores.';

  @override
  String get noPendingAlerts => 'Sem alertas pendentes.';

  @override
  String get suspendedAccount => 'Suspender conta';

  @override
  String get reactivateAccount => 'Reativar conta';

  @override
  String get resetPassword => 'Resetar senha';

  @override
  String get viewHistory => 'Ver historico';

  @override
  String get uploadMonitorTitle => 'Monitor de uploads';

  @override
  String get uploadMonitorSubtitle =>
      'Acompanhe ficheiros enviados e identifique documentos suspeitos.';

  @override
  String get searchUploadHint => 'Pesquisar por utilizador ou ficheiro';

  @override
  String get showOnlyRiskUploads => 'Mostrar apenas uploads com risco';

  @override
  String uploadsFound(Object count) {
    return '$count upload(s) encontrado(s)';
  }

  @override
  String get riskCenterTitle => 'Central de risco';

  @override
  String get riskCenterSubtitle =>
      'Monitore atividades fora do padrao e resolva alertas rapidamente.';

  @override
  String get resolvedAlertsLabel => 'Alertas resolvidos';

  @override
  String get openAlertsSection => 'Abertos';

  @override
  String get markAsResolved => 'Marcar como resolvido';

  @override
  String get adminActionsTitle => 'Acoes de administracao';

  @override
  String get viewUsers => 'Ver utilizadores';

  @override
  String get monitorUploads => 'Monitorar uploads';

  @override
  String get suspiciousBehaviors => 'Comportamentos suspeitos';

  @override
  String get availablePropertiesTitle => 'Imoveis disponiveis';

  @override
  String get availablePropertiesSubtitle =>
      'Pesquise, filtre e avalie imoveis para arrendar sem intermediarios.';
}
