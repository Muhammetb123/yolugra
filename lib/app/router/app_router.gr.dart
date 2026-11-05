// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [BookingDetailsPage]
class BookingDetailsRoute extends PageRouteInfo<BookingDetailsRouteArgs> {
  BookingDetailsRoute({
    Key? key,
    required String bookingId,
    List<PageRouteInfo>? children,
  }) : super(
         BookingDetailsRoute.name,
         args: BookingDetailsRouteArgs(key: key, bookingId: bookingId),
         rawPathParams: {'bookingId': bookingId},
         initialChildren: children,
       );

  static const String name = 'BookingDetailsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<BookingDetailsRouteArgs>(
        orElse: () => BookingDetailsRouteArgs(
          bookingId: pathParams.getString('bookingId'),
        ),
      );
      return BookingDetailsPage(key: args.key, bookingId: args.bookingId);
    },
  );
}

class BookingDetailsRouteArgs {
  const BookingDetailsRouteArgs({this.key, required this.bookingId});

  final Key? key;

  final String bookingId;

  @override
  String toString() {
    return 'BookingDetailsRouteArgs{key: $key, bookingId: $bookingId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! BookingDetailsRouteArgs) return false;
    return key == other.key && bookingId == other.bookingId;
  }

  @override
  int get hashCode => key.hashCode ^ bookingId.hashCode;
}

/// generated route for
/// [ChangePhonePage]
class ChangePhoneRoute extends PageRouteInfo<void> {
  const ChangePhoneRoute({List<PageRouteInfo>? children})
    : super(ChangePhoneRoute.name, initialChildren: children);

  static const String name = 'ChangePhoneRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ChangePhonePage();
    },
  );
}

/// generated route for
/// [CompleteProfilePage]
class CompleteProfileRoute extends PageRouteInfo<void> {
  const CompleteProfileRoute({List<PageRouteInfo>? children})
    : super(CompleteProfileRoute.name, initialChildren: children);

  static const String name = 'CompleteProfileRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CompleteProfilePage();
    },
  );
}

/// generated route for
/// [EditProfilePage]
class EditProfileRoute extends PageRouteInfo<void> {
  const EditProfileRoute({List<PageRouteInfo>? children})
    : super(EditProfileRoute.name, initialChildren: children);

  static const String name = 'EditProfileRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const EditProfilePage();
    },
  );
}

/// generated route for
/// [EditTripPage]
class EditTripRoute extends PageRouteInfo<EditTripRouteArgs> {
  EditTripRoute({
    Key? key,
    required String tripId,
    required Trip trip,
    List<PageRouteInfo>? children,
  }) : super(
         EditTripRoute.name,
         args: EditTripRouteArgs(key: key, tripId: tripId, trip: trip),
         rawPathParams: {'tripId': tripId},
         initialChildren: children,
       );

  static const String name = 'EditTripRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<EditTripRouteArgs>();
      return EditTripPage(key: args.key, tripId: args.tripId, trip: args.trip);
    },
  );
}

class EditTripRouteArgs {
  const EditTripRouteArgs({this.key, required this.tripId, required this.trip});

  final Key? key;

  final String tripId;

  final Trip trip;

  @override
  String toString() {
    return 'EditTripRouteArgs{key: $key, tripId: $tripId, trip: $trip}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! EditTripRouteArgs) return false;
    return key == other.key && tripId == other.tripId && trip == other.trip;
  }

  @override
  int get hashCode => key.hashCode ^ tripId.hashCode ^ trip.hashCode;
}

/// generated route for
/// [HomePage]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HomePage();
    },
  );
}

/// generated route for
/// [LeaveReviewPage]
class LeaveReviewRoute extends PageRouteInfo<LeaveReviewRouteArgs> {
  LeaveReviewRoute({
    Key? key,
    required String bookingId,
    required String name,
    required bool aboutDriver,
    List<PageRouteInfo>? children,
  }) : super(
         LeaveReviewRoute.name,
         args: LeaveReviewRouteArgs(
           key: key,
           bookingId: bookingId,
           name: name,
           aboutDriver: aboutDriver,
         ),
         rawPathParams: {'bookingId': bookingId},
         initialChildren: children,
       );

