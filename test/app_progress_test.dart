import 'package:cue_versa/app/app_progress.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  test('records shots, accuracy, matches, XP, and streaks', () async {
    final preferences = await SharedPreferences.getInstance();
    final progress = AppProgress.load(preferences);
    progress
      ..recordShot(pocketedBalls: 2)
      ..recordShot(pocketedBalls: 0)
      ..recordMatch(won: true)
      ..recordMatch(won: true)
      ..recordMatch(won: false);
    await Future<void>.delayed(Duration.zero);

    expect(progress.shots, 2);
    expect(progress.pots, 2);
    expect(progress.successfulShots, 1);
    expect(progress.accuracy, .5);
    expect(progress.matches, 3);
    expect(progress.wins, 2);
    expect(progress.bestStreak, 2);
    expect(progress.xp, 360);
  });

  test('clear removes progress values', () async {
    final preferences = await SharedPreferences.getInstance();
    final progress = AppProgress.load(preferences)..recordMatch(won: true);

    await progress.clear();

    expect(progress.xp, 0);
    expect(progress.matches, 0);
    expect(
      preferences.getKeys().where((key) => key.startsWith('progress.')),
      isEmpty,
    );
  });
}
