/**
 * @file auth_token.dart
 * @author Stephen Boyett
 * @date 2025-09-06
 * @brief Authentication token data model for API access.
 * @details Defines the AuthToken class for managing OAuth access tokens
 *          including token type and access token with JSON serialization.
 * @version 1.0
 * @since 1.0
 */

/**
 * @brief Authentication token model for API access.
 * @details Represents an OAuth access token with type information,
 *          providing JSON serialization for API authentication.
 * @since 1.0
 */
class AuthToken {
  /**
   * @brief Creates an AuthToken with access token and type.
   * @param accessToken The OAuth access token string
   * @param tokenType The type of token (e.g., "Bearer")
   */
  AuthToken({required this.accessToken, required this.tokenType});

  /// The OAuth access token string
  final String accessToken;

  /// The type of token (e.g., "Bearer", "Basic")
  final String tokenType;

  /**
   * @brief Factory constructor to create AuthToken from JSON data.
   * @details Parses JSON response from authentication API to create
   *          an AuthToken instance with proper field mapping.
   * @param data JSON map containing token information
   * @return AuthToken instance populated from JSON data
   * @since 1.0
   */
  factory AuthToken.fromJson(Map<String, dynamic> data) {
    final accessToken = data['access_token'] as String;
    final tokenType = data['token_type'] as String;
    return AuthToken(accessToken: accessToken, tokenType: tokenType);
  }
}