  static const String name = 'LeaveReviewRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<LeaveReviewRouteArgs>();
      return LeaveReviewPage(
        key: args.key,
        bookingId: args.bookingId,
        name: args.name,
        aboutDriver: args.aboutDriver,
      );
    },
  );
}

class LeaveReviewRouteArgs {
  const LeaveReviewRouteArgs({
    this.key,
    required this.bookingId,
    required this.name,
    required this.aboutDriver,
  });

  final Key? key;

  final String bookingId;

  final String name;

  final bool aboutDriver;

  @override
  String toString() {
    return 'LeaveReviewRouteArgs{key: $key, bookingId: $bookingId, name: $name, aboutDriver: $aboutDriver}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! LeaveReviewRouteArgs) return false;
    return key == other.key &&
        bookingId == other.bookingId &&
        name == other.name &&
        aboutDriver == other.aboutDriver;
  }

  @override
  int get hashCode =>
      key.hashCode ^ bookingId.hashCode ^ name.hashCode ^ aboutDriver.hashCode;
}

/// generated route for
/// [MainShellPage]
class MainShellRoute extends PageRouteInfo<void> {
  const MainShellRoute({List<PageRouteInfo>? children})
    : super(MainShellRoute.name, initialChildren: children);

  static const String name = 'MainShellRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MainShellPage();
    },
  );
}

/// generated route for
/// [MyTripsPage]
class MyTripsRoute extends PageRouteInfo<void> {
  const MyTripsRoute({List<PageRouteInfo>? children})
    : super(MyTripsRoute.name, initialChildren: children);

  static const String name = 'MyTripsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MyTripsPage();
    },
  );
}

/// generated route for
/// [NotificationsPage]
class NotificationsRoute extends PageRouteInfo<void> {
  const NotificationsRoute({List<PageRouteInfo>? children})
    : super(NotificationsRoute.name, initialChildren: children);

  static const String name = 'NotificationsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const NotificationsPage();
    },
  );
}

/// generated route for
/// [OtpPage]
class OtpRoute extends PageRouteInfo<OtpRouteArgs> {
  OtpRoute({
    Key? key,
    required String phone,
    String? devCode,
    List<PageRouteInfo>? children,
  }) : super(
         OtpRoute.name,
         args: OtpRouteArgs(key: key, phone: phone, devCode: devCode),
         initialChildren: children,
       );

  static const String name = 'OtpRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OtpRouteArgs>();
      return OtpPage(key: args.key, phone: args.phone, devCode: args.devCode);
    },
  );
}

class OtpRouteArgs {
  const OtpRouteArgs({this.key, required this.phone, this.devCode});

  final Key? key;

  final String phone;

  final String? devCode;

  @override
  String toString() {
    return 'OtpRouteArgs{key: $key, phone: $phone, devCode: $devCode}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! OtpRouteArgs) return false;
    return key == other.key && phone == other.phone && devCode == other.devCode;
  }

  @override
  int get hashCode => key.hashCode ^ phone.hashCode ^ devCode.hashCode;
}

/// generated route for
/// [PhonePage]
class PhoneRoute extends PageRouteInfo<void> {
  const PhoneRoute({List<PageRouteInfo>? children})
    : super(PhoneRoute.name, initialChildren: children);

  static const String name = 'PhoneRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const PhonePage();
    },
  );
}

/// generated route for
/// [ProfilePage]
class ProfileRoute extends PageRouteInfo<void> {
  const ProfileRoute({List<PageRouteInfo>? children})
    : super(ProfileRoute.name, initialChildren: children);

  static const String name = 'ProfileRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ProfilePage();
    },
  );
}

