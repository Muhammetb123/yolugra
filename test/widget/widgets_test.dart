import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yolugra/app/localization/l10n.dart';
import 'package:yolugra/app/localization/tk_localizations.dart';
import 'package:yolugra/app/theme/app_theme.dart';
import 'package:yolugra/features/bookings/domain/booking.dart';
import 'package:yolugra/features/bookings/presentation/widgets/call_button.dart';
import 'package:yolugra/features/my_trips/presentation/widgets/booking_request_tile.dart';
import 'package:yolugra/features/profile/domain/profile.dart';
import 'package:yolugra/features/trip_details/presentation/widgets/trip_detail_sections.dart';
import 'package:yolugra/features/trips/domain/trip.dart';
import 'package:yolugra/features/trips/presentation/widgets/route_timeline.dart';
import 'package:yolugra/features/trips/presentation/widgets/trip_card.dart';
import 'package:yolugra/features/vehicle/domain/vehicle.dart';

import '../helpers/fixtures.dart';

Widget app(Widget child, {Locale locale = const Locale('tk')}) => MaterialApp(
      locale: locale,
      supportedLocales: supportedLocales,
      localizationsDelegates: localizationsDelegates,
      theme: AppTheme.light(),
      home: Scaffold(body: SingleChildScrollView(child: child)),
    );

Booking requestBooking({required BookingStatus status, String? phone}) => Booking(
      id: 'b-1',
      tripId: 't-1',
      status: status,
      seats: 2,
      pickupOrder: 1,
      dropoffOrder: 2,
      createdAt: DateTime(2026, 11, 1, 10),
      message: 'Salam',
      passenger: const UserSummary(id: 'u-p', firstName: 'Aýna', lastName: 'Orazowa'),
      contactPhone: phone,
    );

void main() {
  setUpAll(registerTurkmenDateSymbols);

  testWidgets('the trip card speaks each app language', (tester) async {
    final expected = {
      const Locale('tk'): ('Aşgabat', '150 manat', '4 boş orun'),
      const Locale('ru'): ('Ашхабад', '150 ман.', 'Осталось 4 места'),
      const Locale('en'): ('Ashgabat', '150 TMT', '4 seats left'),
    };
    for (final MapEntry(key: locale, value: (city, price, seats)) in expected.entries) {
      await tester.pumpWidget(app(TripCard(trip: sampleTrip(), onTap: () {}), locale: locale));
      await tester.pumpAndSettle();
      expect(find.text(city), findsOneWidget, reason: '$locale');
      expect(find.text(price), findsOneWidget, reason: '$locale');
      expect(find.text(seats), findsOneWidget, reason: '$locale');
    }
  });

  testWidgets('Turkmen dates come from the registered Turkmen symbols', (tester) async {
    await tester.pumpWidget(app(Builder(builder: (context) {
      return Text(MaterialLocalizations.of(context).formatMediumDate(DateTime(2026, 11, 15)));
    })));
    await tester.pumpAndSettle();
    expect(find.textContaining('noý'), findsOneWidget);
    expect(find.textContaining('Nov'), findsNothing);
  });

  testWidgets('the Material date picker is Turkmen', (tester) async {
    await tester.pumpWidget(app(Builder(builder: (context) {
      return TextButton(
        onPressed: () => showDatePicker(context: context, firstDate: DateTime(2026), lastDate: DateTime(2027), initialDate: DateTime(2026, 11, 15)),
        child: const Text('open'),
      );
    })));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.text('Senäni saýlaň'), findsOneWidget);
    expect(find.text('Ýatyr'), findsOneWidget);
  });

  testWidgets('the plate stays hidden until the backend sends it for an accepted booking', (tester) async {
    const hidden = Vehicle(brand: 'Toyota', model: 'Camry', color: 'Ak');
    await tester.pumpWidget(app(const VehicleSection(vehicle: hidden, plateVisible: false), locale: const Locale('en')));
    expect(find.textContaining('AG 1234'), findsNothing);
    expect(find.textContaining('after the driver accepts'), findsOneWidget);

    const shown = Vehicle(brand: 'Toyota', model: 'Camry', color: 'Ak', plate: 'AG 1234');
    await tester.pumpWidget(app(const VehicleSection(vehicle: shown, plateVisible: true), locale: const Locale('en')));
    expect(find.textContaining('AG 1234'), findsOneWidget);
  });

  testWidgets('a pending request shows no phone and offers accept and decline', (tester) async {
    var accepted = false;
    await tester.pumpWidget(app(
      BookingRequestTile(booking: requestBooking(status: BookingStatus.pending), trip: sampleTrip(), onAccept: () => accepted = true, onReject: () {}),
      locale: const Locale('en'),
    ));
    expect(find.byType(CallButton), findsNothing);
    expect(find.text('Tejen → Mary'), findsOneWidget);
    expect(find.text('2 seats'), findsOneWidget);
    await tester.tap(find.text('Accept'));
    expect(accepted, isTrue);
  });

  testWidgets('an accepted request shows the call button with the shared phone', (tester) async {
    await tester.pumpWidget(app(
      BookingRequestTile(booking: requestBooking(status: BookingStatus.approved, phone: '+99361234567'), trip: sampleTrip()),
      locale: const Locale('en'),
    ));
    expect(find.byType(CallButton), findsOneWidget);
    expect(find.textContaining('+993 61 23 45 67'), findsOneWidget);
  });

  testWidgets('the timeline lists every stop with its meeting point', (tester) async {
    await tester.pumpWidget(app(RouteTimeline(stops: sampleTrip().stops, highlight: (1, 2)), locale: const Locale('ru')));
    expect(find.text('Ашхабад'), findsOneWidget);
    expect(find.text('Теджен'), findsOneWidget);
    expect(find.text('Мары'), findsOneWidget);
    expect(find.text('Teke bazar'), findsOneWidget);
  });

  testWidgets('unspecified comfort options are not shown as facts', (tester) async {
    await tester.pumpWidget(app(const AmenitiesSection(amenities: Amenities()), locale: const Locale('en')));
    expect(find.text('Not specified'), findsOneWidget);
    await tester.pumpWidget(app(const AmenitiesSection(amenities: Amenities(pets: PetsPolicy.allowed)), locale: const Locale('en')));
    expect(find.text('Pets welcome'), findsOneWidget);
    expect(find.text('Not specified'), findsNothing);
  });
}
