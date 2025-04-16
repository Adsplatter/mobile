import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ext/image.dart';
import 'package:flutter_ext/string.dart';

void main() {
  group('ImageExtension', () {
    testWidgets('cacheSize and cacheSizeDouble return expected values', (WidgetTester tester) async {
      // Need to wrap in a widget to access BuildContext
      double testValue = 10;

      await tester.pumpWidget(
        Builder(
          builder: (context) {
            final intSize = testValue.cacheSize(context);
            final doubleSize = testValue.cacheSizeDouble(context);

            final dpr = MediaQuery.of(context).devicePixelRatio;
            expect(intSize, (testValue * dpr).toInt());
            expect(doubleSize, testValue * dpr);

            return const Placeholder(); // dummy child
          },
        ),
      );
    });
  });

  group('CapExtension', () {
    test('String extensions return expected results', () {
      const testString = 'hello world';

      expect(testString.inCaps, 'Hello world');
      expect(testString.uppercaseFirst, 'Hello world');
      expect(testString.allInCaps, 'HELLO WORLD');
      expect(testString.capitalizeFirstOfEach, 'Hello World');
    });
  });
}