/// generated route for
/// [PublicProfilePage]
class PublicProfileRoute extends PageRouteInfo<PublicProfileRouteArgs> {
  PublicProfileRoute({
    Key? key,
    required String userId,
    List<PageRouteInfo>? children,
  }) : super(
         PublicProfileRoute.name,
         args: PublicProfileRouteArgs(key: key, userId: userId),
         rawPathParams: {'userId': userId},
         initialChildren: children,
       );

  static const String name = 'PublicProfileRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<PublicProfileRouteArgs>(
        orElse: () =>
            PublicProfileRouteArgs(userId: pathParams.getString('userId')),
      );
      return PublicProfilePage(key: args.key, userId: args.userId);
    },
  );
}

class PublicProfileRouteArgs {
  const PublicProfileRouteArgs({this.key, required this.userId});

  final Key? key;

  final String userId;

  @override
  String toString() {
    return 'PublicProfileRouteArgs{key: $key, userId: $userId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PublicProfileRouteArgs) return false;
    return key == other.key && userId == other.userId;
  }

  @override
  int get hashCode => key.hashCode ^ userId.hashCode;
}

/// generated route for
/// [PublishTripPage]
class PublishTripRoute extends PageRouteInfo<void> {
  const PublishTripRoute({List<PageRouteInfo>? children})
    : super(PublishTripRoute.name, initialChildren: children);

  static const String name = 'PublishTripRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const PublishTripPage();
    },
  );
}

/// generated route for
/// [SearchPage]
class SearchRoute extends PageRouteInfo<void> {
  const SearchRoute({List<PageRouteInfo>? children})
    : super(SearchRoute.name, initialChildren: children);

  static const String name = 'SearchRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SearchPage();
    },
  );
}

/// generated route for
/// [SearchResultsPage]
class SearchResultsRoute extends PageRouteInfo<SearchResultsRouteArgs> {
  SearchResultsRoute({
    Key? key,
    required SearchQuery query,
    List<PageRouteInfo>? children,
  }) : super(
         SearchResultsRoute.name,
         args: SearchResultsRouteArgs(key: key, query: query),
         initialChildren: children,
       );

  static const String name = 'SearchResultsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SearchResultsRouteArgs>();
      return SearchResultsPage(key: args.key, query: args.query);
    },
  );
}

class SearchResultsRouteArgs {
  const SearchResultsRouteArgs({this.key, required this.query});

  final Key? key;

  final SearchQuery query;

  @override
  String toString() {
    return 'SearchResultsRouteArgs{key: $key, query: $query}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SearchResultsRouteArgs) return false;
    return key == other.key && query == other.query;
  }

  @override
  int get hashCode => key.hashCode ^ query.hashCode;
}

/// generated route for
/// [SettingsPage]
class SettingsRoute extends PageRouteInfo<void> {
  const SettingsRoute({List<PageRouteInfo>? children})
    : super(SettingsRoute.name, initialChildren: children);

  static const String name = 'SettingsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SettingsPage();
    },
  );
}

/// generated route for
/// [SplashPage]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute({List<PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SplashPage();
    },
  );
}

/// generated route for
/// [TripDetailsPage]
class TripDetailsRoute extends PageRouteInfo<TripDetailsRouteArgs> {
  TripDetailsRoute({
    Key? key,
    required String tripId,
    int? seats,
    int? pickup,
    int? dropoff,
    List<PageRouteInfo>? children,
  }) : super(
         TripDetailsRoute.name,
         args: TripDetailsRouteArgs(
           key: key,
           tripId: tripId,
           seats: seats,
           pickup: pickup,
           dropoff: dropoff,
         ),
         rawPathParams: {'tripId': tripId},
         rawQueryParams: {'seats': seats, 'pickup': pickup, 'dropoff': dropoff},
         initialChildren: children,
       );

