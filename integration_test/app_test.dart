
import 'package:firebase_crud_example/database_interface.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:firebase_crud_example/app.dart' as app;

/**
TO TEST ON FLUTTER / ANDROID or FLUTTER / IOS ,
  OPEN THE SIMULATOR AND RUN NEXT COMMAND
flutter drive --driver=test_driver/integration_driver.dart --target=integration_test/app_test.dart
*/

// ignore: slash_for_doc_comments
/**
TO TEST ON FLUTTER WEB (CHROME), INSTALL CHROMEDRIVER at:
    https://chromedriver.chromium.org/downloads

AND RUN NEXT 2 COMMANDS ON 2 DIFFERENT TERMINALS
chromedriver --port=4444
flutter drive --driver=test_driver/integration_driver.dart --target=integration_test/app_test.dart -d web-server

 */

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async{
    await DatabaseInterface().initializeApp();
  });

  testWidgets('Pressing delete button '
              'gives error when no record is found',
      (WidgetTester tester) async {
        await tester.pumpWidget(app.FirebaseCrudExampleApp(),Duration(seconds: 2));

        expect(
          find.textContaining('Ready!'),
          findsOneWidget,
        );

        await tester.drag(find.byKey(Key('scroller')), const Offset(0.0, -300));
        await tester.pumpAndSettle();

        expect(
          find.textContaining('Delete',skipOffstage: false),
          findsOneWidget,
        );

        await tester.tap(find.bySemanticsLabel('Delete'));
        await tester.pumpAndSettle(Duration(seconds: 1));

        expect(
          find.textContaining('ERROR'),
          findsOneWidget,
        );
      }
  );

  testWidgets('Pressing update button '
              'gives error when no record is found',
          (WidgetTester tester) async {


            await tester.pumpWidget(app.FirebaseCrudExampleApp(),Duration(seconds: 2));

            expect(
          find.textContaining('Ready!'),
          findsOneWidget,
        );

        await tester.drag(find.byKey(Key('scroller')), const Offset(0.0, -300));
        await tester.pumpAndSettle();

        await tester.tap(find.bySemanticsLabel('Update',skipOffstage: false));
        await tester.pumpAndSettle(Duration(seconds: 1));

        expect(
          find.textContaining('ERROR'),
          findsOneWidget,
        );
      }
  );


  testWidgets('Pressing read button '
              'gives error when no record is found',
          (WidgetTester tester) async {


            await tester.pumpWidget(app.FirebaseCrudExampleApp(),Duration(seconds: 2));

            expect(
          find.textContaining('Ready!'),
          findsOneWidget,
        );
        await tester.drag(find.byKey(Key('scroller')), const Offset(0.0, -300));
        await tester.pumpAndSettle();

        await tester.tap(find.bySemanticsLabel('Read',skipOffstage: false));
        await tester.pumpAndSettle(Duration(seconds: 1));

        expect(
          find.textContaining('ERROR'),
          findsOneWidget,
        );
      }
  );

  testWidgets('creating will show a success, '
              'then updating will show a success '
              'then the value will be Alessandro '
              'then deleting will show a success ',
          (WidgetTester tester) async {

            await tester.pumpWidget(app.FirebaseCrudExampleApp());



            expect(
          find.textContaining('Ready!'),
          findsOneWidget,
        );

            //await tester.drag(find.byKey(Key('scroller')), const Offset(0.0, -300));
            //await tester.pumpAndSettle();

        await tester.tap(find.bySemanticsLabel('Create'));
        await tester.pumpAndSettle(Duration(seconds: 1));

        expect(
          find.textContaining('Success'),
          findsOneWidget,
        );

            await tester.drag(find.byKey(Key('scroller')), const Offset(0.0, -300));
            await tester.pumpAndSettle();


        await tester.tap(find.bySemanticsLabel('Update'));
        await tester.pumpAndSettle(Duration(seconds: 1));

        expect(find.textContaining('Alessandro'),
            findsOneWidget);

        expect(
          find.textContaining('Success'),
          findsOneWidget,
        );


            await tester.drag(find.byKey(Key('scroller')), const Offset(0.0, -300));
            await tester.pumpAndSettle();




        await tester.tap(find.bySemanticsLabel('Delete'));
        await tester.pumpAndSettle(Duration(seconds: 1));

        expect(
          find.textContaining('Success'),
          findsOneWidget,
        );
      }
  );




}

