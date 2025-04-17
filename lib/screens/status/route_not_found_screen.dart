import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:adsplatter/helpers/adsplatter.dart';

class RouteNotFoundScreen extends StatelessWidget {

  final String title;
  final String subtitle;
  final String message;
  final IconData icon;

  const RouteNotFoundScreen({
    super.key,
    this.title = '',
    this.subtitle = '',
    this.message = '',
    this.icon = Icons.error,
  });

  @override
  Widget build(BuildContext context) {

    // Check if the current theme is dark mode
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: title.isNotEmpty ? AppBar(
        title: Text(title),
      ) : null,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(padding: const EdgeInsets.all(20), child: Text(subtitle, style: TextStyle(fontSize: Adsplatter.fontSizeH6, color: isDarkMode ? Colors.white70 : Colors.grey))),
                Padding(padding: const EdgeInsets.all(30), child: Icon(icon, size: Adsplatter.imageSizeMedium, color: isDarkMode ? Colors.white70 : Colors.grey)),
                Padding(padding: const EdgeInsets.all(20), child: Text(message.isEmpty ? AppLocalizations.of(context)!.nothingHere : message, style: TextStyle(fontSize: Adsplatter.fontSizeParagraph, color: isDarkMode ? Colors.white70 : Colors.grey), textAlign: TextAlign.center)),
              ],
            )
          ],
        ),
      ),
    );
  }
}