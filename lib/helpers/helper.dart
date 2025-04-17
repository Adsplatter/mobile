import 'dart:convert';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:flutter_network/network_service.dart';
import 'constants.dart';
import 'adsplatter.dart';

mixin AdsplatterHelper {

  /// Notifications
  /// @todo Not for public release (yet)
  ///static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// GPS
  /// @todo Not for public release (yet)
  /// @var Location location
  Timer? locationUpdatesTimer;

  /// Convert a country name to a country code
  static dynamic convertCountryNameToCode(String countryName) {
    return Constants.countries.entries.firstWhere((element) => element.value == countryName).key;
  }

  /// Show a snackbar at the bottom of the screen
  static void showSnackBarBottom(BuildContext context, String message, {IconData? icon, Color? backgroundColor, Duration duration = const Duration(seconds: 3)}) {

    // Return if not mounted
    if(context.mounted == false) {
      return;
    }

    backgroundColor ??= const Color(0xFF323232);

    final snackBar = SnackBar(
      key: UniqueKey(),
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      duration: duration,
      elevation: 0,
      showCloseIcon: true,
      backgroundColor: backgroundColor,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  /// Convert an object into a json string (without using Dart's jsonEncode)
  static String convertObjectToJsonString(dynamic object) {
    String finalString = '';

    if(object is Map) {
      finalString += '{';
      object.forEach((key, value) {
        finalString += '"$key":';
        finalString += convertObjectToJsonString(value);
        finalString += ',';
      });
      finalString = finalString.substring(0, finalString.length - 1);
      finalString += '}';
    } else if(object is List) {
      finalString += '[';
      for (var element in object) {
        finalString += convertObjectToJsonString(element);
        finalString += ',';
      }
      finalString = finalString.substring(0, finalString.length - 1);
      finalString += ']';
    } else if(object is String) {
      finalString += '"$object"';
    } else {
      finalString += object.toString();
    }

    return finalString;
  }

  /// Convert a List to a Map<String, String>.
  /// @return Map<String, String>
  static Map<String, String> convertListToStringedMap(List list) {
    Map<String, String> resultMap = {};

    for (int i = 0; i < list.length; i++) {
      resultMap[i.toString()] = list[i].toString();
    }

    return resultMap;
  }

  /// Encode data eg. body data to be sent in a POST request
  /// @return String
  static String encodeData(Map<String, dynamic> data, [String prefix = '']) {
    List<String> queryString = [];
    data.forEach((key, value) {
      String fullKey = prefix.isEmpty ? key : '$prefix[$key]';
      if (value is Map<String, dynamic>) {
        queryString.add(encodeData(value, fullKey));
      } else if (value is List) {
        for (int i = 0; i < value.length; i++) {
          if (value[i] is Map) {
            queryString.add(encodeData(value[i], '$fullKey[$i]'));
          } else {
            queryString.add('$fullKey[$i]=${Uri.encodeComponent(value[i].toString())}');
          }
        }
      } else {
        queryString.add('$fullKey=${Uri.encodeComponent(value.toString())}');
      }
    });
    return queryString.join('&');
  }

  /// Function to validate email using regex
  /// @return bool
  static bool isValidEmail(String value) {
    // Regex pattern for email validation
    const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    final regex = RegExp(pattern);
    return regex.hasMatch(value);
  }

  /// Function to validate mobile number using regex
  /// @return bool
  static bool isValidMobile(String value) {
    // Regex pattern for mobile number validation
    const pattern = r'^(\+[0-9\- \s]{8,15}|[0-9\- \s]{8,15})$';
    final regex = RegExp(pattern);
    return regex.hasMatch(value);
  }

  /// Check if the mobile number has a prefix
  /// Only used for testing.
  /// @fixme Bug: fails when a number without prefix is in the list of prefixes
  /// @return bool
  static bool mobileHasPrefix(String value) {
    // Check if one of the prefixes is present in the mobile number
    for (var prefixes in Adsplatter.mobilePrefixes) {

      // loop through the prefixes Map<dynamic, dynamic>
      for (var prefix in prefixes.entries) {
        if (value.startsWith(prefix.value)) {
          // Make sure mobile number without the prefix is valid
          if(isValidMobile(removeMobilePrefix(value))) {
            return true;
          }
        }
      }
    }
    return false;
  }

  /// Extract the mobile prefix
  /// Only used for testing.
  /// @fixme Bug: fails when a number without prefix is in the list of prefixes
  /// @return String
  static String mobileExtractPrefix(String value) {

    // Make sure the mobile has a +
    if(!value.startsWith('+')) {
      value = '+$value';
    }

    // Check if one of the prefixes is present in the mobile number
    for (var prefixes in Adsplatter.mobilePrefixes) {
      // loop through the prefixes Map<dynamic, dynamic>
      for (var prefix in prefixes.entries) {
        if (value.startsWith(prefix.value)) {
          // Make sure mobile number without the prefix is valid
          if(isValidMobile(removeMobilePrefix(value))) {
            return prefix.value;
          }
        }
      }
    }

    return '';
  }

  /// Remove the mobile prefix
  /// Only used for testing.
  /// @fixme Bug: fails when a number without prefix is in the list of prefixes
  /// @return String
  static String removeMobilePrefix(String value) {

    // Make sure the mobile has a +
    if(! value.startsWith('+')) {
      value = '+$value';
    }

    // Check if one of the prefixes is present in the mobile number
    for (var prefixes in Adsplatter.mobilePrefixes) {
      // loop through the prefixes Map<dynamic, dynamic>
      for (var prefix in prefixes.entries) {
        if (value.startsWith(prefix.value)) {
          return value.replaceAll(prefix.value, '');
        }
      }
    }

    return value;
  }

  /// Returns the path of the right file asset
  /// @return string
  static Future<String> assetPath(BuildContext context, String asset) async {

    String platformPath;

    if (kIsWeb) {
      platformPath = 'web';
    } else {
      switch (defaultTargetPlatform) {
        case TargetPlatform.iOS:
          platformPath = 'ios';
          break;
        case TargetPlatform.android:
          platformPath = 'android';
          break;
        default:
          platformPath = 'default';  // Handle other platforms or fallback
      }
    }

    // Determine devicePixelRatio
    double devicePixelRatio = MediaQuery.of(context).devicePixelRatio;

    // Load the image
    final ByteData data = await rootBundle.load('assets/icon/$asset.png');
    final img.Image image = img.decodeImage(Uint8List.view(data.buffer))!;

    // Get original dimensions
    int originalWidth = image.width;
    int originalHeight = image.height;

    // Initialize resolutionPath and suffix
    String resolutionPath;
    String suffix;

    // Function to calculate proportional height
    int calculateProportionalHeight(int originalWidth, int originalHeight, int targetWidth) {
      return (originalHeight * targetWidth / originalWidth).floor();
    }

    // Determine Android resolutionPath and suffix
    if (platformPath == 'android') {
      if (devicePixelRatio >= 4.0) {
        resolutionPath = 'xxxhdpi';
        suffix = '${2048}x${calculateProportionalHeight(originalWidth, originalHeight, 2048)}';
      } else if (devicePixelRatio >= 3.0) {
        resolutionPath = 'xxhdpi';
        suffix = '${1536}x${calculateProportionalHeight(originalWidth, originalHeight, 1536)}';
      } else if (devicePixelRatio >= 2.0) {
        resolutionPath = 'xhdpi';
        suffix = '${1024}x${calculateProportionalHeight(originalWidth, originalHeight, 1024)}';
      } else if (devicePixelRatio >= 1.5) {
        resolutionPath = 'hdpi';
        suffix = '${768}x${calculateProportionalHeight(originalWidth, originalHeight, 768)}';
      } else if (devicePixelRatio >= 1.0) {
        resolutionPath = 'mdpi';
        suffix = '${512}x${calculateProportionalHeight(originalWidth, originalHeight, 512)}';
      } else {
        resolutionPath = 'ldpi';
        suffix = '${384}x${calculateProportionalHeight(originalWidth, originalHeight, 384)}';
      }
    }

    // Determine iOS resolutionPath and suffix
    else if (platformPath == 'ios') {
      if (devicePixelRatio >= 3.0) {
        resolutionPath = '3x';
        suffix = '${2048}x${calculateProportionalHeight(originalWidth, originalHeight, 2048)}';
      } else if (devicePixelRatio >= 2.0) {
        resolutionPath = '2x';
        suffix = '${1366}x${calculateProportionalHeight(originalWidth, originalHeight, 1366)}';
      } else {
        resolutionPath = '1x';
        suffix = '${683}x${calculateProportionalHeight(originalWidth, originalHeight, 683)}';
      }
    }

    // Determine Web resolutionPath and suffix
    else if (platformPath == 'web') {
      if (devicePixelRatio >= 3.0) {
        resolutionPath = '2048';
        suffix = '2048x2048';
      } else if (devicePixelRatio >= 2.0) {
        resolutionPath = '1024';
        suffix = '1024x1024';
      } else if (devicePixelRatio >= 1.5) {
        resolutionPath = '512';
        suffix = '512x512';
      } else if (devicePixelRatio >= 1.0) {
        resolutionPath = '256';
        suffix = '256x256';
      } else {
        resolutionPath = '128';
        suffix = '128x128';
      }
    }

    else {
      resolutionPath = 'default';
      suffix = 'default';
    }

    // Construct the path for Web, Android, and iOS
    if (platformPath == 'android' || platformPath == 'ios' || platformPath == 'web') {
      return 'assets/icon/$platformPath/$resolutionPath/$asset-$suffix.png';
    } else {
      return 'assets/icon/$asset.png';
    }
  }

  /// Decode a JSON string
  static jsonDecode(String body) {
    return json.decode(body);
  }

  /// Send a GET request
  ///
  /// @param String url
  /// @param Map headers
  /// @return Future<http.Response>
  static get sendGetRequest => HTTPNetworkService.sendGetRequest;

  /// Send a POST request
  ///
  /// @param String url
  /// @param dynamic postData
  /// @param Map headers
  /// @return Future<http.Response>
  static get sendPostRequest => HTTPNetworkService.sendPostRequest;
}

