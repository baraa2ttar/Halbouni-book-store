import 'package:adv/Features/Home/presentation/views/widgets/collapsible_description.dart';
import 'package:adv/core/constant/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _pump(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: SizedBox(width: 200, child: child),
    ),
  );
}

void main() {
  group('CollapsibleDescription', () {
    testWidgets('renders nothing when the description is empty', (tester) async {
      await tester.pumpWidget(
        _pump(const CollapsibleDescription(
          description: '',
          hasBookDetails: false,
        )),
      );
      expect(find.text(AppStrings.descriptionHeading), findsNothing);
      expect(find.text(AppStrings.aboutThisBook), findsNothing);
      expect(find.text(AppStrings.readMore), findsNothing);
    });

    testWidgets('renders nothing when the description is null', (tester) async {
      await tester.pumpWidget(
        _pump(const CollapsibleDescription(
          description: null,
          hasBookDetails: true,
        )),
      );
      expect(find.text(AppStrings.aboutThisBook), findsNothing);
      expect(find.text(AppStrings.descriptionHeading), findsNothing);
      expect(find.text(AppStrings.readMore), findsNothing);
    });

    testWidgets('shows a short description fully with no toggle', (tester) async {
      const short = 'A short book description.';
      await tester.pumpWidget(
        _pump(const CollapsibleDescription(
          description: short,
          hasBookDetails: false,
        )),
      );
      expect(find.text(AppStrings.descriptionHeading), findsOneWidget);
      expect(find.text(AppStrings.aboutThisBook), findsNothing);
      expect(find.text(short), findsOneWidget);
      expect(find.text(AppStrings.readMore), findsNothing);
      expect(find.text(AppStrings.showLess), findsNothing);
    });

    testWidgets('uses "About this book" when book details exist', (tester) async {
      await tester.pumpWidget(
        _pump(const CollapsibleDescription(
          description: 'Has an author row.',
          hasBookDetails: true,
        )),
      );
      expect(find.text(AppStrings.aboutThisBook), findsOneWidget);
      expect(find.text(AppStrings.descriptionHeading), findsNothing);
    });

    testWidgets('collapses a long description and toggles on tap', (tester) async {
      // Give the surface enough height that the expanded text never overflows.
      tester.view.physicalSize = const Size(300, 4000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final long =
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. ' * 12;
      await tester.pumpWidget(
        _pump(CollapsibleDescription(description: long, hasBookDetails: true)),
      );

      expect(find.text(AppStrings.aboutThisBook), findsOneWidget);
      // Collapsed: toggle says "Read more" and the full text is the Text data.
      expect(find.text(AppStrings.readMore), findsOneWidget);
      expect(find.text(AppStrings.showLess), findsNothing);
      expect(find.text(long), findsOneWidget);

      // Expand.
      await tester.tap(find.text(AppStrings.readMore));
      await tester.pump();
      expect(find.text(AppStrings.showLess), findsOneWidget);
      expect(find.text(AppStrings.readMore), findsNothing);
      expect(find.text(long), findsOneWidget);

      // Collapse again.
      await tester.tap(find.text(AppStrings.showLess));
      await tester.pump();
      expect(find.text(AppStrings.readMore), findsOneWidget);
      expect(find.text(AppStrings.showLess), findsNothing);
    });
  });
}