  static const String name = 'TripDetailsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final queryParams = data.queryParams;
      final args = data.argsAs<TripDetailsRouteArgs>(
        orElse: () => TripDetailsRouteArgs(
          tripId: pathParams.getString('tripId'),
          seats: queryParams.optInt('seats'),
          pickup: queryParams.optInt('pickup'),
          dropoff: queryParams.optInt('dropoff'),
        ),
      );
      return TripDetailsPage(
        key: args.key,
        tripId: args.tripId,
        seats: args.seats,
        pickup: args.pickup,
        dropoff: args.dropoff,
      );
    },
  );
}

class TripDetailsRouteArgs {
  const TripDetailsRouteArgs({
    this.key,
    required this.tripId,
    this.seats,
    this.pickup,
    this.dropoff,
  });

  final Key? key;

  final String tripId;

  final int? seats;

  final int? pickup;

  final int? dropoff;

  @override
  String toString() {
    return 'TripDetailsRouteArgs{key: $key, tripId: $tripId, seats: $seats, pickup: $pickup, dropoff: $dropoff}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! TripDetailsRouteArgs) return false;
    return key == other.key &&
        tripId == other.tripId &&
        seats == other.seats &&
        pickup == other.pickup &&
        dropoff == other.dropoff;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      tripId.hashCode ^
      seats.hashCode ^
      pickup.hashCode ^
      dropoff.hashCode;
}

/// generated route for
/// [TripManagePage]
class TripManageRoute extends PageRouteInfo<TripManageRouteArgs> {
  TripManageRoute({
    Key? key,
    required String tripId,
    List<PageRouteInfo>? children,
  }) : super(
         TripManageRoute.name,
         args: TripManageRouteArgs(key: key, tripId: tripId),
         rawPathParams: {'tripId': tripId},
         initialChildren: children,
       );

  static const String name = 'TripManageRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<TripManageRouteArgs>(
        orElse: () =>
            TripManageRouteArgs(tripId: pathParams.getString('tripId')),
      );
      return TripManagePage(key: args.key, tripId: args.tripId);
    },
  );
}

class TripManageRouteArgs {
  const TripManageRouteArgs({this.key, required this.tripId});

  final Key? key;

  final String tripId;

  @override
  String toString() {
    return 'TripManageRouteArgs{key: $key, tripId: $tripId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! TripManageRouteArgs) return false;
    return key == other.key && tripId == other.tripId;
  }

  @override
  int get hashCode => key.hashCode ^ tripId.hashCode;
}

/// generated route for
/// [VehicleFormPage]
class VehicleFormRoute extends PageRouteInfo<VehicleFormRouteArgs> {
  VehicleFormRoute({Key? key, Vehicle? vehicle, List<PageRouteInfo>? children})
    : super(
        VehicleFormRoute.name,
        args: VehicleFormRouteArgs(key: key, vehicle: vehicle),
        initialChildren: children,
      );

  static const String name = 'VehicleFormRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<VehicleFormRouteArgs>(
        orElse: () => const VehicleFormRouteArgs(),
      );
      return VehicleFormPage(key: args.key, vehicle: args.vehicle);
    },
  );
}

class VehicleFormRouteArgs {
  const VehicleFormRouteArgs({this.key, this.vehicle});

  final Key? key;

  final Vehicle? vehicle;

  @override
  String toString() {
    return 'VehicleFormRouteArgs{key: $key, vehicle: $vehicle}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! VehicleFormRouteArgs) return false;
    return key == other.key && vehicle == other.vehicle;
  }

  @override
  int get hashCode => key.hashCode ^ vehicle.hashCode;
}

/// generated route for
/// [VehiclesPage]
class VehiclesRoute extends PageRouteInfo<void> {
  const VehiclesRoute({List<PageRouteInfo>? children})
    : super(VehiclesRoute.name, initialChildren: children);

  static const String name = 'VehiclesRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const VehiclesPage();
    },
  );
}
