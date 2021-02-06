import 'package:firebase_crud_example/helper.dart';
import 'package:flutter/foundation.dart' show Key;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:firebase_crud_example/app.dart' as app;

import 'package:firebase_crud_example/services/database_interface.dart'
if (dart.library.html)
 'package:firebase_crud_example/web_database_interface.dart';

/**
TO TEST ON ANDROID, WEAROS or IOS ,
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
    await DatabaseInterface().init(()=>Helper.stopLoading);
  });

  testWidgets('Pressing delete button '
              'gives error when no record is found',
      (WidgetTester tester) async {
        await tester.pumpWidget(app.FirebaseCrudExampleApp());

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

        await tester.tap(find.bySemanticsLabel('Delete',skipOffstage: false));
        await tester.pumpAndSettle();

        expect(
          find.textContaining('ERROR',skipOffstage: false),
          findsOneWidget,
        );
      }
  );

  testWidgets('Pressing update button '
              'gives error when no record is found',
          (WidgetTester tester) async {


            await tester.pumpWidget(app.FirebaseCrudExampleApp());

            expect(
          find.textContaining('Ready!'),
          findsOneWidget,
        );

        await tester.drag(find.byKey(Key('scroller')), const Offset(0.0, -300));
        await tester.pumpAndSettle();

        await tester.tap(find.bySemanticsLabel('Update',skipOffstage: false));
        await tester.pumpAndSettle();

        expect(
          find.textContaining('ERROR',skipOffstage: false),
          findsOneWidget,
        );
      }
  );


  testWidgets('Pressing read button '
              'gives error when no record is found',
          (WidgetTester tester) async {


            await tester.pumpWidget(app.FirebaseCrudExampleApp());

            expect(
          find.textContaining('Ready!'),
          findsOneWidget,
        );
        await tester.drag(find.byKey(Key('scroller')), const Offset(0.0, -300));
        await tester.pumpAndSettle();

        await tester.tap(find.bySemanticsLabel('Read',skipOffstage: false));
        await tester.pumpAndSettle();

        expect(
          find.textContaining('ERROR',skipOffstage: false),
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

            await tester.pumpAndSettle();

        await tester.tap(find.bySemanticsLabel('Create'));
        await tester.pumpAndSettle();

        expect(
          find.textContaining('Success'),
          findsOneWidget,
        );

            await tester.drag(find.byKey(Key('scroller')), const Offset(0.0, -300));
            await tester.pumpAndSettle();


        await tester.tap(find.bySemanticsLabel('Update'));
        await tester.pumpAndSettle();

        expect(find.textContaining('Alessandro'),
            findsOneWidget);

        expect(
          find.textContaining('Success'),
          findsOneWidget,
        );


            await tester.drag(find.byKey(Key('scroller')), const Offset(0.0, -300));
            await tester.pumpAndSettle();




        await tester.tap(find.bySemanticsLabel('Delete'));
        await tester.pumpAndSettle();

        expect(
          find.textContaining('Success'),
          findsOneWidget,
        );
      }
  );




}

