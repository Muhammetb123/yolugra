// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Ýolugra';

  @override
  String get appTagline => 'Share the road between cities';

  @override
  String get navHome => 'Home';

  @override
  String get navSearch => 'Search';

  @override
  String get navPublish => 'Publish';

  @override
  String get navMyTrips => 'My trips';

  @override
  String get navProfile => 'Profile';

  @override
  String get commonContinue => 'Continue';

  @override
  String get commonSave => 'Save';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonRetry => 'Try again';

  @override
  String get commonClose => 'Close';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonEdit => 'Edit';

  @override
  String get commonConfirm => 'Confirm';

  @override
  String get commonBack => 'Back';

  @override
  String get commonNext => 'Next';

  @override
  String get commonDone => 'Done';

  @override
  String get commonOptional => 'Optional';

  @override
  String get commonNotSpecified => 'Not specified';

  @override
  String get commonCall => 'Call';

  @override
  String get commonSeeAll => 'See all';

  @override
  String get commonKeep => 'Keep';

  @override
  String get commonLoadMore => 'Show more';

  @override
  String get authWelcomeTitle => 'Travel together between cities';

  @override
  String get authWelcomeSubtitle =>
      'Find a ride or offer free seats in your car. Sign in with your mobile number.';

  @override
  String get authPhoneLabel => 'Mobile number';

  @override
  String get authPhoneHint => '6X XX XX XX';

  @override
  String get authSendCode => 'Get code';

  @override
  String get authSmsNote =>
      'We will send a one-time code by SMS. Never share it with anyone.';

  @override
  String get authCodeTitle => 'Enter the code';

  @override
  String authCodeSentTo(String phone) {
    return 'We sent an SMS with a 6-digit code to $phone';
  }

  @override
  String get authCodeLabel => 'Code from SMS';

  @override
  String get authVerify => 'Confirm';

  @override
  String authResendIn(int seconds) {
    return 'Send again in $seconds s';
  }

  @override
  String get authResend => 'Send the code again';

  @override
  String get authChangeNumber => 'Change number';

  @override
  String get authCodeResent => 'A new code is on its way';

  @override
  String get completeProfileTitle => 'About you';

  @override
  String get completeProfileSubtitle =>
      'Drivers and passengers see your name. Your phone number stays private until a booking is accepted.';

  @override
  String get completeProfileButton => 'Get started';

  @override
  String get firstNameLabel => 'First name';

  @override
  String get lastNameLabel => 'Last name';

  @override
  String get bioLabel => 'About me';

  @override
  String get bioHint => 'A few words about you';

  @override
  String get validationRequired => 'This field is required';

  @override
  String get validationPhone =>
      'Enter a Turkmenistan mobile number: 8 digits starting with 6 or 7';

  @override
  String get validationCode => 'Enter the 6-digit code';

  @override
  String validationTooLong(int max) {
    return 'Too long, at most $max characters';
  }

  @override
  String get validationPrice => 'Enter a price from 0 to 100000';

  @override
  String get validationYear => 'Enter a year between 1950 and 2100';

  @override
  String validationSeatsVehicle(int seats) {
    return 'Your car has $seats passenger seats';
  }

  @override
  String get validationSameStops =>
      'Each city can appear on the route only once';

  @override
  String get validationRouteIncomplete =>
      'Choose the departure and destination cities';

  @override
  String get validationDepartureFuture =>
      'The departure time must be in the future';

  @override
  String get validationDuration =>
      'The trip must last from 15 minutes to 48 hours';

  @override
  String get validationVehicle => 'Choose a car';

  @override
  String get validationSegment =>
      'Choose a pick-up point before the drop-off point';

  @override
  String get errorNetwork =>
      'No connection to the server. Check the internet and try again.';

  @override
  String get errorTimeout =>
      'The server is taking too long to answer. Please try again.';

  @override
  String get errorUnknown => 'Something went wrong. Please try again.';

  @override
  String get errorValidation =>
      'Some data is not valid. Please check the form.';

  @override
  String get errorNotFound => 'Not found. It may have been removed.';

  @override
  String get errorForbidden => 'You are not allowed to do this.';

  @override
  String get errorUnauthorized =>
      'Your session has ended. Please sign in again.';

  @override
  String get errorUserBlocked => 'This account cannot be used.';

  @override
  String get errorProfileIncomplete =>
      'Add your first and last name to your profile first.';

  @override
  String get errorTripOverlap =>
      'You already have a trip at this time. Your trips must not overlap and need a short break between them.';

  @override
  String get errorInsufficientSeats =>
      'There are not enough free seats on this part of the route anymore.';

  @override
  String get errorTripNotActive => 'This trip is no longer available.';

  @override
  String get errorTripStarted => 'The trip has already started.';

  @override
  String get errorTripNotStarted => 'The trip has not started yet.';

  @override
  String get errorBookingNotPending =>
      'This request has already been answered.';

  @override
  String get errorInvalidSegment =>
      'Choose a pick-up point that comes before the drop-off point.';

  @override
  String get errorBookingExists => 'You already have a request for this trip.';

  @override
  String get errorOwnTrip => 'You cannot book your own trip.';

  @override
  String get errorInvalidTransition => 'This booking can no longer be changed.';

  @override
  String get errorReviewNotAllowed =>
      'You can leave a review only after a completed trip.';

  @override
  String get errorReviewExists => 'You have already reviewed this trip.';

  @override
  String get errorSeatsBelowBooked =>
      'Seats cannot be fewer than the seats already accepted.';

  @override
  String get errorTripHasBookings =>
      'This cannot be changed while the trip has requests or passengers.';

  @override
  String get errorPhoneTaken =>
      'This number is already used by another account.';

  @override
  String get errorLocationInactive => 'One of the places is not available.';

  @override
  String get errorContactUnavailable =>
      'The phone number is shown only after the request is accepted.';

  @override
  String get errorUserUnavailable => 'You cannot travel with this user.';

  @override
  String get errorFileTooLarge =>
      'The photo is too large. Choose one up to 5 MB.';

  @override
  String get errorUnsupportedMedia => 'Choose a JPEG, PNG or WebP photo.';

  @override
  String get errorRateLimited =>
      'Too many attempts. Please wait a moment and try again.';

  @override
  String get errorInvalidPhone => 'Enter a Turkmenistan mobile number.';

  @override
  String get errorInvalidCode => 'The code is wrong or has expired.';

  @override
  String get errorServer =>
      'The server could not process the request. Please try again later.';

  @override
  String homeGreeting(String name) {
    return 'Hello, $name!';
  }

  @override
  String get homeTitle => 'Where are you going?';

  @override
  String get homeFrom => 'From';

  @override
  String get homeTo => 'To';

  @override
  String get homeDate => 'Date';

  @override
  String get homeAnyDate => 'Any day';

  @override
  String get homePassengers => 'Passengers';

  @override
  String get homeSearch => 'Find a ride';

  @override
  String get homeUpcoming => 'Your upcoming trips';

  @override
  String get homeRecent => 'Recently published';

  @override
  String get homeNoRecent =>
      'No upcoming trips yet. Be the first to publish one!';

  @override
  String get homePublishTitle => 'Driving somewhere?';

  @override
  String get homePublishSubtitle =>
      'Offer the free seats in your car and share the road.';

  @override
  String get homePublishButton => 'Publish a trip';

  @override
  String get homeSwap => 'Swap cities';

  @override
  String get dateToday => 'Today';

  @override
  String get dateTomorrow => 'Tomorrow';

  @override
  String get locationPickerTitle => 'Choose a place';

  @override
  String get locationSearchHint => 'City or welayat';

  @override
  String get locationEmpty => 'Nothing found';

  @override
  String get locationTypeWelayat => 'Welayat';

  @override
  String get locationWholeWelayat => 'Whole welayat';

  @override
  String get searchTitle => 'Find a ride';

  @override
  String get searchAnywhere => 'Anywhere';

  @override
  String get searchFilters => 'Filters';

  @override
  String get searchSort => 'Sort';

  @override
  String get searchEmptyTitle => 'No rides found';

  @override
  String get searchEmptySubtitle =>
      'Try another date, fewer seats or a nearby city.';

  @override
  String get sortDeparture => 'Earliest departure';

  @override
  String get sortPriceAsc => 'Lowest price';

  @override
  String get sortPriceDesc => 'Highest price';

  @override
  String get sortRating => 'Best rated drivers';

  @override
  String get filterPriceMax => 'Maximum price per seat';

  @override
  String get filterDepartureTime => 'Departure time';

  @override
  String get filterTimeAny => 'Any time';

  @override
  String get filterTimeMorning => 'Morning (before 12:00)';

  @override
  String get filterTimeAfternoon => 'Afternoon (12:00–18:00)';

  @override
  String get filterTimeEvening => 'Evening (after 18:00)';

  @override
  String get filterComfort => 'Comfort';

  @override
  String get filterLuggage => 'Luggage at least';

  @override
  String get filterMinRating => 'Driver rating from 4 stars';

  @override
  String get filterApply => 'Show rides';

  @override
  String get filterReset => 'Reset';

  @override
  String seatsLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count seats left',
      one: '1 seat left',
      zero: 'No free seats',
    );
    return '$_temp0';
  }

  @override
  String seatsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count seats',
      one: '1 seat',
    );
    return '$_temp0';
  }

  @override
  String passengersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count passengers',
      one: '1 passenger',
    );
    return '$_temp0';
  }

  @override
  String priceAmount(String amount) {
    return '$amount TMT';
  }

  @override
  String durationValue(int hours, int minutes) {
    return '$hours h $minutes min';
  }

  @override
  String ratingValue(String rating, int count) {
    return '$rating · $count reviews';
  }

  @override
  String completedTripsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count trips',
      one: '1 trip',
      zero: 'No trips yet',
    );
    return '$_temp0';
  }

  @override
  String get newDriver => 'New on Ýolugra';

  @override
  String get tripTitle => 'Trip';

  @override
  String get tripRoute => 'Route';

  @override
  String get tripDriver => 'Driver';

  @override
  String get tripVehicle => 'Car';

  @override
  String get tripComfort => 'Comfort';

  @override
  String get tripDescription => 'From the driver';

  @override
  String get tripConditions => 'Conditions';

  @override
  String get tripPerSeat => 'per seat';

  @override
  String get tripNegotiable => 'Price is negotiable';

  @override
  String get tripPriceOnRequest => 'Ask the driver';

  @override
  String tripApproxArrival(String time) {
    return 'Arrival ≈ $time';
  }

  @override
  String get tripEstimateNote => 'Arrival times are the driver\'s estimate.';

  @override
  String get tripMeetingPoint => 'Meeting point';

  @override
  String get tripPlate => 'Plate number';

  @override
  String get tripPlateHidden =>
      'The plate number is shown after the driver accepts your request.';

  @override
  String get tripYourOwn => 'This is your trip';

  @override
  String get tripManageRequests => 'Manage requests';

  @override
  String get tripPaymentNote =>
      'Payment is arranged directly with the driver. Ýolugra does not process payments.';

  @override
  String get tripStopPickupOnly => 'Boarding only';

  @override
  String get tripStopDropoffOnly => 'Drop-off only';

  @override
  String get bookFormTitle => 'Request seats';

  @override
  String get bookPickup => 'Pick-up';

  @override
  String get bookDropoff => 'Drop-off';

  @override
  String get bookSeats => 'Seats';

  @override
  String get bookLuggage => 'Your luggage';

  @override
  String get bookMessage => 'Message to the driver';

  @override
  String get bookMessageHint =>
      'For example: I will wait at the bus station entrance';

  @override
  String bookFreeOnSegment(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count seats free on this part',
      one: '1 seat free on this part',
      zero: 'No free seats on this part',
    );
    return '$_temp0';
  }

  @override
  String bookTotal(String amount) {
    return 'Total: $amount';
  }

  @override
  String get bookSubmit => 'Send request';

  @override
  String get bookNote =>
      'Your seat is confirmed only when the driver accepts the request. The driver\'s number becomes visible after that.';

  @override
  String get bookSent =>
      'Request sent. We will notify you when the driver answers.';

  @override
  String get bookViewRequest => 'View my request';

  @override
  String get amenityAirConditioning => 'Air conditioning';

  @override
  String get amenityAudio => 'Music system';

  @override
  String get amenityMusic => 'Music';

  @override
  String get amenitySmoking => 'Smoking';

  @override
  String get amenityPets => 'Pets';

  @override
  String get amenityLuggage => 'Luggage';

  @override
  String get amenityChildSeat => 'Child seat';

  @override
  String get amenityConversation => 'Conversation';

  @override
  String get optionYes => 'Yes';

  @override
  String get optionNo => 'No';

  @override
  String get acYes => 'Air conditioning';

  @override
  String get acNo => 'No air conditioning';

  @override
  String get audioYes => 'Music system';

  @override
  String get audioNo => 'No music system';

  @override
  String get musicAllowed => 'Music is welcome';

  @override
  String get musicNone => 'Prefers no music';

  @override
  String get musicDriverDecides => 'Driver chooses the music';

  @override
  String get smokingAllowed => 'Smoking allowed';

  @override
  String get smokingProhibited => 'No smoking';

  @override
  String get petsAllowed => 'Pets welcome';

  @override
  String get petsNotAllowed => 'No pets';

  @override
  String get luggageNone => 'No extra luggage';

  @override
  String get luggageSmall => 'Small bags';

  @override
  String get luggageMedium => 'Medium suitcases';

  @override
  String get luggageLarge => 'Large suitcases';

  @override
  String get childSeatYes => 'Child seat available';

  @override
  String get childSeatNo => 'No child seat';

  @override
  String get conversationFriendly => 'Enjoys a chat';

  @override
  String get conversationQuiet => 'Prefers a quiet ride';

  @override
  String get conversationNoPreference => 'Either is fine';

  @override
  String get tripStatusActive => 'Published';

  @override
  String get tripStatusFull => 'Full';

  @override
  String get tripStatusInProgress => 'On the way';

  @override
  String get tripStatusCompleted => 'Completed';

  @override
  String get tripStatusCancelled => 'Cancelled';

  @override
  String get tripStatusExpired => 'Expired';

  @override
  String get bookingStatusPending => 'Waiting for answer';

  @override
  String get bookingStatusApproved => 'Accepted';

  @override
  String get bookingStatusRejected => 'Declined';

  @override
  String get bookingStatusCancelledByPassenger => 'Cancelled by passenger';

  @override
  String get bookingStatusCancelledByDriver => 'Cancelled by driver';

  @override
  String get bookingStatusCompleted => 'Completed';

  @override
  String get bookingStatusExpired => 'Expired';

  @override
  String get publishTitle => 'Publish a trip';

  @override
  String get publishStepRoute => 'Route';

  @override
  String get publishStepSchedule => 'When';

  @override
  String get publishStepVehicle => 'Car';

  @override
  String get publishStepComfort => 'Comfort';

  @override
  String get publishStepPrice => 'Price';

  @override
  String get publishStepReview => 'Review';

  @override
  String publishStepOf(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String get publishDeparture => 'Departure';

  @override
  String get publishDestination => 'Destination';

  @override
  String get publishChooseCity => 'Choose a city';

  @override
  String get publishMeetingPoint => 'Meeting point';

  @override
  String get publishMeetingPointHint =>
      'Exact place, for example the bazaar entrance';

  @override
  String get publishAddStop => 'Add a stop on the way';

  @override
  String publishStop(int index) {
    return 'Stop $index';
  }

  @override
  String get publishStopType => 'Passengers can';

  @override
  String get stopTypeBoth => 'Board and leave';

  @override
  String get stopTypePickup => 'Only board';

  @override
  String get stopTypeDropoff => 'Only leave';

  @override
  String get publishStopTime => 'Estimated time here';

  @override
  String get publishRemoveStop => 'Remove stop';

  @override
  String get publishMoveUp => 'Move up';

  @override
  String get publishMoveDown => 'Move down';

  @override
  String get publishDate => 'Departure date';

  @override
  String get publishTime => 'Departure time';

  @override
  String get publishDuration => 'Estimated trip duration';

  @override
  String publishArrivalPreview(String time) {
    return 'Estimated arrival: $time';
  }

  @override
  String get publishChooseVehicle => 'Which car are you driving?';

  @override
  String get publishNoVehicles =>
      'Add your car so passengers can recognise it.';

  @override
  String get publishSeats => 'Seats for passengers';

  @override
  String get publishSeatsHint =>
      'Count only passenger seats, without the driver\'s seat.';

  @override
  String get publishPrice => 'Price per seat, TMT';

  @override
  String get publishPriceHint => 'Leave empty to agree with passengers';

  @override
  String get publishNegotiable => 'The price is negotiable';

  @override
  String get publishDescription => 'Trip description';

  @override
  String get publishDescriptionHint =>
      'For example: one short stop on the way, two large suitcases fit in the trunk';

  @override
  String get publishConditions => 'Additional conditions';

  @override
  String get publishConditionsHint => 'For example: please be on time';

  @override
  String get publishSubmit => 'Publish the trip';

  @override
  String get publishSuccess => 'Your trip is published';

  @override
  String get publishComfortHint =>
      'All options are optional. Passengers see only what you choose.';

  @override
  String get vehiclesTitle => 'My cars';

  @override
  String get vehicleAdd => 'Add a car';

  @override
  String get vehicleEdit => 'Edit car';

  @override
  String get vehicleBrand => 'Make';

  @override
  String get vehicleBrandHint => 'For example Toyota';

  @override
  String get vehicleModel => 'Model';

  @override
  String get vehicleModelHint => 'For example Camry';

  @override
  String get vehicleColor => 'Colour';

  @override
  String get vehiclePlate => 'Plate number';

  @override
  String get vehiclePlateNote =>
      'Only passengers you accept see the plate number.';

  @override
  String get vehicleYear => 'Year';

  @override
  String get vehicleType => 'Body type';

  @override
  String get vehicleSeats => 'Passenger seats';

  @override
  String get vehiclePhoto => 'Car photo';

  @override
  String get vehicleEmpty => 'You have not added a car yet';

  @override
  String get vehicleDeleteConfirm => 'Delete this car?';

  @override
  String get vehicleSaved => 'Car saved';

  @override
  String get vehicleTypeSedan => 'Sedan';

  @override
  String get vehicleTypeHatchback => 'Hatchback';

  @override
  String get vehicleTypeWagon => 'Estate';

  @override
  String get vehicleTypeSuv => 'SUV';

  @override
  String get vehicleTypeMinivan => 'Minivan';

  @override
  String get vehicleTypeMinibus => 'Minibus';

  @override
  String get vehicleTypeOther => 'Other';

  @override
  String get myTripsTitle => 'My trips';

  @override
  String get myTripsAsDriver => 'As driver';

  @override
  String get myTripsAsPassenger => 'As passenger';

  @override
  String get myTripsHistory => 'History';

  @override
  String get myTripsEmptyDriver => 'You have no upcoming trips as a driver.';

  @override
  String get myTripsEmptyPassenger => 'You have no upcoming bookings.';

  @override
  String get myTripsEmptyHistory => 'Your past trips will appear here.';

  @override
  String myTripsNewRequests(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count new requests',
      one: '1 new request',
    );
    return '$_temp0';
  }

  @override
  String myTripsSeatsBooked(int booked, int total) {
    return '$booked of $total seats taken';
  }

  @override
  String get historyAsDriverTitle => 'Trips I drove';

  @override
  String get historyAsPassengerTitle => 'Trips I took';

  @override
  String get manageTitle => 'Trip and requests';

  @override
  String get managePending => 'New requests';

  @override
  String get manageAccepted => 'Accepted passengers';

  @override
  String get manageOther => 'Other requests';

  @override
  String get manageNoRequests =>
      'No requests yet. We will notify you when a passenger asks for a seat.';

  @override
  String get manageAccept => 'Accept';

  @override
  String get manageReject => 'Decline';

  @override
  String get manageRejectConfirm => 'Decline this request?';

  @override
  String get manageCancelBooking => 'Cancel booking';

  @override
  String get manageCancelBookingConfirm =>
      'Cancel this passenger\'s booking? The passenger will be notified.';

  @override
  String get manageCancelTrip => 'Cancel trip';

  @override
  String get manageCancelTripConfirm =>
      'Cancel the whole trip? All passengers and requests will be cancelled and notified.';

  @override
  String get manageCompleteTrip => 'Finish the trip';

  @override
  String get manageCompleteConfirm =>
      'Mark the trip as completed? Passengers will be able to rate it.';

  @override
  String get manageEditTrip => 'Edit trip';

  @override
  String manageRequestedAt(String time) {
    return 'Requested $time';
  }

  @override
  String get manageAccepted1 => 'Request accepted';

  @override
  String get manageRejected1 => 'Request declined';

  @override
  String get manageTripCancelled => 'Trip cancelled';

  @override
  String get manageTripCompleted => 'Trip completed';

  @override
  String get manageRatePassenger => 'Rate passenger';

  @override
  String get editTripTitle => 'Edit trip';

  @override
  String get editTripScheduleLocked =>
      'The date and time can be changed only while the trip has no requests.';

  @override
  String get editTripSaved => 'Trip updated. Passengers have been notified.';

  @override
  String get editTripClearPrice => 'Remove price';

  @override
  String get bookingTitle => 'Booking';

  @override
  String get bookingContact => 'Contact';

  @override
  String get bookingCallDriver => 'Call the driver';

  @override
  String get bookingCallPassenger => 'Call the passenger';

  @override
  String get bookingContactHidden =>
      'The phone number is shown after the driver accepts the request.';

  @override
  String get bookingCancel => 'Cancel booking';

  @override
  String get bookingCancelConfirm =>
      'Cancel your booking? The driver will be notified.';

  @override
  String get bookingCancelled => 'Booking cancelled';

  @override
  String get bookingRate => 'Rate the trip';

  @override
  String get bookingReviewed => 'Thank you, you have rated this trip';

  @override
  String get bookingYourSegment => 'Your part of the route';

  @override
  String get bookingRequestedSeats => 'Requested seats';

  @override
  String get bookingDialerError => 'Could not open the phone app';

  @override
  String get reviewTitle => 'Leave a review';

  @override
  String reviewAboutDriver(String name) {
    return 'How was your trip with $name?';
  }

  @override
  String reviewAboutPassenger(String name) {
    return 'How was $name as a passenger?';
  }

  @override
  String get reviewCommentHint => 'A few words about the trip (optional)';

  @override
  String get reviewSubmit => 'Send review';

  @override
  String get reviewThanks => 'Thank you for your review!';

  @override
  String get reviewChooseRating => 'Choose from 1 to 5 stars';

  @override
  String get reviewsTitle => 'Reviews';

  @override
  String get reviewsEmpty => 'No reviews yet';

  @override
  String get reviewByPassenger => 'Passenger';

  @override
  String get reviewByDriver => 'Driver';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileEdit => 'Edit profile';

  @override
  String get profileChangePhoto => 'Change photo';

  @override
  String get profileRemovePhoto => 'Remove photo';

  @override
  String get profilePhone => 'Phone number';

  @override
  String get profileChangePhone => 'Change number';

  @override
  String get profileVehicles => 'My cars';

  @override
  String get profileReviews => 'Reviews about me';

  @override
  String get profileSettings => 'Settings';

  @override
  String get profileLogout => 'Sign out';

  @override
  String get profileLogoutConfirm => 'Sign out of your account?';

  @override
  String profileMemberSince(String date) {
    return 'Member since $date';
  }

  @override
  String get profileTripsAsDriver => 'As driver';

  @override
  String get profileTripsAsPassenger => 'As passenger';

  @override
  String get profileRating => 'Rating';

  @override
  String get profileSaved => 'Profile saved';

  @override
  String get photoFromGallery => 'Choose from gallery';

  @override
  String get photoFromCamera => 'Take a photo';

  @override
  String get changePhoneTitle => 'Change phone number';

  @override
  String get changePhoneSubtitle =>
      'We will send a code to the new number. Your account and trips stay the same.';

  @override
  String get changePhoneNew => 'New mobile number';

  @override
  String get changePhoneSuccess => 'Phone number changed';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsLanguage => 'App language';

  @override
  String get settingsAbout => 'About Ýolugra';

  @override
  String get settingsAboutText =>
      'Ýolugra connects drivers and passengers travelling between the cities of Turkmenistan. Payments are arranged directly between travellers.';

  @override
  String get languageTk => 'Türkmençe';

  @override
  String get languageRu => 'Русский';

  @override
  String get languageEn => 'English';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsEmpty => 'No notifications yet';

  @override
  String get notificationsMarkAll => 'Mark all as read';

  @override
  String noteBookingRequested(String name, String route) {
    return '$name asks for seats on $route';
  }

  @override
  String noteBookingApproved(String route) {
    return 'Your request for $route was accepted';
  }

  @override
  String noteBookingRejected(String route) {
    return 'Your request for $route was declined';
  }

  @override
  String noteBookingCancelledByPassenger(String name, String route) {
    return '$name cancelled the booking on $route';
  }

  @override
  String noteBookingCancelledByDriver(String route) {
    return 'The driver cancelled your booking on $route';
  }

  @override
  String noteBookingExpired(String route) {
    return 'Your request for $route expired without an answer';
  }

  @override
  String noteTripCancelled(String route) {
    return 'The trip $route was cancelled';
  }

  @override
  String noteTripUpdated(String route) {
    return 'The driver updated the trip $route';
  }

  @override
  String noteTripReminder(String route) {
    return 'The trip $route starts soon';
  }

  @override
  String noteTripCompleted(String route) {
    return 'The trip $route is completed. Rate your travel companions';
  }

  @override
  String noteReviewReceived(String name) {
    return '$name left you a review';
  }

  @override
  String get noteSomeone => 'A user';

  @override
  String get filterAny => 'Any';

  @override
  String get serverTitle => 'Server address';

  @override
  String get serverHint => 'For example 192.168.1.10:8081';

  @override
  String get serverNote =>
      'Test builds only. Enter the computer’s address in the same Wi-Fi network.';

  @override
  String get serverCheck => 'Check connection';

  @override
  String get serverReachable => 'The server answers';

  @override
  String serverUnreachable(String url) {
    return 'No answer from $url. Check the address, the Wi-Fi network and the computer’s firewall.';
  }

  @override
  String get serverInvalid => 'Enter an address like 192.168.1.10:8081';

  @override
  String get serverReset => 'Default';

  @override
  String get serverSaved => 'Server address saved';
}
