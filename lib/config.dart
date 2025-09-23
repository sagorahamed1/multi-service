class Config {
  // Private static fields
  static String _publishableKey = 'pk_test_51ROfexQiQjkt7RpMHvE2P6cKp2Csmx46LwjvgPlhV4zoVeknKKbPFMJZiD6xZJBSduyRVN5hS1m9p6Pz2UWxe2GQ007cD5tWzl';
  static String _secretKey = 'sk_test_51ROfexQiQjkt7RpMHZtY97fx5QDieOv2a5zj4kA8jTNPuwsN6aJv2AWBgoLwKd79IIccySYGXC4E37u6hB6jN5e1003WFKXc4y';
  static String googleMapKey = 'AIzaSyAhWJz1S5mc91IAqcF8yInWMQU4JNTeZYk';

  /// Setter for publishableKey
  static void setPublishableKey(String key)

  {  _publishableKey = key;
  }

  static String get publishableKey => _publishableKey;


  /// Setter for secretKey
  static void setSecretKey(String key) {    _secretKey = key;  }

  /// Getter for secretKey
  static String get secretKey => _secretKey;}

