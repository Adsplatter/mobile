import 'package:flutter_user/user.dart';


/// User class
class AdsplatterUser extends User {

  /// The user
  final User user;

  /// Other data
  final String _bankingCurrency = 'GBP';
  final String _bankingCurrencySymbol = '£';

  /// Getters
  String get bankingCurrency => _bankingCurrency;
  String get bankingCurrencySymbol => _bankingCurrencySymbol;

  AdsplatterUser({
    required super.cookie,
    required super.loggedIn,
    required super.status,
    required super.uqid,
    required super.email,
    required super.mobile,
    required super.password,
    required super.provider,
    required super.accountCreated,
    required super.lastLogin,
    required super.birthDate,
    required super.firstName,
    required super.lastName,
    required super.addressLine1,
    required super.addressLine2,
    required super.city,
    required super.state,
    required super.postcode,
    required super.country
  }) :
        user = User(
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
