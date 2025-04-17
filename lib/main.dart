import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:adsplatter/skeleton/src/AdsplatterSystemController.dart';
import 'package:adsplatter/skeleton/src/AdsplatterSystemService.dart';
import 'package:adsplatter/skeleton/src/AdsplatterSystemView.dart';
import 'helpers/adsplatter.dart';

// Mandatory if the App is obfuscated or using Flutter 3.1+
@pragma('vm:entry-point')

void main() async {
  /**
   * Ensure that the WidgetsBinding is initialized.
   */
  WidgetsBinding binding = WidgetsFlutterBinding.ensureInitialized();

  /// Get the system controller
  final AdsplatterSystemController controller = AdsplatterSystemController( AdsplatterSystemService() );

  /// Load the user's preferred theme while the splash screen is displayed.
  /// This prevents a sudden theme change when the app is first displayed.
  await controller.init();

  Adsplatter adsplatter = Adsplatter();

  /**
   * Check if the device has an internet connection.
   * If the device does NOT have an internet connection, display a message to the user.
   */
  try {
    // Lookup example.com to check if the device has an internet connection.
    // example.com is a domain reserved by IANA and less likely to be blacklisted than Google.
    // Might be replaced with "adsplatter.com" in the future.
    final List<InternetAddress> result = await InternetAddress.lookup('example.com');

    // If the result is not empty and the raw address is not empty, then the device has an internet connection.
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      // Do nothing
    }
  } on SocketException catch (_) {
    /**
     * If the device does NOT have an internet connection, display a message to the user.
     */
    runApp(AdsplatterSystemView(applicationController: controller, routeName: '/no-internet-connection'));
    return;
  }

  /**
   * Check if an update is required.
   */
  try {
    // Wait for the Adsplatter Mobile Application to initialize.
    var adsplatterInit = await adsplatter.init();

    // If an update is required, show a message.
    if(adsplatterInit.needsUpdate == true) {
      runApp(AdsplatterSystemView(applicationController: controller, routeName: '/must-update'));
      return;
    }

  } catch(e) {
    // Display an error message to the user.
    runApp(AdsplatterSystemView(applicationController: controller, routeName: '/initialization-error'));
    return;
  }

  /// Load the SharedPreferences
  SharedPreferences prefs = await SharedPreferences.getInstance();

  /**
   * Load the user data from the SharedPreferences (local storage),
   * if it exists.
   */
  Adsplatter.setNewUser(
    cookie: prefs.getString('userLogInCookie') ?? '',
    loggedIn: prefs.getBool('userLoggedIn') ?? false,
    status: prefs.getInt('userStatus') ?? 0,
    uqid: prefs.getString('userUqid') ?? '', // "UQID" is a form of unique identifier (UUID)
    email: prefs.getString('userEmail') ?? '',
    mobile: prefs.getString('userMobile') ?? '',
    password: prefs.getString('userPassword') ?? '',
    provider: prefs.getString('userAccountProvider') ?? '',
    accountCreated: prefs.getInt('userAccountCreated') ?? 0,
    lastLogin: prefs.getInt('userLastLoginTimestamp') ?? 0,
    birthDate: prefs.getInt('userBirthDate') ?? 0,
    firstName: prefs.getString('userFirstName') ?? '',
    lastName: prefs.getString('userLastName') ?? '',
    addressLine1: prefs.getString('userAddressLine1') ?? '',
    addressLine2: prefs.getString('userAddressLine2') ?? '',
    city: prefs.getString('userCity') ?? '',
    state: prefs.getString('userState') ?? '',
    postcode: prefs.getString('userPostcode') ?? '',
    country: prefs.getString('userCountry') ?? '',
  );

  Adsplatter().checkLoginStatus();

  bool isLoggedIn = prefs.getBool('userLoggedIn') ?? false;

  // If the user is logged in, show the homepage
  if(isLoggedIn == true) {
    Adsplatter().updateUserData(); // Update the user's data store on the device on login
    runApp(AdsplatterSystemView(applicationController: controller, routeName: '/home'));
    return;
  }

  // If the user is NOT logged in, let the controller handle the login process
  runApp(AdsplatterSystemView(applicationController: controller));
}