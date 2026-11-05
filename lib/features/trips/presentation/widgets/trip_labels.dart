import 'package:flutter/material.dart';

import '../../../../app/localization/l10n.dart';
import '../../../../core/widgets/feedback.dart';
import '../../../bookings/domain/booking_status.dart';
import '../../domain/trip.dart';

/// Localized labels for the trip and booking enums, in one place.
extension TripLabels on AppLocalizations {
  String tripStatus(TripStatus s) => switch (s) {
        TripStatus.active => tripStatusActive,
        TripStatus.full => tripStatusFull,
        TripStatus.inProgress => tripStatusInProgress,
        TripStatus.completed => tripStatusCompleted,
        TripStatus.cancelled => tripStatusCancelled,
        TripStatus.expired => tripStatusExpired,
      };

  String bookingStatus(BookingStatus s) => switch (s) {
        BookingStatus.pending => bookingStatusPending,
        BookingStatus.approved => bookingStatusApproved,
        BookingStatus.rejected => bookingStatusRejected,
        BookingStatus.cancelledByPassenger => bookingStatusCancelledByPassenger,
        BookingStatus.cancelledByDriver => bookingStatusCancelledByDriver,
        BookingStatus.completed => bookingStatusCompleted,
        BookingStatus.expired => bookingStatusExpired,
      };

  String stopType(StopType t) => switch (t) {
        StopType.both => stopTypeBoth,
        StopType.pickup => stopTypePickup,
        StopType.dropoff => stopTypeDropoff,
      };

  String luggage(LuggageSize s) => switch (s) {
        LuggageSize.none => luggageNone,
        LuggageSize.small => luggageSmall,
        LuggageSize.medium => luggageMedium,
        LuggageSize.large => luggageLarge,
        LuggageSize.unspecified => commonNotSpecified,
      };

  String music(MusicPolicy m) => switch (m) {
        MusicPolicy.allowed => musicAllowed,
        MusicPolicy.none => musicNone,
        MusicPolicy.driverDecides => musicDriverDecides,
        MusicPolicy.unspecified => commonNotSpecified,
      };

  String smoking(SmokingPolicy s) => switch (s) {
        SmokingPolicy.allowed => smokingAllowed,
        SmokingPolicy.prohibited => smokingProhibited,
        SmokingPolicy.unspecified => commonNotSpecified,
      };

  String pets(PetsPolicy p) => switch (p) {
        PetsPolicy.allowed => petsAllowed,
        PetsPolicy.notAllowed => petsNotAllowed,
        PetsPolicy.unspecified => commonNotSpecified,
      };

  String conversation(Conversation c) => switch (c) {
        Conversation.friendly => conversationFriendly,
        Conversation.quiet => conversationQuiet,
        Conversation.noPreference => conversationNoPreference,
        Conversation.unspecified => commonNotSpecified,
      };

  String yesNo(YesNo v) => switch (v) {
        YesNo.yes => optionYes,
        YesNo.no => optionNo,
        YesNo.unspecified => commonNotSpecified,
      };

  /// Specified amenities as icon + sentence, in display order. Unspecified ones are skipped.
  List<(IconData, String)> amenityLines(Amenities a) => [
        if (a.airConditioning != YesNo.unspecified)
          (Icons.ac_unit_rounded, a.airConditioning == YesNo.yes ? acYes : acNo),
        if (a.audioSystem != YesNo.unspecified) (Icons.speaker_rounded, a.audioSystem == YesNo.yes ? audioYes : audioNo),
        if (a.music != MusicPolicy.unspecified) (Icons.music_note_rounded, music(a.music)),
        if (a.smoking != SmokingPolicy.unspecified) (Icons.smoke_free_rounded, smoking(a.smoking)),
        if (a.pets != PetsPolicy.unspecified) (Icons.pets_rounded, pets(a.pets)),
        if (a.luggage != LuggageSize.unspecified) (Icons.luggage_rounded, luggage(a.luggage)),
        if (a.childSeat != YesNo.unspecified)
          (Icons.child_friendly_rounded, a.childSeat == YesNo.yes ? childSeatYes : childSeatNo),
        if (a.conversation != Conversation.unspecified) (Icons.forum_rounded, conversation(a.conversation)),
      ];
}

StatusTone tripTone(TripStatus s) => switch (s) {
      TripStatus.active => StatusTone.positive,
      TripStatus.inProgress => StatusTone.pending,
      TripStatus.full || TripStatus.completed => StatusTone.neutral,
      TripStatus.cancelled || TripStatus.expired => StatusTone.negative,
    };

StatusTone bookingTone(BookingStatus s) => switch (s) {
      BookingStatus.pending => StatusTone.pending,
      BookingStatus.approved => StatusTone.positive,
      BookingStatus.completed => StatusTone.neutral,
      _ => StatusTone.negative,
    };

class TripStatusChip extends StatelessWidget {
  const TripStatusChip(this.status, {super.key});
  final TripStatus status;

  @override
  Widget build(BuildContext context) => StatusChip(label: context.l10n.tripStatus(status), tone: tripTone(status));
}

class BookingStatusChip extends StatelessWidget {
  const BookingStatusChip(this.status, {super.key});
  final BookingStatus status;

  @override
  Widget build(BuildContext context) => StatusChip(label: context.l10n.bookingStatus(status), tone: bookingTone(status));
}
