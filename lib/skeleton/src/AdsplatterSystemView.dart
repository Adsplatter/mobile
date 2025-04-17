import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:adsplatter/helpers/adsplatter.dart';
import 'package:adsplatter/screens/testing_screen.dart';
import 'package:adsplatter/screens/status/route_not_found_screen.dart';
import 'package:adsplatter/screens/status/update_required_screen.dart';
import 'package:adsplatter/screens/status/no_internet_connection_screen.dart';
import 'AdsplatterSystemController.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class AdsplatterSystemView extends StatelessWidget {

  final String? routeName;

  final AdsplatterSystemController applicationController;

  const AdsplatterSystemView({
    super.key,
    required this.applicationController,
    this.routeName
  });

  @override
  Widget build(BuildContext context) {

    //MaterialApp.router();

    return ListenableBuilder(
      listenable: applicationController,
      builder: (BuildContext context, Widget? child) {

        // Initialize the Adsplatter runtime environment
        Adsplatter().runtime(context);

        /**
         * Initialize the ThemeData for the application.
         */

        /// Normal Theme
        ThemeData themeData = ThemeData(
          brightness: Brightness.light,
          scaffoldBackgroundColor: Colors.grey[50],
          colorScheme: const ColorScheme.light(
            primary: Color.fromRGBO(26, 130, 255, 1),
            secondary: Color.fromRGBO(26, 130, 255, 1),
            surface: Colors.white,
            error: Colors.red,
            onPrimary: Colors.white,
            onSecondary: Colors.white,
            onSurface: Colors.black,
            onError: Colors.white,
          ),
          appBarTheme: AppBarTheme(
            surfaceTintColor: Colors.white,
            backgroundColor: Colors.grey[50],
            foregroundColor: Colors.black,
            centerTitle: true,
            titleTextStyle: const TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
            elevation: 0,
            shadowColor: Colors.black.withOpacity(0.2),
            iconTheme: const IconThemeData(
              color: Colors.black,
            ),
          ),
          textTheme: TextTheme(
            displayLarge: TextStyle(
                fontSize: Adsplatter.fontSizeH6,
                fontWeight: FontWeight.w300
            ),
            displayMedium: TextStyle(
                fontSize: Adsplatter.fontSizeParagraph,
                fontWeight: FontWeight.w300
            ),
            displaySmall: TextStyle(
                fontSize: Adsplatter.fontSizeSmall,
                fontWeight: FontWeight.w300
            ),
            headlineLarge: TextStyle(
                fontSize: Adsplatter.fontSizeH1,
                fontWeight: FontWeight.w300
            ),
            headlineMedium: TextStyle(
                fontSize: Adsplatter.fontSizeH2,
                fontWeight: FontWeight.w300
            ),
            headlineSmall: TextStyle(
                fontSize: Adsplatter.fontSizeH3,
                fontWeight: FontWeight.w300
            ),
            bodyLarge: TextStyle(
                fontSize: Adsplatter.fontSizeH6,
                fontWeight: FontWeight.w300
            ),
            bodyMedium: TextStyle(
                fontSize: Adsplatter.fontSizeParagraph,
                fontWeight: FontWeight.w300
            ),
            bodySmall: TextStyle(
                fontSize: Adsplatter.fontSizeSmall,
                fontWeight: FontWeight.w300
            ),
            labelLarge: TextStyle(
                fontSize: Adsplatter.fontSizeParagraph,
                fontWeight: FontWeight.w300
            ),
            labelMedium: TextStyle(
                fontSize: Adsplatter.fontSizeSmall,
                fontWeight: FontWeight.w300
            ),
            labelSmall: TextStyle(
                fontSize: Adsplatter.fontSizeExtraSmall,
                fontWeight: FontWeight.w300
            ),
          ),
          progressIndicatorTheme: const ProgressIndicatorThemeData(
            color: Color.fromRGBO(26, 130, 255, 1),
            circularTrackColor: Colors.transparent,
          ),
          useMaterial3: true,
        );

        /// Dark Theme
        ThemeData themeDataDark = ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.grey[900],
          colorScheme: const ColorScheme.dark(
            primary: Color.fromRGBO(26, 130, 255, 1),
            secondary: Color.fromRGBO(26, 130, 255, 1),
            surface: Colors.grey,
            error: Colors.red,
            onPrimary: Colors.white,
            onSecondary: Colors.white,
            onSurface: Colors.white,
            onError: Colors.white,
          ),
          appBarTheme: AppBarTheme(
            surfaceTintColor: Colors.grey[800],
            backgroundColor: Colors.grey[900],
            foregroundColor: Colors.white,
            centerTitle: true,
            titleTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
            elevation: 0,
            shadowColor: Colors.black.withOpacity(0.2),
            iconTheme: const IconThemeData(
              color: Colors.white,
            ),
          ),
          textTheme: TextTheme(
            displayLarge: TextStyle(
                fontSize: Adsplatter.fontSizeH6,
                fontWeight: FontWeight.w300,
                color: Colors.white
            ),
            displayMedium: TextStyle(
                fontSize: Adsplatter.fontSizeParagraph,
                fontWeight: FontWeight.w300,
                color: Colors.white
            ),
            displaySmall: TextStyle(
                fontSize: Adsplatter.fontSizeSmall,
                fontWeight: FontWeight.w300,
                color: Colors.white
            ),
            headlineLarge: TextStyle(
                fontSize: Adsplatter.fontSizeH1,
                fontWeight: FontWeight.w300,
                color: Colors.white
            ),
            headlineMedium: TextStyle(
                fontSize: Adsplatter.fontSizeH2,
                fontWeight: FontWeight.w300,
                color: Colors.white
            ),
            headlineSmall: TextStyle(
                fontSize: Adsplatter.fontSizeH3,
                fontWeight: FontWeight.w300,
                color: Colors.white
            ),
            bodyLarge: TextStyle(
                fontSize: Adsplatter.fontSizeH6,
                fontWeight: FontWeight.w300,
                color: Colors.white
            ),
            bodyMedium: TextStyle(
                fontSize: Adsplatter.fontSizeParagraph,
                fontWeight: FontWeight.w300,
                color: Colors.white
            ),
            bodySmall: TextStyle(
                fontSize: Adsplatter.fontSizeSmall,
                fontWeight: FontWeight.w300,
                color: Colors.white
            ),
            labelLarge: TextStyle(
                fontSize: Adsplatter.fontSizeParagraph,
                fontWeight: FontWeight.w300,
                color: Colors.white
            ),
            labelMedium: TextStyle(
                fontSize: Adsplatter.fontSizeSmall,
                fontWeight: FontWeight.w300,
                color: Colors.white
            ),
            labelSmall: TextStyle(
                fontSize: Adsplatter.fontSizeExtraSmall,
                fontWeight: FontWeight.w300,
                color: Colors.white
            ),
          ),
          progressIndicatorTheme: const ProgressIndicatorThemeData(
            color: Color.fromRGBO(26, 130, 255, 1),
            circularTrackColor: Colors.transparent,
          ),
          useMaterial3: true,
        );

        return MaterialApp(
          /// Our custom config
          debugShowCheckedModeBanner: false,

          // We do not provide an initial route to the MaterialApp (optional).
          // We use '/' or '/login' as the initial route to our application.
          // ( see switch statement below )

          // Providing a restorationScopeId allows the Navigator built by the
          // MaterialApp to restore the navigation stack when a user leaves and
          // returns to the app after it has been killed while running in the
          // background.
          restorationScopeId: 'app',

          // Provide the generated AppLocalizations to the MaterialApp. This
          // allows descendant Widgets to display the correct translations
          // depending on the user's locale.
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English, no country code
          ],

          // Use AppLocalizations to configure the correct application title
          // depending on the user's locale.
          //
          // The appTitle is defined in .arb files found in the localization
          // directory.
          onGenerateTitle: (BuildContext context) =>
          AppLocalizations.of(context)!.appTitle,

          // Define a light and dark color theme. Then, read the user's
          // preferred ThemeMode (light, dark, or system default) from the
          // applicationController to display the correct theme.
          theme: themeData,
          darkTheme: themeDataDark,
          themeMode: applicationController.themeMode,

          // Define a function to handle named routes in order to support
          // Flutter web url navigation and deep linking.
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {

                String navigateToRoute = routeName ?? routeSettings.name ?? '/';
                var arguments = routeSettings.arguments as Map<String, dynamic>?;

                switch (navigateToRoute) {
                /// Handle the login page
                  case '/':
                  case TestingScreen.routeName:
                    return const TestingScreen();

                    /// Handle the no internet connection error
                  case '/no-internet-connection':
                    return const NoInternetConnectionScreen();

                    /// Handle the update error
                  case '/must-update':
                    return const UpdateRequiredScreen();

                /// Handle the initialization error (see comment below)
                  case '/initialization-error':

                  /**
                   * Must to display a pretty error message (?) to the user due
                   * to Apple policies. An initialization error message is not
                   * acceptable. Needed to publish on App Store.
                   */
                    return const NoInternetConnectionScreen();

                /// Handle default
                  default:
                    return const RouteNotFoundScreen(
                      title: 'ERROR',
                      message: 'An error occurred. We were notified. Please restart the app.',
                    );
                }
              },
            );
          },

          // Provide the generated AppLocalizations to the MaterialApp. This
          // allows descendant Widgets to display the correct translations
          // depending on the user's locale.
          builder: (context, child) {
            // Handle cases where child is null
            if (child == null) {
              return const Center(
                child: CircularProgressIndicator(), // Or a custom loading/error widget
              );
            }

            // Determine the status bar style based on the current theme
            final isDarkMode = Theme.of(context).brightness == Brightness.dark;
            final statusBarColor = isDarkMode ? Colors.black : Colors.grey[50];
            Brightness statusBarIconBrightness = isDarkMode ? Brightness.light : Brightness.dark;

            SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
              statusBarColor: statusBarColor,
              statusBarIconBrightness: statusBarIconBrightness,
            ));

            // Encapsulate the SafeArea and AnnotatedRegion in a separate widget
            return AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle(
                  statusBarColor: statusBarColor,
                  statusBarIconBrightness: statusBarIconBrightness,
                ),
                child: child
            );
          },
        );
      },
    );
  }
}
