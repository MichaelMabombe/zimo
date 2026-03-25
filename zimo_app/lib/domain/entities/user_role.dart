enum UserRole { admin, proprietario, inquilino }

UserRole userRoleFromApi(String value) {
  switch (value) {
    case 'admin':
      return UserRole.admin;
    case 'inquilino':
      return UserRole.inquilino;
    default:
      return UserRole.proprietario;
  }
}

String userRoleToApi(UserRole role) {
  switch (role) {
    case UserRole.admin:
      return 'admin';
    case UserRole.inquilino:
      return 'inquilino';
    case UserRole.proprietario:
      return 'proprietario';
  }
}
