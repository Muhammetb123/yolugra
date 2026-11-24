import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yolugra/app/localization/l10n.dart';
import 'package:yolugra/app/localization/tk_localizations.dart';
import 'package:yolugra/app/theme/app_theme.dart';
import 'package:yolugra/core/config/app_config.dart';
import 'package:yolugra/core/widgets/legal_links.dart';
import 'package:yolugra/features/moderation/domain/moderation.dart';
import 'package:yolugra/features/moderation/presentation/bloc/moderation_cubits.dart';
import 'package:yolugra/features/moderation/presentation/pages/blocked_users_page.dart';
import 'package:yolugra/features/moderation/presentation/pages/report_user_page.dart';
import 'package:yolugra/features/profile/domain/profile.dart';
import 'package:yolugra/features/trip_details/presentation/widgets/trip_detail_sections.dart';
import 'package:yolugra/features/trips/presentation/widgets/trip_card.dart';

import '../helpers/fixtures.dart';

class MockModeration extends Mock implements ModerationRepository {}

Widget app(Widget child, {Locale locale = const Locale('en')}) => MaterialApp(
      locale: locale,
      supportedLocales: supportedLocales,
      localizationsDelegates: localizationsDelegates,
      theme: AppTheme.light(),
      home: child,
    );

const gone = UserSummary(id: 'u-gone', firstName: '', lastName: '', deleted: true);

void main() {
  setUpAll(() {
    registerTurkmenDateSymbols();
    registerFallbackValue(ReportReason.spam);
  });

  testWidgets('a deleted driver shows the placeholder in every language and opens nothing', (tester) async {
    final expected = {const Locale('tk'): 'Pozulan ulanyjy', const Locale('ru'): 'Удалённый пользователь', const Locale('en'): 'Deleted user'};
    for (final MapEntry(key: locale, value: text) in expected.entries) {
      var opened = false;
      await tester.pumpWidget(app(Scaffold(body: DriverSection(driver: gone, onTap: () => opened = true)), locale: locale));
      await tester.pumpAndSettle();
      expect(find.text(text), findsOneWidget, reason: '$locale');
      await tester.tap(find.text(text));
      expect(opened, isFalse, reason: 'a deleted account has no profile page');
    }
  });

  testWidgets('a trip card by a deleted driver has no name and no rating', (tester) async {
    final orphan = sampleTrip(by: gone);
    await tester.pumpWidget(app(Scaffold(body: SingleChildScrollView(child: TripCard(trip: orphan, onTap: () {})))));
    await tester.pumpAndSettle();
    expect(find.text('Deleted user'), findsOneWidget);
    expect(find.text('New on Ýolugra'), findsNothing);
  });

  testWidgets('the report form needs a reason, and details for "something else"', (tester) async {
    final repo = MockModeration();
    when(() => repo.report(userId: any(named: 'userId'), reason: any(named: 'reason'), tripId: any(named: 'tripId'), details: any(named: 'details')))
        .thenAnswer((_) async {});
    var sent = false;
    // Tall enough for the whole form: a lazy list does not build what is off screen.
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(app(BlocProvider(
      create: (_) => ReportCubit(repo, 'u-a', tripId: 't-1'),
      child: ReportUserView(name: 'Aýna Orazowa', onSent: () => sent = true),
    )));
    await tester.pumpAndSettle();
    expect(find.text('Why are you reporting Aýna Orazowa?'), findsOneWidget);

    FilledButton submit() => tester.widget<FilledButton>(find.widgetWithText(FilledButton, 'Send report'));
    expect(submit().onPressed, isNull);

    await tester.tap(find.text('Something else'));
    await tester.pumpAndSettle();
    expect(find.text('Describe what happened'), findsOneWidget);
    expect(submit().onPressed, isNull);

    await tester.enterText(find.byType(TextField), 'Asked to pay before the trip');
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Send report'));
    await tester.tap(find.text('Send report'));
    await tester.pumpAndSettle();
    expect(sent, isTrue);
    verify(() => repo.report(userId: 'u-a', reason: ReportReason.other, tripId: 't-1', details: 'Asked to pay before the trip')).called(1);
  });

  testWidgets('the blocked users list unblocks and then shows the empty state', (tester) async {
    final repo = MockModeration();
    when(() => repo.blocked()).thenAnswer((_) async => [const UserSummary(id: 'u-a', firstName: 'Aýna', lastName: 'Orazowa')]);
    when(() => repo.unblock('u-a')).thenAnswer((_) async {});
    await tester.pumpWidget(app(BlocProvider(create: (_) => BlockedUsersCubit(repo)..load(), child: BlockedUsersView(onOpenUser: (_) {}))));
    await tester.pumpAndSettle();
    expect(find.text('Aýna Orazowa'), findsOneWidget);
    await tester.tap(find.text('Unblock'));
    await tester.pumpAndSettle();
    expect(find.text('You have not blocked anyone'), findsOneWidget);
    verify(() => repo.unblock('u-a')).called(1);
  });

  testWidgets('legal links appear only when the build has a site address', (tester) async {
    await tester.pumpWidget(app(const Scaffold(body: LegalLinks(siteUrl: ''))));
    expect(find.text('Privacy policy'), findsNothing);
    await tester.pumpWidget(app(const Scaffold(body: LegalLinks(siteUrl: 'https://example.tm'))));
    expect(find.text('Privacy policy'), findsOneWidget);
    expect(find.text('Terms of use'), findsOneWidget);
  });

  test('site pages follow the website layout in the app language', () {
    expect(AppConfig.sitePage('privacy', 'ru', base: 'https://example.tm/').toString(), 'https://example.tm/ru/privacy.html');
    expect(AppConfig.sitePage('terms', 'tk', base: 'https://example.tm').toString(), 'https://example.tm/tk/terms.html');
    expect(AppConfig.sitePage('privacy', 'en', base: ''), isNull);
  });
}
