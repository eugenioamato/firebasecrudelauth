import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:firebase_crud_example/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async{
    await Firebase.initializeApp();
  });

  testWidgets('delete gives error when no record is found',
      (WidgetTester tester) async {
        await tester.pumpWidget(app.FirebaseCrudExampleApp(),Duration(seconds: 5));

        expect(
          find.textContaining('Ready!'),
          findsOneWidget,
        );

        await tester.tap(find.bySemanticsLabel('Delete'));
        await tester.pumpAndSettle(Duration(seconds: 1));

        expect(
          find.textContaining('ERROR'),
          findsNWidgets(3),
        );
      }
  );

  testWidgets('update gives error when no record is found',
          (WidgetTester tester) async {


        await tester.pumpWidget(app.FirebaseCrudExampleApp());

        expect(
          find.textContaining('Ready!'),
          findsOneWidget,
        );

        await tester.tap(find.bySemanticsLabel('Update'));
        await tester.pumpAndSettle(Duration(seconds: 1));

        expect(
          find.textContaining('ERROR'),
          findsNWidgets(3),
        );
      }
  );


  testWidgets('read gives error when no record is found',
          (WidgetTester tester) async {


        await tester.pumpWidget(app.FirebaseCrudExampleApp());

        expect(
          find.textContaining('Ready!'),
          findsOneWidget,
        );

        await tester.tap(find.bySemanticsLabel('Read'));
        await tester.pumpAndSettle(Duration(seconds: 1));

        expect(
          find.textContaining('ERROR'),
          findsNWidgets(2),
        );
      }
  );

  testWidgets('creating will show a success, '
      'then updating will show a success '
      'then deleting will show a success ',
          (WidgetTester tester) async {


        await tester.pumpWidget(app.FirebaseCrudExampleApp());

        expect(
          find.textContaining('Ready!'),
          findsOneWidget,
        );

        await tester.tap(find.bySemanticsLabel('Create'));
        await tester.pumpAndSettle(Duration(seconds: 1));

        expect(
          find.textContaining('Success'),
          findsOneWidget,
        );

        await tester.tap(find.bySemanticsLabel('Back'));
        await tester.pumpAndSettle(Duration(seconds: 1));


        await tester.tap(find.bySemanticsLabel('Update'));
        await tester.pumpAndSettle(Duration(seconds: 1));

        expect(find.textContaining('Alessandro'),
            findsNWidgets(2));

        expect(
          find.textContaining('Success'),
          findsOneWidget,
        );

        await tester.tap(find.bySemanticsLabel('Back'));

        await tester.pumpAndSettle(Duration(seconds: 1));

        await tester.tap(find.bySemanticsLabel('Delete'));
        await tester.pumpAndSettle(Duration(seconds: 1));

        expect(
          find.textContaining('Success'),
          findsOneWidget,
        );
      }
  );




}

//chromedriver --port=4444
//flutter drive --driver=test_driver/integration_driver.dart --target=integration_test/app_test.dart -d web-server