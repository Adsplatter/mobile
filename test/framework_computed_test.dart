import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:framework/computed.dart'; // Replace with your actual import

void main() {
  testWidgets('Computed class initializes correctly', (WidgetTester tester) async {
    // Define test screen size
    const testSize = Size(1080, 1920);

    // Build the widget tree with MediaQuery and Theme
    await tester.pumpWidget(
      MediaQuery(
        data: MediaQueryData(size: testSize),
        child: MaterialApp(
          theme: ThemeData(platform: TargetPlatform.android),
          home: Builder(
            builder: (BuildContext context) {
              // Initialize Computed with the test context
              final computed = Computed(context: context);

              // Perform your assertions here
              expect(computed.screenWidth, testSize.width);
              expect(computed.screenHeight, testSize.height);
              expect(computed.isPortrait, true);
              expect(computed.isLandscape, false);
              expect(computed.platform, TargetPlatform.android);

              // You can also test specific computed sizes
              expect(computed.fontSizeH1, isNonZero);
              expect(computed.imageSizeMedium, isNonZero);
              expect(computed.iconSizeLarge, isNonZero);
              expect(computed.marginMedium, isNonZero);
              expect(computed.paddingLarge, isNonZero);
              expect(computed.buttonHeightMedium, isNonZero);
              expect(computed.buttonWidthLarge, isNonZero);

              return const SizedBox.shrink(); // Return an empty widget
            },
          ),
        ),
      ),
    );
  });
}

// Custom matcher to check for non-zero values
final Matcher isNonZero = isNot(equals(0.0));
