import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:adsplatter/widgets/adsplatter_logo_responsive.dart';
import 'package:adsplatter/helpers/adsplatter.dart';

class UpdateRequiredScreen extends StatelessWidget {

  const UpdateRequiredScreen({super.key});

  @override
  Widget build(BuildContext context) {

    // Check if the current theme is dark mode
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Center(
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.all(30),
                  child: AdsplatterWidgetFullLogo(),
                ),
                Icon(Icons.update, size: Adsplatter.imageSizeMedium, color: isDarkMode ? Colors.white70 : Colors.grey),
                Padding(padding: const EdgeInsets.all(20), child: Text(AppLocalizations.of(context)!.updateRequired, style: TextStyle(fontSize: Adsplatter.fontSizeH6, color: isDarkMode ? Colors.white70 : Colors.grey), textAlign: TextAlign.center)),
                Padding(padding: const EdgeInsets.all(20), child: Text(AppLocalizations.of(context)!.updatePrompt, style: TextStyle(fontSize: Adsplatter.fontSizeParagraph, color: isDarkMode ? Colors.white70 : Colors.grey))),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: ElevatedButton(
                    onPressed: () {
                      SystemNavigator.pop(); // Closes the app
                    },
                    child: const Text("Close"), // Add your localized restart text
                  ),
                ),
              ],
            ),
          ],
        )
      ),
    );
  }
}