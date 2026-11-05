import 'package:equatable/equatable.dart';

/// The public face of a user next to a trip or booking. It never carries a phone.
class UserSummary extends Equatable {
  const UserSummary({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.photoUrl,
    this.ratingAvg = 0,
    this.ratingCount = 0,
    this.completedTrips = 0,
  });

  final String id;
  final String firstName;
  final String lastName;
  final String? photoUrl;
  final double ratingAvg;
  final int ratingCount;
  final int completedTrips;

  String get fullName => '$firstName $lastName'.trim();

  @override
  List<Object?> get props => [id, firstName, lastName, photoUrl, ratingAvg, ratingCount, completedTrips];
}

/// A user profile. [phone] and [locale] are present only for the signed-in user.
class Profile extends Equatable {
  const Profile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.memberSince,
    this.phone,
    this.bio,
    this.photoUrl,
    this.locale,
    this.ratingAvg = 0,
    this.ratingCount = 0,
    this.tripsAsDriver = 0,
    this.tripsAsPassenger = 0,
    this.profileComplete = false,
  });

  final String id;
  final String? phone;
  final String firstName;
  final String lastName;
  final String? bio;
  final String? photoUrl;
  final String? locale;
  final double ratingAvg;
  final int ratingCount;
  final int tripsAsDriver;
  final int tripsAsPassenger;
  final DateTime memberSince;
  final bool profileComplete;

  String get fullName => '$firstName $lastName'.trim();

  @override
  List<Object?> get props => [id, phone, firstName, lastName, bio, photoUrl, locale, ratingAvg, ratingCount,
        tripsAsDriver, tripsAsPassenger, memberSince, profileComplete];
}

abstract interface class ProfileRepository {
  Future<Profile> me();
  Future<Profile> update({String? firstName, String? lastName, String? bio, String? locale});
  Future<Profile> uploadPhoto(String filePath);
  Future<Profile> removePhoto();
  Future<Profile> user(String id);

  /// Sends an OTP to [phone] through the backend SMS gateway. Returns the code only
  /// when the backend runs in development mode.
  Future<String?> requestPhoneChange(String phone);
  Future<Profile> confirmPhoneChange(String phone, String code);
}
