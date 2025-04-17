import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:adsplatter/helpers/adsplatter.dart';

class AdsplatterWidgetFullLogo extends StatefulWidget {

  final ThemeData? theme;

  const AdsplatterWidgetFullLogo({super.key, this.theme});

  @override
  AdsplatterWidgetFullLogoState createState() => AdsplatterWidgetFullLogoState();
}

class AdsplatterWidgetFullLogoState extends State<AdsplatterWidgetFullLogo> {
  late Future<String> imageAssetPath;

  @override
  void initState() {
    super.initState();
    imageAssetPath = _loadImageAssetPath();
  }

  Future<String> _loadImageAssetPath() async {
    // Wait until the framework is fully initialized and context is ready
    await Future.delayed(Duration.zero);

    // First, determine dark mode based on the theme, if provided
    if (widget.theme != null) {
      return widget.theme!.brightness == Brightness.dark
          ? Adsplatter.assetPath(context, "logo-adsplatter-full-logo-left-blue-light-sml")
          : Adsplatter.assetPath(context, "logo-adsplatter-full-logo-left-blue-dark-sml");
    }

    // Determine dark mode and fetch the asset path
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Return the asset path based on dark mode
    return isDarkMode
        ? Adsplatter.assetPath(context, "logo-adsplatter-full-logo-left-blue-light-sml")
        : Adsplatter.assetPath(context, "logo-adsplatter-full-logo-left-blue-dark-sml");
  }

  @override
  Widget build(BuildContext context) {
    // Calculate max full height based on the width and image aspect ratio
    double imageWidth = 3000;
    double imageHeight = 424;

    // Calculate max full width
    double fullWidth = MediaQuery.of(context).size.width;
    double fullHeight = fullWidth * (imageHeight / imageWidth);

    return FutureBuilder<String>(
      future: imageAssetPath,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            width: 50,
            height: 50,
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          return SizedBox(
            width: fullWidth,
            height: fullHeight,
            child: Image.asset(
              snapshot.data!,
              fit: BoxFit.contain,
              scale: 1.0,
              semanticLabel: 'Adsplatter logo',
              repeat: ImageRepeat.noRepeat,
              gaplessPlayback: false,
              filterQuality: FilterQuality.high,
              alignment: Alignment.center,
              frameBuilder: (BuildContext context, Widget child, int? frame, bool wasSynchronouslyLoaded) {
                return child;
              },
            ),
          );
        } else {
          return SizedBox(
            width: 50,
            height: 50,
            child: Center(child: Text(AppLocalizations.of(context)!.noDataAvailable)),
          );
        }
      },
    );
  }
}
