/// The Adsplatter class
/// This class is the main class for the Adsplatter Mobile Application.
library;

import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:framework/computed.dart';
import 'adsplatter_user.dart';
import 'helper.dart';
import 'constants.dart';

class Adsplatter with AdsplatterHelper {

  /// Properties
  final String _icIOS = '';
  final String _uqidicIOS = '';
  final String _icAndroid = '';
  final String _uqidicAndroid = '';
  final String _channel = 'stable';

  /// Singleton instance
  static Adsplatter? _instance;

  /// Runtime values
  static late Computed _runtimeValues;

  /// The User object represents the current user and must always be initialized.
  /// The user object is destroyed and set again when the user logs in or registers.
  static late AdsplatterUser user;

  // Version
  late String _version;
  late String _buildNumber;
  late String _platform;

  /// Debug
  bool kDebugMode = false;
  bool debugMode = false;

  /// Whether the application needs an update or not.
  bool needsUpdate = false;

  /// Whether the application needs a command or not.
  bool needsCommand = false;

  /// The command to run if the application needs a command.
  String command = 'date';

  /// Whether the user is logged in or not.
  var loggedIn = false;

  /// Constructor
  Adsplatter._();

  /// Named constructor to create and return an instance of the class
  factory Adsplatter() {
    return Adsplatter._();
  }

  /// Initialize the Adsplatter Mobile Application
  init() async {

    _instance = this;

    // Initialize the application
    if(kDebugMode) {
      print('Initializing...');
    }

    /**
     * Get the version and build number
     */
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      _version = packageInfo.version;
      _buildNumber = packageInfo.buildNumber;
    } catch (e) {
      _version = '0.0.0';
      _buildNumber = 'ERROR';
    }

    /**
     * Get the platform
     */
    _platform = Platform.operatingSystem;

    /**
     * App Initialization: retrieves Updates etc
     */
    String ic = _platform == 'ios' ? _icIOS : _icAndroid;
    String uqidic = _platform == 'ios' ? _uqidicIOS : _uqidicAndroid;

    bool canConnect = true;

    if(canConnect) {

      if(kDebugMode) {
        print('Initialization response successful');
      }

      // Get the response body
      String responseBody = '''
{
  "response": {
    "status": "success",
    "message": "Initialization completed successfully",
    "data": {
      "id": "",
      "version": "1.0.0",
      "features": ["login", "dashboard", "settings"]
    }
  }
}
''';

      // Decode the response body
      var responseJSON = jsonDecode(responseBody);

      // If the initialization response status is successful
      if(responseJSON['response']['status'] == 'success') {

        // Get the data
        var data = responseJSON['response']['data'];

        // Get the UQID_IC
        String uqidIc = data['id'];

        // Check if the UQID_IC is correct
        if(uqidIc != uqidic) {
          // Initialization failed
          if(kDebugMode) {
            print('Initialization failed at UQID_IC');
          }
          throw 'Initialization failed at UQID_IC';
        }

        /**
         * Initialization successful
         */
        if(kDebugMode) {
          print('Initialization successful');
        }

        return this;
      }

      // If the initialization response status wants an update
      if(responseJSON['response']['status'] == 'update') {
        if(kDebugMode) {
          print('Initialization successful: must update');
        }

        // Set the needsUpdate flag to true
        needsUpdate = true;

        return this;
      }
    }

    // Initialization failed
    if(kDebugMode) {
      print('Initialization failed');
    }

