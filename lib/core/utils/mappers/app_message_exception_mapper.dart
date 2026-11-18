class AppMessageExceptionMapper {
  static const unknownError = 'Ocorreu um erro inesperado. Tente novamente.';
  static const unauthorized = 'CPF ou senha inválidos.';
  static const notFound = 'Recurso não encontrado.';
  static const badRequest = 'Requisição inválida.';
  static const serverError = 'Erro interno. Tente novamente mais tarde.';
  static const timeoutError = 'Tempo de resposta esgotado. Tente novamente.';
  static const networkError = 'Falha de rede. Verifique sua conexão.';
  static const permissionDenied = 'Você não tem permissão para esta operação.';
  static const unavailable = 'Serviço temporariamente indisponível.';
  static const alreadyExists = 'Já existe uma conta com este CPF.';
  static const weakPassword = 'A senha deve ter pelo menos 6 caracteres.';
  static const invalidEmail = 'E-mail derivado do CPF é inválido.';
  static const userDisabled = 'Esta conta foi desativada.';
  static const operationNotAllowed =
      'Provedor de login não habilitado no Firebase Auth. '
      'Ative E-mail/senha e/ou Google em Authentication → Sign-in method.';
  static const accountExistsWithDifferentCredential =
      'Já existe uma conta com este e-mail usando outro método de login.';
  static const googleCancelled = 'Login com Google cancelado.';
  static const tooManyRequests =
      'Muitas tentativas. Aguarde e tente novamente.';
  static const authFailed = 'Falha na autenticação.';
}
