import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:adsplatter/widgets/adsplatter_logo_responsive.dart';
import 'package:adsplatter/helpers/adsplatter.dart';

class NoInternetConnectionScreen extends StatelessWidget {

  const NoInternetConnectionScreen({super.key});

  @override
  Widget build(BuildContext context) {

    Adsplatter().runtime(context);

    return Scaffold(
      body: Center(
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: const AdsplatterWidgetFullLogo(),
                  ),
                ),
                Icon(Icons.wifi_off, size: Adsplatter.imageSizeMedium, color: Colors.grey),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(AppLocalizations.of(context)!.noInternetConnection, style: TextStyle(fontSize: Adsplatter.fontSizeH6, color: Colors.grey)),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(AppLocalizations.of(context)!.checkInternetConnection, style: TextStyle(fontSize: Adsplatter.fontSizeParagraph, color: Colors.grey)),
                ),
                // Add a button to restart the app
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: ElevatedButton(
                    onPressed: () {
                      SystemNavigator.pop(); // Closes the app
                    },
                    child: Text("Close"), // Add your localized restart text
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
