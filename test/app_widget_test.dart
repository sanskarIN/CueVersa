import 'package:cue_versa/app/app_progress.dart';
import 'package:cue_versa/app/app_settings.dart';
import 'package:cue_versa/app/cue_verse_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<(AppSettings, AppProgress)> controllers() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final preferences = await SharedPreferences.getInstance();
    return (await AppSettings.load(preferences), AppProgress.load(preferences));
  }

  testWidgets('home exposes primary play and support actions', (tester) async {
    final values = await controllers();
    await tester.pumpWidget(
      CueVerseApp(settings: values.$1, progress: values.$2),
    );
    await tester.pumpAndSettle();

    expect(find.text('CueVerse'), findsOneWidget);
    expect(find.text('Play'), findsOneWidget);
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -900));
    await tester.pumpAndSettle();
    expect(
      find.bySemanticsLabel('Support Sanskar on Buy Me a Coffee'),
      findsOneWidget,
    );
    expect(find.text('Made by the Sanskar'), findsOneWidget);
  });

  testWidgets('locale updates without reinstalling', (tester) async {
    final values = await controllers();
    await tester.pumpWidget(
      CueVerseApp(settings: values.$1, progress: values.$2),
    );
    values.$1.setLocale(const Locale('hi'));
    await tester.pumpAndSettle();

    expect(find.text('क्यूवर्स'), findsOneWidget);
    expect(find.text('खेलें'), findsOneWidget);
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -900));
    await tester.pumpAndSettle();
    expect(find.text('Sanskar द्वारा निर्मित'), findsOneWidget);
  });

  testWidgets('practice mode opens an interactive localized table', (
    tester,
  ) async {
    final values = await controllers();
    await tester.pumpWidget(
      CueVerseApp(settings: values.$1, progress: values.$2),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Play'));
    await tester.pumpAndSettle();
    expect(find.text('Select a mode'), findsOneWidget);

    await tester.tap(find.text('Practice table'));
    await tester.pumpAndSettle();
    expect(find.text('Game table'), findsOneWidget);
    expect(find.bySemanticsLabel('Pool table with 16 balls'), findsOneWidget);
    expect(find.text('Shoot'), findsOneWidget);
  });
}
