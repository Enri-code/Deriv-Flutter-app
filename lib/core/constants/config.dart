///Global class containing const variables for the application
/// used across the project
abstract class AppConfig {
  
  AppConfig._();

  ///The one-line description used to represent the app (Android and Web)
  static const appName = 'Deriv';
  static const socketBaseUrl =
      'wss://ws.binaryws.com/websockets/v3?app_id=1089';
}