    throw 'Initialization failed';
  }

  /// Set the runtime values
  void runtime(BuildContext context) {
    _runtimeValues = Computed(context: context);
  }

  /// Check the login status. If the user is not logged in, log them out.
  ///
  /// @return Future<bool>
  Future<bool> checkLoginStatus() async {

    // Retrieve user cookie
    String cookie = getCookie(decoded: true);

    // Send a request to check if the user is logged in
    var response = await sendGetRequest(
        'https://adsplatter.com/api/v1/xhrc/app/user/isLoggedIn',
        headers: {
          'Cookie': cookie
        }
    );


    // If the response status code is 200
    if (response.statusCode == 200) {

      /**
       * Debug
       * @debug
       */
      if(kDebugMode) {
        print('Initialization response successful');
      }

      // Get the response body
      String responseBody = response.body;

      // Decode the response body
      var responseJSON = jsonDecode(responseBody);

      // If the initialization response status is successful
      if (responseJSON['response']['status'] == 'success') {
        // Set the user as logged in
        loggedIn = true;

        return true;
      }
    }

    /**
     * Logout the user
     */
    await logout();

    return false;
  }

  /// Retrieves command
  ///
  /// @return String
  String getCommand() {
    return command;
  }

  /// Get the needs update flag
  ///
  /// @return bool
  bool getNeedsUpdate() {
    return needsUpdate;
  }

  /// Get the needs command flag
  ///
  /// @return bool
  bool getNeedsCommand() {
    return needsCommand;
  }

  /// Update the user data
  ///
  /// @return Future
  Future updateUserData() async {

    // Retrieve user data (using Cookie <3)
    final response = await sendGetRequest("https://adsplatter.com/api/v1/xhrc/app/user/data/all", headers: {
      'Cookie': getCookie(decoded: true)
    });

    if(response.statusCode != 200) {
      return false;
    }

    var responseData = json.decode(response.body);
    var userData = responseData['response']['data'][0] as Map<String, dynamic>;

    // Extract the required fields
    bool loggedIn = true;
    String userUsername = userData['user_username'] ?? '';
    String userEmail = userData['user_email'] ?? '';
    String userMobile = userData['user_mobile'] ?? '';
    int userStatus = userData['user_status'] ?? 999;
    int userAccountType = userData['user_account_type'] ?? 999;
    int userCreationTimestamp = userData['user_creation_timestamp'] ?? 0;
    int userLastLoginTimestamp = userData['user_last_login_timestamp'] ?? 0;
    int userLastFailedLoginTimestamp = userData['user_last_failed_login_timestamp'] ?? 0;
    String userAccountProvider = userData['user_account_provider'] ?? 'error';
    String userSessionID = userData['user_session_id'] ?? '';
    String userUqid = userData['user_uqid'] ?? 'error';
    int userBirthDate = userData['birth_date'] ?? 0;
    String userFirstName = userData['first_name'] ?? '';
    String userLastName = userData['last_name'] ?? '';
    String addressLine1 = userData['address_line_1'] ?? '';
    String addressLine2 = userData['address_line_2'] ?? '';
    String city = userData['city'] ?? '';
    String state = userData['state']  ?? '';
    String county = userData['county']  ?? '';
    String postcode = userData['postcode'] ?? '';
    String country = userData['country'] ?? '';

    // Encode the cookie
    String encodedCookie = getCookie(decoded: false);

    // Create a whole new user on login!
    setNewUser(
        cookie: encodedCookie,
        loggedIn: loggedIn,
        status: userStatus,
        uqid: userUqid,
        email: userEmail,
        mobile: userMobile,
        password: '',
        provider: userAccountProvider,
        accountCreated: userCreationTimestamp,
        lastLogin: userLastLoginTimestamp,
        birthDate: userBirthDate,
        firstName: userFirstName,
        lastName: userLastName,
        addressLine1: addressLine1,
        addressLine2: addressLine2,
        city: city,
        state: state,
        postcode: postcode,
        country: country
    );

    // Save the user data to SharedPreferences
    await user.save();
  }

  /// Logout the user
  ///
  /// @return Future
  Future logout() async {

    // Clear the user
    setNewUser(
        cookie: '',
        loggedIn: false,
        status: 0,
        uqid: '',
        email: '',
        mobile: '',
        password: '',
        provider: '',
        accountCreated: 0,
        lastLogin: 0,
        birthDate: 0,
        firstName: '',
        lastName: '',
        addressLine1: '',
        addressLine2: '',
        city: '',
        state: '',
        postcode: '',
        country: ''
    );

    // Set the user as logged out
    loggedIn = false;

    // Save the user
    user.save();
  }

  /// Set the new user: this will destroy the current user and set a new user.
  ///
  /// @param String cookie
  /// @param bool loggedIn
  /// @param int status
  /// @param String uqid
  /// @param String email
  /// @param String mobile
  /// @param String password
  /// @param String provider
  /// @param int accountCreated
  /// @param int lastLogin
  /// @param int birthDate
  /// @param String firstName
  /// @param String lastName
  /// @param String addressLine1
  /// @param String addressLine2
  /// @param String city
  /// @param String state
  /// @param String postcode
  /// @param String country
  ///
  /// @return User
  static AdsplatterUser setNewUser({
    required String cookie,
    required bool loggedIn,
    required int status,
    required String uqid,
    required String email,
    required String mobile,
    required String password,
    required String provider,
    required int accountCreated,
    required int lastLogin,
    required int birthDate,
    required String firstName,
    required String lastName,
    required String addressLine1,
    required String addressLine2,
    required String city,
    required String state,
    required String postcode,
    required String country
  }) {
    // Set the user
    return user = AdsplatterUser(
        cookie: cookie,
        loggedIn: loggedIn,
        status: status,
        uqid: uqid,
        email: email,
        mobile: mobile,
        password: password,
        provider: provider,
        accountCreated: accountCreated,
        lastLogin: lastLogin,
        birthDate: birthDate,
        firstName: firstName,
        lastName: lastName,
        addressLine1: addressLine1,
        addressLine2: addressLine2,
        city: city,
        state: state,
        postcode: postcode,
        country: country
    );
  }

  /// Constants
  static int get bankingVerificationCodeLength => Constants.bankingVerificationCodeLength;
  static List<String> get bankingMethods => Constants.bankingMethods;
  static Map<String, String> get errorMessages => Constants.errorMessages;
  static Map<String, String> get infoText => Constants.infoText;
  static List<String> get adStatuses => Constants.adStatuses;
  static int get adStatusNotVerified => Constants.adStatusNotVerified;
  static int get adStatusPending => Constants.adStatusPending;
  static int get adStatusReady => Constants.adStatusReady;
  static int get adStatusActive => Constants.adStatusActive;
  static int get adStatusDisabled => Constants.adStatusDisabled;
  static List<String> get adSpaceSizes => Constants.adSpaceSizes;
  static List<Map<String, String>> get mobilePrefixes => Constants.mobilePrefixes;
  static Map<String, String> get countries => Constants.countries;
  static Map<String, Map<String, String>> get cities => Constants.cities;
  static List<String> get carMakes => Constants.carMakes;
  static List<String> get carColours => Constants.carColours;
  static Map<String, Color> get carColoursMap => Constants.carColoursMap;
  static List<String> get carFuelTypes => Constants.carFuelTypes;
  static List<int> get carYearsChart => Constants.carYearsChart;
  static List<String> get carParkingTypes => Constants.carParkingTypes;
  static List<String> get houseVisibilities => Constants.houseVisibilities;
  static List<String> get houseTypes => Constants.houseTypes;
  static List<String> get houseResidents => Constants.houseResidents;

  /// Runtime values
  static TargetPlatform? get targetPlatform => _runtimeValues.platform;
  static bool get isPortrait => _runtimeValues.isPortrait;
  static bool get isLandscape => _runtimeValues.isLandscape;
  static double get screenWidth => _runtimeValues.screenWidth;
  static double get screenHeight => _runtimeValues.screenHeight;
  // Font sizes
  static double get fontSizeH1 => _runtimeValues.fontSizeH1;
  static double get fontSizeH2 => _runtimeValues.fontSizeH2;
  static double get fontSizeH3 => _runtimeValues.fontSizeH3;
  static double get fontSizeH4 => _runtimeValues.fontSizeH4;
  static double get fontSizeH5 => _runtimeValues.fontSizeH5;
  static double get fontSizeH6 => _runtimeValues.fontSizeH6;
  static double get fontSizeParagraph => _runtimeValues.fontSizeParagraph;
  static double get fontSizeSmall => _runtimeValues.fontSizeSmall;
  static double get fontSizeExtraSmall => _runtimeValues.fontSizeExtraSmall;
  // Image sizes
  static double get imageSizeExtraSmall => _runtimeValues.imageSizeExtraSmall;
  static double get imageSizeSmall => _runtimeValues.imageSizeSmall;
  static double get imageSizeMediumSmall => _runtimeValues.imageSizeMediumSmall;
  static double get imageSizeMedium => _runtimeValues.imageSizeMedium;
  static double get imageSizeMediumLarge => _runtimeValues.imageSizeMediumLarge;
  static double get imageSizeLarge => _runtimeValues.imageSizeLarge;
  static double get imageSizeExtraLarge => _runtimeValues.imageSizeExtraLarge;
  // Animation sizes
  static double get animationSizeExtraSmall => _runtimeValues.animationSizeExtraSmall;
  static double get animationSizeSmall => _runtimeValues.animationSizeSmall;
  static double get animationSizeMediumSmall => _runtimeValues.animationSizeMediumSmall;
  static double get animationSizeMedium => _runtimeValues.animationSizeMedium;
  static double get animationSizeMediumLarge => _runtimeValues.animationSizeMediumLarge;
  static double get animationSizeLarge => _runtimeValues.animationSizeLarge;
  static double get animationSizeExtraLarge => _runtimeValues.animationSizeExtraLarge;
  // Icon sizes
  static double get iconSizeExtraSmall => _runtimeValues.iconSizeExtraSmall;
  static double get iconSizeSmall => _runtimeValues.iconSizeSmall;
  static double get iconSizeMediumSmall => _runtimeValues.iconSizeMediumSmall;
  static double get iconSizeMedium => _runtimeValues.iconSizeMedium;
  static double get iconSizeMediumLarge => _runtimeValues.iconSizeMediumLarge;
  static double get iconSizeLarge => _runtimeValues.iconSizeLarge;
  static double get iconSizeExtraLarge => _runtimeValues.iconSizeExtraLarge;
  // Margins
  static double get marginExtraSmall => _runtimeValues.marginExtraSmall;
  static double get marginSmall => _runtimeValues.marginSmall;
  static double get marginMediumSmall => _runtimeValues.marginMediumSmall;
  static double get marginMedium => _runtimeValues.marginMedium;
  static double get marginMediumLarge => _runtimeValues.marginMediumLarge;
  static double get marginLarge => _runtimeValues.marginLarge;
  static double get marginExtraLarge => _runtimeValues.marginExtraLarge;
  // Paddings
  static double get paddingExtraSmall => _runtimeValues.paddingExtraSmall;
  static double get paddingSmall => _runtimeValues.paddingSmall;
  static double get paddingMediumSmall => _runtimeValues.paddingMediumSmall;
  static double get paddingMedium => _runtimeValues.paddingMedium;
  static double get paddingMediumLarge => _runtimeValues.paddingMediumLarge;
  static double get paddingLarge => _runtimeValues.paddingLarge;
  static double get paddingExtraLarge => _runtimeValues.paddingExtraLarge;
  static double get buttonHeightSmall => _runtimeValues.buttonHeightSmall;
  static double get buttonHeightMedium => _runtimeValues.buttonHeightMedium;
  static double get buttonHeightLarge => _runtimeValues.buttonHeightLarge;
  static double get buttonWidthSmall => _runtimeValues.buttonWidthSmall;
  static double get buttonWidthMedium => _runtimeValues.buttonWidthMedium;
  static double get buttonWidthLarge => _runtimeValues.buttonWidthLarge;
  /// Other runtime values
  static int get bankingWithdrawalMinimum => 50;

  /// Get the mobile prefixes
  ///
  /// @return List<Map<String, String>>
  List<Map<String, String>> getMobilePrefixes() {
    return mobilePrefixes;
  }

  /// Get the countries
  ///
  /// @return Map<String, String>
  Map<String, String> getCountries() {
    return countries;
  }

  /// Get the cities
  ///
  /// @return Map<String, Map<String, String>>
  Map<String, Map<String, String>> getCities() {
    return cities;
  }

  static String version() {
    return _instance!._version;
  }

  static String buildNumber() {
    return _instance!._buildNumber;
  }

  static String platform() {
    return _instance!._platform;
  }

  /// The user
  static getUser() => Adsplatter.user;

  /// Get the user's cookie
  ///
  /// @param bool decoded
  /// @return String
  static String getCookie({bool decoded = false}) {

    if(decoded) {
      return user.cookieDecoded;
    }

    return user.cookie;
  }

  /// @inheritdoc
  static dynamic convertCountryNameToCode(String countryName) {
    return AdsplatterHelper.convertCountryNameToCode(countryName);
  }

  /// @inheritdoc
  static Map<String, String> convertListToStringedMap(List list) {
    return AdsplatterHelper.convertListToStringedMap(list);
  }

  /// @inheritdoc
  static String convertObjectToJsonString(json) {
    return AdsplatterHelper.convertObjectToJsonString(json);
  }

  /// @inheritdoc
  static String encodeData(Map<String, dynamic> data) {
    return AdsplatterHelper.encodeData(data);
  }

  /// @inheritdoc
  static bool isValidEmail(String value) {
    return AdsplatterHelper.isValidEmail(value);
  }

  /// @inheritdoc
  static bool isValidMobile(String value) {
    return AdsplatterHelper.isValidMobile(value);
  }

  /// @inheritdoc
  static bool mobileHasPrefix(String value) {
    return AdsplatterHelper.mobileHasPrefix(value);
  }

  /// @inheritdoc
  static String mobileExtractPrefix(String value) {
    return AdsplatterHelper.mobileExtractPrefix(value);
  }

  /// @inheritdoc
  static String removeMobilePrefix(String value) {
    return AdsplatterHelper.removeMobilePrefix(value);
  }

  /// @inheritdoc
  static Future<http.Response> sendGetRequest(String url, {Map? headers}) {
    return AdsplatterHelper.sendGetRequest(url, headers: headers);
  }

  /// @inheritdoc
  static Future<http.Response> sendPostRequest(String url, dynamic postData, {Map? headers}) {
    return AdsplatterHelper.sendPostRequest(url, postData, headers: headers);
  }

  /// @inheritdoc
  static void showSnackBarBottom(BuildContext context, String message, {IconData? icon, Color? backgroundColor, Duration duration = const Duration(seconds: 3)}) {
    return AdsplatterHelper.showSnackBarBottom(context, message, icon: icon, backgroundColor: backgroundColor, duration: duration);
  }

  /// @inheritdoc
  static Future<String> assetPath(BuildContext context, String asset) {
    return AdsplatterHelper.assetPath(context, asset);
  }
}
