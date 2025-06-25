class AuthToken {
  AuthToken({required this.accessToken, required this.tokenType});
  final String accessToken;
  final String tokenType;

  factory AuthToken.fromJson(Map<String, dynamic> data) {
    final accessToken = data['access_token'] as String;
    final tokenType = data['token_type'] as String;
    return AuthToken(accessToken: accessToken, tokenType: tokenType);
  }
}
