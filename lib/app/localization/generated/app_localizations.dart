import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_tk.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
    Locale('tk'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Ýolugra'**
  String get appName;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Share the road between cities'**
  String get appTagline;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get navSearch;

  /// No description provided for @navPublish.
  ///
  /// In en, this message translates to:
  /// **'Publish'**
  String get navPublish;

  /// No description provided for @navMyTrips.
  ///
  /// In en, this message translates to:
  /// **'My trips'**
  String get navMyTrips;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @commonContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get commonContinue;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get commonRetry;

  /// No description provided for @commonClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonClose;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @commonEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get commonEdit;

  /// No description provided for @commonConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get commonConfirm;

  /// No description provided for @commonBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get commonBack;

  /// No description provided for @commonNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get commonNext;

  /// No description provided for @commonDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get commonDone;

  /// No description provided for @commonOptional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get commonOptional;

  /// No description provided for @commonNotSpecified.
  ///
  /// In en, this message translates to:
  /// **'Not specified'**
  String get commonNotSpecified;

  /// No description provided for @commonCall.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get commonCall;

  /// No description provided for @commonSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get commonSeeAll;

  /// No description provided for @commonKeep.
  ///
  /// In en, this message translates to:
  /// **'Keep'**
  String get commonKeep;

  /// No description provided for @commonLoadMore.
  ///
  /// In en, this message translates to:
  /// **'Show more'**
  String get commonLoadMore;

  /// No description provided for @authWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Travel together between cities'**
  String get authWelcomeTitle;

  /// No description provided for @authWelcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Find a ride or offer free seats in your car. Sign in with your mobile number.'**
  String get authWelcomeSubtitle;

  /// No description provided for @authPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Mobile number'**
  String get authPhoneLabel;

  /// No description provided for @authPhoneHint.
  ///
  /// In en, this message translates to:
  /// **'6X XX XX XX'**
  String get authPhoneHint;

  /// No description provided for @authSendCode.
  ///
  /// In en, this message translates to:
  /// **'Get code'**
  String get authSendCode;

  /// No description provided for @authSmsNote.
  ///
  /// In en, this message translates to:
  /// **'We will send a one-time code by SMS. Never share it with anyone.'**
  String get authSmsNote;

  /// No description provided for @authCodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the code'**
  String get authCodeTitle;

  /// No description provided for @authCodeSentTo.
  ///
  /// In en, this message translates to:
  /// **'We sent an SMS with a 6-digit code to {phone}'**
  String authCodeSentTo(String phone);

  /// No description provided for @authCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Code from SMS'**
  String get authCodeLabel;

  /// No description provided for @authVerify.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get authVerify;

  /// No description provided for @authResendIn.
  ///
  /// In en, this message translates to:
  /// **'Send again in {seconds} s'**
  String authResendIn(int seconds);

  /// No description provided for @authResend.
  ///
  /// In en, this message translates to:
  /// **'Send the code again'**
  String get authResend;

  /// No description provided for @authChangeNumber.
  ///
  /// In en, this message translates to:
  /// **'Change number'**
  String get authChangeNumber;

  /// No description provided for @authCodeResent.
  ///
  /// In en, this message translates to:
  /// **'A new code is on its way'**
  String get authCodeResent;

  /// No description provided for @completeProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'About you'**
  String get completeProfileTitle;

  /// No description provided for @completeProfileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Drivers and passengers see your name. Your phone number stays private until a booking is accepted.'**
  String get completeProfileSubtitle;

  /// No description provided for @completeProfileButton.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get completeProfileButton;

  /// No description provided for @firstNameLabel.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get firstNameLabel;

  /// No description provided for @lastNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get lastNameLabel;

  /// No description provided for @bioLabel.
  ///
  /// In en, this message translates to:
  /// **'About me'**
  String get bioLabel;

  /// No description provided for @bioHint.
  ///
  /// In en, this message translates to:
  /// **'A few words about you'**
  String get bioHint;

  /// No description provided for @validationRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get validationRequired;

  /// No description provided for @validationPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter a Turkmenistan mobile number: 8 digits starting with 6 or 7'**
  String get validationPhone;

  /// No description provided for @validationCode.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code'**
  String get validationCode;

  /// No description provided for @validationTooLong.
  ///
  /// In en, this message translates to:
  /// **'Too long, at most {max} characters'**
  String validationTooLong(int max);

  /// No description provided for @validationPrice.
  ///
  /// In en, this message translates to:
  /// **'Enter a price from 0 to 100000'**
  String get validationPrice;

  /// No description provided for @validationYear.
  ///
  /// In en, this message translates to:
  /// **'Enter a year between 1950 and 2100'**
  String get validationYear;

  /// No description provided for @validationSeatsVehicle.
  ///
  /// In en, this message translates to:
  /// **'Your car has {seats} passenger seats'**
  String validationSeatsVehicle(int seats);

  /// No description provided for @validationSameStops.
  ///
  /// In en, this message translates to:
  /// **'Each city can appear on the route only once'**
  String get validationSameStops;

  /// No description provided for @validationRouteIncomplete.
  ///
  /// In en, this message translates to:
  /// **'Choose the departure and destination cities'**
  String get validationRouteIncomplete;

  /// No description provided for @validationDepartureFuture.
  ///
  /// In en, this message translates to:
  /// **'The departure time must be in the future'**
  String get validationDepartureFuture;

  /// No description provided for @validationDuration.
  ///
  /// In en, this message translates to:
  /// **'The trip must last from 15 minutes to 48 hours'**
  String get validationDuration;

  /// No description provided for @validationVehicle.
  ///
  /// In en, this message translates to:
  /// **'Choose a car'**
  String get validationVehicle;

  /// No description provided for @validationSegment.
  ///
  /// In en, this message translates to:
  /// **'Choose a pick-up point before the drop-off point'**
  String get validationSegment;

  /// No description provided for @errorNetwork.
  ///
  /// In en, this message translates to:
  /// **'No connection to the server. Check the internet and try again.'**
  String get errorNetwork;

  /// No description provided for @errorTimeout.
  ///
  /// In en, this message translates to:
  /// **'The server is taking too long to answer. Please try again.'**
  String get errorTimeout;

  /// No description provided for @errorUnknown.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorUnknown;

  /// No description provided for @errorValidation.
  ///
  /// In en, this message translates to:
  /// **'Some data is not valid. Please check the form.'**
  String get errorValidation;

  /// No description provided for @errorNotFound.
  ///
  /// In en, this message translates to:
  /// **'Not found. It may have been removed.'**
  String get errorNotFound;

  /// No description provided for @errorForbidden.
  ///
  /// In en, this message translates to:
  /// **'You are not allowed to do this.'**
  String get errorForbidden;

  /// No description provided for @errorUnauthorized.
  ///
  /// In en, this message translates to:
  /// **'Your session has ended. Please sign in again.'**
  String get errorUnauthorized;

  /// No description provided for @errorUserBlocked.
  ///
  /// In en, this message translates to:
  /// **'This account cannot be used.'**
  String get errorUserBlocked;

  /// No description provided for @errorProfileIncomplete.
  ///
  /// In en, this message translates to:
  /// **'Add your first and last name to your profile first.'**
  String get errorProfileIncomplete;

  /// No description provided for @errorTripOverlap.
  ///
  /// In en, this message translates to:
  /// **'You already have a trip at this time. Your trips must not overlap and need a short break between them.'**
  String get errorTripOverlap;

  /// No description provided for @errorInsufficientSeats.
  ///
  /// In en, this message translates to:
  /// **'There are not enough free seats on this part of the route anymore.'**
  String get errorInsufficientSeats;

  /// No description provided for @errorTripNotActive.
  ///
  /// In en, this message translates to:
  /// **'This trip is no longer available.'**
  String get errorTripNotActive;

  /// No description provided for @errorTripStarted.
  ///
  /// In en, this message translates to:
  /// **'The trip has already started.'**
  String get errorTripStarted;

  /// No description provided for @errorTripNotStarted.
  ///
  /// In en, this message translates to:
  /// **'The trip has not started yet.'**
  String get errorTripNotStarted;

  /// No description provided for @errorBookingNotPending.
  ///
  /// In en, this message translates to:
  /// **'This request has already been answered.'**
  String get errorBookingNotPending;

  /// No description provided for @errorInvalidSegment.
  ///
  /// In en, this message translates to:
  /// **'Choose a pick-up point that comes before the drop-off point.'**
  String get errorInvalidSegment;

  /// No description provided for @errorBookingExists.
  ///
  /// In en, this message translates to:
  /// **'You already have a request for this trip.'**
  String get errorBookingExists;

  /// No description provided for @errorOwnTrip.
  ///
  /// In en, this message translates to:
  /// **'You cannot book your own trip.'**
  String get errorOwnTrip;

  /// No description provided for @errorInvalidTransition.
  ///
  /// In en, this message translates to:
  /// **'This booking can no longer be changed.'**
  String get errorInvalidTransition;

  /// No description provided for @errorReviewNotAllowed.
  ///
  /// In en, this message translates to:
  /// **'You can leave a review only after a completed trip.'**
  String get errorReviewNotAllowed;

  /// No description provided for @errorReviewExists.
  ///
  /// In en, this message translates to:
  /// **'You have already reviewed this trip.'**
  String get errorReviewExists;

  /// No description provided for @errorSeatsBelowBooked.
  ///
  /// In en, this message translates to:
  /// **'Seats cannot be fewer than the seats already accepted.'**
  String get errorSeatsBelowBooked;

  /// No description provided for @errorTripHasBookings.
  ///
  /// In en, this message translates to:
  /// **'This cannot be changed while the trip has requests or passengers.'**
  String get errorTripHasBookings;

  /// No description provided for @errorPhoneTaken.
  ///
  /// In en, this message translates to:
  /// **'This number is already used by another account.'**
  String get errorPhoneTaken;

  /// No description provided for @errorLocationInactive.
  ///
  /// In en, this message translates to:
  /// **'One of the places is not available.'**
  String get errorLocationInactive;

  /// No description provided for @errorContactUnavailable.
  ///
  /// In en, this message translates to:
  /// **'The phone number is shown only after the request is accepted.'**
  String get errorContactUnavailable;

  /// No description provided for @errorUserUnavailable.
  ///
  /// In en, this message translates to:
  /// **'You cannot travel with this user.'**
  String get errorUserUnavailable;

  /// No description provided for @errorFileTooLarge.
  ///
  /// In en, this message translates to:
  /// **'The photo is too large. Choose one up to 5 MB.'**
  String get errorFileTooLarge;

  /// No description provided for @errorUnsupportedMedia.
  ///
  /// In en, this message translates to:
  /// **'Choose a JPEG, PNG or WebP photo.'**
  String get errorUnsupportedMedia;

  /// No description provided for @errorRateLimited.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Please wait a moment and try again.'**
  String get errorRateLimited;

  /// No description provided for @errorInvalidPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter a Turkmenistan mobile number.'**
  String get errorInvalidPhone;

  /// No description provided for @errorInvalidCode.
  ///
  /// In en, this message translates to:
  /// **'The code is wrong or has expired.'**
  String get errorInvalidCode;

  /// No description provided for @errorServer.
  ///
  /// In en, this message translates to:
  /// **'The server could not process the request. Please try again later.'**
  String get errorServer;

  /// No description provided for @homeGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hello, {name}!'**
  String homeGreeting(String name);

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Where are you going?'**
  String get homeTitle;

  /// No description provided for @homeFrom.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get homeFrom;

  /// No description provided for @homeTo.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get homeTo;

  /// No description provided for @homeDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get homeDate;

  /// No description provided for @homeAnyDate.
  ///
  /// In en, this message translates to:
  /// **'Any day'**
  String get homeAnyDate;

  /// No description provided for @homePassengers.
  ///
  /// In en, this message translates to:
  /// **'Passengers'**
  String get homePassengers;

  /// No description provided for @homeSearch.
  ///
  /// In en, this message translates to:
  /// **'Find a ride'**
  String get homeSearch;

  /// No description provided for @homeUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Your upcoming trips'**
  String get homeUpcoming;

  /// No description provided for @homeRecent.
  ///
  /// In en, this message translates to:
  /// **'Recently published'**
  String get homeRecent;

  /// No description provided for @homeNoRecent.
  ///
  /// In en, this message translates to:
  /// **'No upcoming trips yet. Be the first to publish one!'**
  String get homeNoRecent;

  /// No description provided for @homePublishTitle.
  ///
  /// In en, this message translates to:
  /// **'Driving somewhere?'**
  String get homePublishTitle;

  /// No description provided for @homePublishSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Offer the free seats in your car and share the road.'**
  String get homePublishSubtitle;

  /// No description provided for @homePublishButton.
  ///
  /// In en, this message translates to:
  /// **'Publish a trip'**
  String get homePublishButton;

  /// No description provided for @homeSwap.
  ///
  /// In en, this message translates to:
  /// **'Swap cities'**
  String get homeSwap;

  /// No description provided for @dateToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get dateToday;

  /// No description provided for @dateTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get dateTomorrow;

  /// No description provided for @locationPickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a place'**
  String get locationPickerTitle;

  /// No description provided for @locationSearchHint.
  ///
  /// In en, this message translates to:
  /// **'City or welayat'**
  String get locationSearchHint;

  /// No description provided for @locationEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing found'**
  String get locationEmpty;

  /// No description provided for @locationTypeWelayat.
  ///
  /// In en, this message translates to:
  /// **'Welayat'**
  String get locationTypeWelayat;

  /// No description provided for @locationWholeWelayat.
  ///
  /// In en, this message translates to:
  /// **'Whole welayat'**
  String get locationWholeWelayat;

  /// No description provided for @searchTitle.
  ///
  /// In en, this message translates to:
  /// **'Find a ride'**
  String get searchTitle;

  /// No description provided for @searchAnywhere.
  ///
  /// In en, this message translates to:
  /// **'Anywhere'**
  String get searchAnywhere;

  /// No description provided for @searchFilters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get searchFilters;

  /// No description provided for @searchSort.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get searchSort;

  /// No description provided for @searchEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No rides found'**
  String get searchEmptyTitle;

  /// No description provided for @searchEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Try another date, fewer seats or a nearby city.'**
  String get searchEmptySubtitle;

  /// No description provided for @sortDeparture.
  ///
  /// In en, this message translates to:
  /// **'Earliest departure'**
  String get sortDeparture;

  /// No description provided for @sortPriceAsc.
  ///
  /// In en, this message translates to:
  /// **'Lowest price'**
  String get sortPriceAsc;

  /// No description provided for @sortPriceDesc.
  ///
  /// In en, this message translates to:
  /// **'Highest price'**
  String get sortPriceDesc;

  /// No description provided for @sortRating.
  ///
  /// In en, this message translates to:
  /// **'Best rated drivers'**
  String get sortRating;

  /// No description provided for @filterPriceMax.
  ///
  /// In en, this message translates to:
  /// **'Maximum price per seat'**
  String get filterPriceMax;

  /// No description provided for @filterDepartureTime.
  ///
  /// In en, this message translates to:
  /// **'Departure time'**
  String get filterDepartureTime;

  /// No description provided for @filterTimeAny.
  ///
  /// In en, this message translates to:
  /// **'Any time'**
  String get filterTimeAny;

  /// No description provided for @filterTimeMorning.
  ///
  /// In en, this message translates to:
  /// **'Morning (before 12:00)'**
  String get filterTimeMorning;

  /// No description provided for @filterTimeAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Afternoon (12:00–18:00)'**
  String get filterTimeAfternoon;

  /// No description provided for @filterTimeEvening.
  ///
  /// In en, this message translates to:
  /// **'Evening (after 18:00)'**
  String get filterTimeEvening;

  /// No description provided for @filterComfort.
  ///
  /// In en, this message translates to:
  /// **'Comfort'**
  String get filterComfort;

  /// No description provided for @filterLuggage.
  ///
  /// In en, this message translates to:
  /// **'Luggage at least'**
  String get filterLuggage;

  /// No description provided for @filterMinRating.
  ///
  /// In en, this message translates to:
  /// **'Driver rating from 4 stars'**
  String get filterMinRating;

  /// No description provided for @filterApply.
  ///
  /// In en, this message translates to:
  /// **'Show rides'**
  String get filterApply;

  /// No description provided for @filterReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get filterReset;

  /// No description provided for @seatsLeft.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No free seats} =1{1 seat left} other{{count} seats left}}'**
  String seatsLeft(int count);

  /// No description provided for @seatsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 seat} other{{count} seats}}'**
  String seatsCount(int count);

  /// No description provided for @passengersCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 passenger} other{{count} passengers}}'**
  String passengersCount(int count);

  /// No description provided for @priceAmount.
  ///
  /// In en, this message translates to:
  /// **'{amount} TMT'**
  String priceAmount(String amount);

  /// No description provided for @durationValue.
  ///
  /// In en, this message translates to:
  /// **'{hours} h {minutes} min'**
  String durationValue(int hours, int minutes);

  /// No description provided for @ratingValue.
  ///
  /// In en, this message translates to:
  /// **'{rating} · {count} reviews'**
  String ratingValue(String rating, int count);

  /// No description provided for @completedTripsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No trips yet} =1{1 trip} other{{count} trips}}'**
  String completedTripsCount(int count);

  /// No description provided for @newDriver.
  ///
  /// In en, this message translates to:
  /// **'New on Ýolugra'**
  String get newDriver;

  /// No description provided for @tripTitle.
  ///
  /// In en, this message translates to:
  /// **'Trip'**
  String get tripTitle;

  /// No description provided for @tripRoute.
  ///
  /// In en, this message translates to:
  /// **'Route'**
  String get tripRoute;

  /// No description provided for @tripDriver.
  ///
  /// In en, this message translates to:
  /// **'Driver'**
  String get tripDriver;

  /// No description provided for @tripVehicle.
  ///
  /// In en, this message translates to:
  /// **'Car'**
  String get tripVehicle;

  /// No description provided for @tripComfort.
  ///
  /// In en, this message translates to:
  /// **'Comfort'**
  String get tripComfort;

  /// No description provided for @tripDescription.
  ///
  /// In en, this message translates to:
  /// **'From the driver'**
  String get tripDescription;

  /// No description provided for @tripConditions.
  ///
  /// In en, this message translates to:
  /// **'Conditions'**
  String get tripConditions;

  /// No description provided for @tripPerSeat.
  ///
  /// In en, this message translates to:
  /// **'per seat'**
  String get tripPerSeat;

  /// No description provided for @tripNegotiable.
  ///
  /// In en, this message translates to:
  /// **'Price is negotiable'**
  String get tripNegotiable;

  /// No description provided for @tripPriceOnRequest.
  ///
  /// In en, this message translates to:
  /// **'Ask the driver'**
  String get tripPriceOnRequest;

  /// No description provided for @tripApproxArrival.
  ///
  /// In en, this message translates to:
  /// **'Arrival ≈ {time}'**
  String tripApproxArrival(String time);

  /// No description provided for @tripEstimateNote.
  ///
  /// In en, this message translates to:
  /// **'Arrival times are the driver\'s estimate.'**
  String get tripEstimateNote;

  /// No description provided for @tripMeetingPoint.
  ///
  /// In en, this message translates to:
  /// **'Meeting point'**
  String get tripMeetingPoint;

  /// No description provided for @tripPlate.
  ///
  /// In en, this message translates to:
  /// **'Plate number'**
  String get tripPlate;

  /// No description provided for @tripPlateHidden.
  ///
  /// In en, this message translates to:
  /// **'The plate number is shown after the driver accepts your request.'**
  String get tripPlateHidden;

  /// No description provided for @tripYourOwn.
  ///
  /// In en, this message translates to:
  /// **'This is your trip'**
  String get tripYourOwn;

  /// No description provided for @tripManageRequests.
  ///
  /// In en, this message translates to:
  /// **'Manage requests'**
  String get tripManageRequests;

  /// No description provided for @tripPaymentNote.
  ///
  /// In en, this message translates to:
  /// **'Payment is arranged directly with the driver. Ýolugra does not process payments.'**
  String get tripPaymentNote;

  /// No description provided for @tripStopPickupOnly.
  ///
  /// In en, this message translates to:
  /// **'Boarding only'**
  String get tripStopPickupOnly;

  /// No description provided for @tripStopDropoffOnly.
  ///
  /// In en, this message translates to:
  /// **'Drop-off only'**
  String get tripStopDropoffOnly;

  /// No description provided for @bookFormTitle.
  ///
  /// In en, this message translates to:
  /// **'Request seats'**
  String get bookFormTitle;

  /// No description provided for @bookPickup.
  ///
  /// In en, this message translates to:
  /// **'Pick-up'**
  String get bookPickup;

  /// No description provided for @bookDropoff.
  ///
  /// In en, this message translates to:
  /// **'Drop-off'**
  String get bookDropoff;

  /// No description provided for @bookSeats.
  ///
  /// In en, this message translates to:
  /// **'Seats'**
  String get bookSeats;

  /// No description provided for @bookLuggage.
  ///
  /// In en, this message translates to:
  /// **'Your luggage'**
  String get bookLuggage;

  /// No description provided for @bookMessage.
  ///
  /// In en, this message translates to:
  /// **'Message to the driver'**
  String get bookMessage;

  /// No description provided for @bookMessageHint.
  ///
  /// In en, this message translates to:
  /// **'For example: I will wait at the bus station entrance'**
  String get bookMessageHint;

  /// No description provided for @bookFreeOnSegment.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No free seats on this part} =1{1 seat free on this part} other{{count} seats free on this part}}'**
  String bookFreeOnSegment(int count);

  /// No description provided for @bookTotal.
  ///
  /// In en, this message translates to:
  /// **'Total: {amount}'**
  String bookTotal(String amount);

  /// No description provided for @bookSubmit.
  ///
  /// In en, this message translates to:
  /// **'Send request'**
  String get bookSubmit;

  /// No description provided for @bookNote.
  ///
  /// In en, this message translates to:
  /// **'Your seat is confirmed only when the driver accepts the request. The driver\'s number becomes visible after that.'**
  String get bookNote;

  /// No description provided for @bookSent.
  ///
  /// In en, this message translates to:
  /// **'Request sent. We will notify you when the driver answers.'**
  String get bookSent;

  /// No description provided for @bookViewRequest.
  ///
  /// In en, this message translates to:
  /// **'View my request'**
  String get bookViewRequest;

  /// No description provided for @amenityAirConditioning.
  ///
  /// In en, this message translates to:
  /// **'Air conditioning'**
  String get amenityAirConditioning;

  /// No description provided for @amenityAudio.
  ///
  /// In en, this message translates to:
  /// **'Music system'**
  String get amenityAudio;

  /// No description provided for @amenityMusic.
  ///
  /// In en, this message translates to:
  /// **'Music'**
  String get amenityMusic;

  /// No description provided for @amenitySmoking.
  ///
  /// In en, this message translates to:
  /// **'Smoking'**
  String get amenitySmoking;

  /// No description provided for @amenityPets.
  ///
  /// In en, this message translates to:
  /// **'Pets'**
  String get amenityPets;

  /// No description provided for @amenityLuggage.
  ///
  /// In en, this message translates to:
  /// **'Luggage'**
  String get amenityLuggage;

  /// No description provided for @amenityChildSeat.
  ///
  /// In en, this message translates to:
  /// **'Child seat'**
  String get amenityChildSeat;

  /// No description provided for @amenityConversation.
  ///
  /// In en, this message translates to:
  /// **'Conversation'**
  String get amenityConversation;

  /// No description provided for @optionYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get optionYes;

  /// No description provided for @optionNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get optionNo;

  /// No description provided for @acYes.
  ///
  /// In en, this message translates to:
  /// **'Air conditioning'**
  String get acYes;

  /// No description provided for @acNo.
  ///
  /// In en, this message translates to:
  /// **'No air conditioning'**
  String get acNo;

  /// No description provided for @audioYes.
  ///
  /// In en, this message translates to:
  /// **'Music system'**
  String get audioYes;

  /// No description provided for @audioNo.
  ///
  /// In en, this message translates to:
  /// **'No music system'**
  String get audioNo;

  /// No description provided for @musicAllowed.
  ///
  /// In en, this message translates to:
  /// **'Music is welcome'**
  String get musicAllowed;

  /// No description provided for @musicNone.
  ///
  /// In en, this message translates to:
  /// **'Prefers no music'**
  String get musicNone;

  /// No description provided for @musicDriverDecides.
  ///
  /// In en, this message translates to:
  /// **'Driver chooses the music'**
  String get musicDriverDecides;

  /// No description provided for @smokingAllowed.
  ///
  /// In en, this message translates to:
  /// **'Smoking allowed'**
  String get smokingAllowed;

  /// No description provided for @smokingProhibited.
  ///
  /// In en, this message translates to:
  /// **'No smoking'**
  String get smokingProhibited;

  /// No description provided for @petsAllowed.
  ///
  /// In en, this message translates to:
  /// **'Pets welcome'**
  String get petsAllowed;

  /// No description provided for @petsNotAllowed.
  ///
  /// In en, this message translates to:
  /// **'No pets'**
  String get petsNotAllowed;

  /// No description provided for @luggageNone.
  ///
  /// In en, this message translates to:
  /// **'No extra luggage'**
  String get luggageNone;

  /// No description provided for @luggageSmall.
  ///
  /// In en, this message translates to:
  /// **'Small bags'**
  String get luggageSmall;

  /// No description provided for @luggageMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium suitcases'**
  String get luggageMedium;

  /// No description provided for @luggageLarge.
  ///
  /// In en, this message translates to:
  /// **'Large suitcases'**
  String get luggageLarge;

  /// No description provided for @childSeatYes.
  ///
  /// In en, this message translates to:
  /// **'Child seat available'**
  String get childSeatYes;

  /// No description provided for @childSeatNo.
  ///
  /// In en, this message translates to:
  /// **'No child seat'**
  String get childSeatNo;

  /// No description provided for @conversationFriendly.
  ///
  /// In en, this message translates to:
  /// **'Enjoys a chat'**
  String get conversationFriendly;

  /// No description provided for @conversationQuiet.
  ///
  /// In en, this message translates to:
  /// **'Prefers a quiet ride'**
  String get conversationQuiet;

  /// No description provided for @conversationNoPreference.
  ///
  /// In en, this message translates to:
  /// **'Either is fine'**
  String get conversationNoPreference;

  /// No description provided for @tripStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Published'**
  String get tripStatusActive;

  /// No description provided for @tripStatusFull.
  ///
  /// In en, this message translates to:
  /// **'Full'**
  String get tripStatusFull;

  /// No description provided for @tripStatusInProgress.
  ///
  /// In en, this message translates to:
  /// **'On the way'**
  String get tripStatusInProgress;

  /// No description provided for @tripStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get tripStatusCompleted;

  /// No description provided for @tripStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get tripStatusCancelled;

  /// No description provided for @tripStatusExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get tripStatusExpired;

  /// No description provided for @bookingStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Waiting for answer'**
  String get bookingStatusPending;

  /// No description provided for @bookingStatusApproved.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get bookingStatusApproved;

  /// No description provided for @bookingStatusRejected.
  ///
  /// In en, this message translates to:
  /// **'Declined'**
  String get bookingStatusRejected;

  /// No description provided for @bookingStatusCancelledByPassenger.
  ///
  /// In en, this message translates to:
  /// **'Cancelled by passenger'**
  String get bookingStatusCancelledByPassenger;

  /// No description provided for @bookingStatusCancelledByDriver.
  ///
  /// In en, this message translates to:
  /// **'Cancelled by driver'**
  String get bookingStatusCancelledByDriver;

  /// No description provided for @bookingStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get bookingStatusCompleted;

  /// No description provided for @bookingStatusExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get bookingStatusExpired;

  /// No description provided for @publishTitle.
  ///
  /// In en, this message translates to:
  /// **'Publish a trip'**
  String get publishTitle;

  /// No description provided for @publishStepRoute.
  ///
  /// In en, this message translates to:
  /// **'Route'**
  String get publishStepRoute;

  /// No description provided for @publishStepSchedule.
  ///
  /// In en, this message translates to:
  /// **'When'**
  String get publishStepSchedule;

  /// No description provided for @publishStepVehicle.
  ///
  /// In en, this message translates to:
  /// **'Car'**
  String get publishStepVehicle;

  /// No description provided for @publishStepComfort.
  ///
  /// In en, this message translates to:
  /// **'Comfort'**
  String get publishStepComfort;

  /// No description provided for @publishStepPrice.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get publishStepPrice;

  /// No description provided for @publishStepReview.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get publishStepReview;

  /// No description provided for @publishStepOf.
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}'**
  String publishStepOf(int current, int total);

  /// No description provided for @publishDeparture.
  ///
  /// In en, this message translates to:
  /// **'Departure'**
  String get publishDeparture;

  /// No description provided for @publishDestination.
  ///
  /// In en, this message translates to:
  /// **'Destination'**
  String get publishDestination;

  /// No description provided for @publishChooseCity.
  ///
  /// In en, this message translates to:
  /// **'Choose a city'**
  String get publishChooseCity;

  /// No description provided for @publishMeetingPoint.
  ///
  /// In en, this message translates to:
  /// **'Meeting point'**
  String get publishMeetingPoint;

  /// No description provided for @publishMeetingPointHint.
  ///
  /// In en, this message translates to:
  /// **'Exact place, for example the bazaar entrance'**
  String get publishMeetingPointHint;

  /// No description provided for @publishAddStop.
  ///
  /// In en, this message translates to:
  /// **'Add a stop on the way'**
  String get publishAddStop;

  /// No description provided for @publishStop.
  ///
  /// In en, this message translates to:
  /// **'Stop {index}'**
  String publishStop(int index);

  /// No description provided for @publishStopType.
  ///
  /// In en, this message translates to:
  /// **'Passengers can'**
  String get publishStopType;

  /// No description provided for @stopTypeBoth.
  ///
  /// In en, this message translates to:
  /// **'Board and leave'**
  String get stopTypeBoth;

  /// No description provided for @stopTypePickup.
  ///
  /// In en, this message translates to:
  /// **'Only board'**
  String get stopTypePickup;

  /// No description provided for @stopTypeDropoff.
  ///
  /// In en, this message translates to:
  /// **'Only leave'**
  String get stopTypeDropoff;

  /// No description provided for @publishStopTime.
  ///
  /// In en, this message translates to:
  /// **'Estimated time here'**
  String get publishStopTime;

  /// No description provided for @publishRemoveStop.
  ///
  /// In en, this message translates to:
  /// **'Remove stop'**
  String get publishRemoveStop;

  /// No description provided for @publishMoveUp.
  ///
  /// In en, this message translates to:
  /// **'Move up'**
  String get publishMoveUp;

  /// No description provided for @publishMoveDown.
  ///
  /// In en, this message translates to:
  /// **'Move down'**
  String get publishMoveDown;

  /// No description provided for @publishDate.
  ///
  /// In en, this message translates to:
  /// **'Departure date'**
  String get publishDate;

  /// No description provided for @publishTime.
  ///
  /// In en, this message translates to:
  /// **'Departure time'**
  String get publishTime;

  /// No description provided for @publishDuration.
  ///
  /// In en, this message translates to:
  /// **'Estimated trip duration'**
  String get publishDuration;

  /// No description provided for @publishArrivalPreview.
  ///
  /// In en, this message translates to:
  /// **'Estimated arrival: {time}'**
  String publishArrivalPreview(String time);

  /// No description provided for @publishChooseVehicle.
  ///
  /// In en, this message translates to:
  /// **'Which car are you driving?'**
  String get publishChooseVehicle;

  /// No description provided for @publishNoVehicles.
  ///
  /// In en, this message translates to:
  /// **'Add your car so passengers can recognise it.'**
  String get publishNoVehicles;

  /// No description provided for @publishSeats.
  ///
  /// In en, this message translates to:
  /// **'Seats for passengers'**
  String get publishSeats;

  /// No description provided for @publishSeatsHint.
  ///
  /// In en, this message translates to:
  /// **'Count only passenger seats, without the driver\'s seat.'**
  String get publishSeatsHint;

  /// No description provided for @publishPrice.
  ///
  /// In en, this message translates to:
  /// **'Price per seat, TMT'**
  String get publishPrice;

  /// No description provided for @publishPriceHint.
  ///
  /// In en, this message translates to:
  /// **'Leave empty to agree with passengers'**
  String get publishPriceHint;

  /// No description provided for @publishNegotiable.
  ///
  /// In en, this message translates to:
  /// **'The price is negotiable'**
  String get publishNegotiable;

  /// No description provided for @publishDescription.
  ///
  /// In en, this message translates to:
  /// **'Trip description'**
  String get publishDescription;

  /// No description provided for @publishDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'For example: one short stop on the way, two large suitcases fit in the trunk'**
  String get publishDescriptionHint;

  /// No description provided for @publishConditions.
  ///
  /// In en, this message translates to:
  /// **'Additional conditions'**
  String get publishConditions;

  /// No description provided for @publishConditionsHint.
  ///
  /// In en, this message translates to:
  /// **'For example: please be on time'**
  String get publishConditionsHint;

  /// No description provided for @publishSubmit.
  ///
  /// In en, this message translates to:
  /// **'Publish the trip'**
  String get publishSubmit;

  /// No description provided for @publishSuccess.
  ///
  /// In en, this message translates to:
  /// **'Your trip is published'**
  String get publishSuccess;

  /// No description provided for @publishComfortHint.
  ///
  /// In en, this message translates to:
  /// **'All options are optional. Passengers see only what you choose.'**
  String get publishComfortHint;

  /// No description provided for @vehiclesTitle.
  ///
  /// In en, this message translates to:
  /// **'My cars'**
  String get vehiclesTitle;

  /// No description provided for @vehicleAdd.
  ///
  /// In en, this message translates to:
  /// **'Add a car'**
  String get vehicleAdd;

  /// No description provided for @vehicleEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit car'**
  String get vehicleEdit;

  /// No description provided for @vehicleBrand.
  ///
  /// In en, this message translates to:
  /// **'Make'**
  String get vehicleBrand;

  /// No description provided for @vehicleBrandHint.
  ///
  /// In en, this message translates to:
  /// **'For example Toyota'**
  String get vehicleBrandHint;

  /// No description provided for @vehicleModel.
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get vehicleModel;

  /// No description provided for @vehicleModelHint.
  ///
  /// In en, this message translates to:
  /// **'For example Camry'**
  String get vehicleModelHint;

  /// No description provided for @vehicleColor.
  ///
  /// In en, this message translates to:
  /// **'Colour'**
  String get vehicleColor;

  /// No description provided for @vehiclePlate.
  ///
  /// In en, this message translates to:
  /// **'Plate number'**
  String get vehiclePlate;

  /// No description provided for @vehiclePlateNote.
  ///
  /// In en, this message translates to:
  /// **'Only passengers you accept see the plate number.'**
  String get vehiclePlateNote;

  /// No description provided for @vehicleYear.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get vehicleYear;

  /// No description provided for @vehicleType.
  ///
  /// In en, this message translates to:
  /// **'Body type'**
  String get vehicleType;

  /// No description provided for @vehicleSeats.
  ///
  /// In en, this message translates to:
  /// **'Passenger seats'**
  String get vehicleSeats;

  /// No description provided for @vehiclePhoto.
  ///
  /// In en, this message translates to:
  /// **'Car photo'**
  String get vehiclePhoto;

  /// No description provided for @vehicleEmpty.
  ///
  /// In en, this message translates to:
  /// **'You have not added a car yet'**
  String get vehicleEmpty;

  /// No description provided for @vehicleDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this car?'**
  String get vehicleDeleteConfirm;

  /// No description provided for @vehicleSaved.
  ///
  /// In en, this message translates to:
  /// **'Car saved'**
  String get vehicleSaved;

  /// No description provided for @vehicleTypeSedan.
  ///
  /// In en, this message translates to:
  /// **'Sedan'**
  String get vehicleTypeSedan;

  /// No description provided for @vehicleTypeHatchback.
  ///
  /// In en, this message translates to:
  /// **'Hatchback'**
  String get vehicleTypeHatchback;

  /// No description provided for @vehicleTypeWagon.
  ///
  /// In en, this message translates to:
  /// **'Estate'**
  String get vehicleTypeWagon;

  /// No description provided for @vehicleTypeSuv.
  ///
  /// In en, this message translates to:
  /// **'SUV'**
  String get vehicleTypeSuv;

  /// No description provided for @vehicleTypeMinivan.
  ///
  /// In en, this message translates to:
  /// **'Minivan'**
  String get vehicleTypeMinivan;

  /// No description provided for @vehicleTypeMinibus.
  ///
  /// In en, this message translates to:
  /// **'Minibus'**
  String get vehicleTypeMinibus;

  /// No description provided for @vehicleTypeOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get vehicleTypeOther;

  /// No description provided for @myTripsTitle.
  ///
  /// In en, this message translates to:
  /// **'My trips'**
  String get myTripsTitle;

  /// No description provided for @myTripsAsDriver.
  ///
  /// In en, this message translates to:
  /// **'As driver'**
  String get myTripsAsDriver;

  /// No description provided for @myTripsAsPassenger.
  ///
  /// In en, this message translates to:
  /// **'As passenger'**
  String get myTripsAsPassenger;

  /// No description provided for @myTripsHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get myTripsHistory;

  /// No description provided for @myTripsEmptyDriver.
  ///
  /// In en, this message translates to:
  /// **'You have no upcoming trips as a driver.'**
  String get myTripsEmptyDriver;

  /// No description provided for @myTripsEmptyPassenger.
  ///
  /// In en, this message translates to:
  /// **'You have no upcoming bookings.'**
  String get myTripsEmptyPassenger;

  /// No description provided for @myTripsEmptyHistory.
  ///
  /// In en, this message translates to:
  /// **'Your past trips will appear here.'**
  String get myTripsEmptyHistory;

  /// No description provided for @myTripsNewRequests.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 new request} other{{count} new requests}}'**
  String myTripsNewRequests(int count);

  /// No description provided for @myTripsSeatsBooked.
  ///
  /// In en, this message translates to:
  /// **'{booked} of {total} seats taken'**
  String myTripsSeatsBooked(int booked, int total);

  /// No description provided for @historyAsDriverTitle.
  ///
  /// In en, this message translates to:
  /// **'Trips I drove'**
  String get historyAsDriverTitle;

  /// No description provided for @historyAsPassengerTitle.
  ///
  /// In en, this message translates to:
  /// **'Trips I took'**
  String get historyAsPassengerTitle;

  /// No description provided for @manageTitle.
  ///
  /// In en, this message translates to:
  /// **'Trip and requests'**
  String get manageTitle;

  /// No description provided for @managePending.
  ///
  /// In en, this message translates to:
  /// **'New requests'**
  String get managePending;

  /// No description provided for @manageAccepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted passengers'**
  String get manageAccepted;

  /// No description provided for @manageOther.
  ///
  /// In en, this message translates to:
  /// **'Other requests'**
  String get manageOther;

  /// No description provided for @manageNoRequests.
  ///
  /// In en, this message translates to:
  /// **'No requests yet. We will notify you when a passenger asks for a seat.'**
  String get manageNoRequests;

  /// No description provided for @manageAccept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get manageAccept;

  /// No description provided for @manageReject.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get manageReject;

  /// No description provided for @manageRejectConfirm.
  ///
  /// In en, this message translates to:
  /// **'Decline this request?'**
  String get manageRejectConfirm;

  /// No description provided for @manageCancelBooking.
  ///
  /// In en, this message translates to:
  /// **'Cancel booking'**
  String get manageCancelBooking;

  /// No description provided for @manageCancelBookingConfirm.
  ///
  /// In en, this message translates to:
  /// **'Cancel this passenger\'s booking? The passenger will be notified.'**
  String get manageCancelBookingConfirm;

  /// No description provided for @manageCancelTrip.
  ///
  /// In en, this message translates to:
  /// **'Cancel trip'**
  String get manageCancelTrip;

  /// No description provided for @manageCancelTripConfirm.
  ///
  /// In en, this message translates to:
  /// **'Cancel the whole trip? All passengers and requests will be cancelled and notified.'**
  String get manageCancelTripConfirm;

  /// No description provided for @manageCompleteTrip.
  ///
  /// In en, this message translates to:
  /// **'Finish the trip'**
  String get manageCompleteTrip;

  /// No description provided for @manageCompleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Mark the trip as completed? Passengers will be able to rate it.'**
  String get manageCompleteConfirm;

  /// No description provided for @manageEditTrip.
  ///
  /// In en, this message translates to:
  /// **'Edit trip'**
  String get manageEditTrip;

  /// No description provided for @manageRequestedAt.
  ///
  /// In en, this message translates to:
  /// **'Requested {time}'**
  String manageRequestedAt(String time);

  /// No description provided for @manageAccepted1.
  ///
  /// In en, this message translates to:
  /// **'Request accepted'**
  String get manageAccepted1;

  /// No description provided for @manageRejected1.
  ///
  /// In en, this message translates to:
  /// **'Request declined'**
  String get manageRejected1;

  /// No description provided for @manageTripCancelled.
  ///
  /// In en, this message translates to:
  /// **'Trip cancelled'**
  String get manageTripCancelled;

  /// No description provided for @manageTripCompleted.
  ///
  /// In en, this message translates to:
  /// **'Trip completed'**
  String get manageTripCompleted;

  /// No description provided for @manageRatePassenger.
  ///
  /// In en, this message translates to:
  /// **'Rate passenger'**
  String get manageRatePassenger;

  /// No description provided for @editTripTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit trip'**
  String get editTripTitle;

  /// No description provided for @editTripScheduleLocked.
  ///
  /// In en, this message translates to:
  /// **'The date and time can be changed only while the trip has no requests.'**
  String get editTripScheduleLocked;

  /// No description provided for @editTripSaved.
  ///
  /// In en, this message translates to:
  /// **'Trip updated. Passengers have been notified.'**
  String get editTripSaved;

  /// No description provided for @editTripClearPrice.
  ///
  /// In en, this message translates to:
  /// **'Remove price'**
  String get editTripClearPrice;

  /// No description provided for @bookingTitle.
  ///
  /// In en, this message translates to:
  /// **'Booking'**
  String get bookingTitle;

  /// No description provided for @bookingContact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get bookingContact;

  /// No description provided for @bookingCallDriver.
  ///
  /// In en, this message translates to:
  /// **'Call the driver'**
  String get bookingCallDriver;

  /// No description provided for @bookingCallPassenger.
  ///
  /// In en, this message translates to:
  /// **'Call the passenger'**
  String get bookingCallPassenger;

  /// No description provided for @bookingContactHidden.
  ///
  /// In en, this message translates to:
  /// **'The phone number is shown after the driver accepts the request.'**
  String get bookingContactHidden;

  /// No description provided for @bookingCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel booking'**
  String get bookingCancel;

  /// No description provided for @bookingCancelConfirm.
  ///
  /// In en, this message translates to:
  /// **'Cancel your booking? The driver will be notified.'**
  String get bookingCancelConfirm;

  /// No description provided for @bookingCancelled.
  ///
  /// In en, this message translates to:
  /// **'Booking cancelled'**
  String get bookingCancelled;

  /// No description provided for @bookingRate.
  ///
  /// In en, this message translates to:
  /// **'Rate the trip'**
  String get bookingRate;

  /// No description provided for @bookingReviewed.
  ///
  /// In en, this message translates to:
  /// **'Thank you, you have rated this trip'**
  String get bookingReviewed;

  /// No description provided for @bookingYourSegment.
  ///
  /// In en, this message translates to:
  /// **'Your part of the route'**
  String get bookingYourSegment;

  /// No description provided for @bookingRequestedSeats.
  ///
  /// In en, this message translates to:
  /// **'Requested seats'**
  String get bookingRequestedSeats;

  /// No description provided for @bookingDialerError.
  ///
  /// In en, this message translates to:
  /// **'Could not open the phone app'**
  String get bookingDialerError;

  /// No description provided for @reviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Leave a review'**
  String get reviewTitle;

  /// No description provided for @reviewAboutDriver.
  ///
  /// In en, this message translates to:
  /// **'How was your trip with {name}?'**
  String reviewAboutDriver(String name);

  /// No description provided for @reviewAboutPassenger.
  ///
  /// In en, this message translates to:
  /// **'How was {name} as a passenger?'**
  String reviewAboutPassenger(String name);

  /// No description provided for @reviewCommentHint.
  ///
  /// In en, this message translates to:
  /// **'A few words about the trip (optional)'**
  String get reviewCommentHint;

  /// No description provided for @reviewSubmit.
  ///
  /// In en, this message translates to:
  /// **'Send review'**
  String get reviewSubmit;

  /// No description provided for @reviewThanks.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your review!'**
  String get reviewThanks;

  /// No description provided for @reviewChooseRating.
  ///
  /// In en, this message translates to:
  /// **'Choose from 1 to 5 stars'**
  String get reviewChooseRating;

  /// No description provided for @reviewsTitle.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviewsTitle;

  /// No description provided for @reviewsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No reviews yet'**
  String get reviewsEmpty;

  /// No description provided for @reviewByPassenger.
  ///
  /// In en, this message translates to:
  /// **'Passenger'**
  String get reviewByPassenger;

  /// No description provided for @reviewByDriver.
  ///
  /// In en, this message translates to:
  /// **'Driver'**
  String get reviewByDriver;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get profileEdit;

  /// No description provided for @profileChangePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change photo'**
  String get profileChangePhoto;

  /// No description provided for @profileRemovePhoto.
  ///
  /// In en, this message translates to:
  /// **'Remove photo'**
  String get profileRemovePhoto;

  /// No description provided for @profilePhone.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get profilePhone;

  /// No description provided for @profileChangePhone.
  ///
  /// In en, this message translates to:
  /// **'Change number'**
  String get profileChangePhone;

  /// No description provided for @profileVehicles.
  ///
  /// In en, this message translates to:
  /// **'My cars'**
  String get profileVehicles;

  /// No description provided for @profileReviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews about me'**
  String get profileReviews;

  /// No description provided for @profileSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get profileSettings;

  /// No description provided for @profileLogout.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get profileLogout;

  /// No description provided for @profileLogoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Sign out of your account?'**
  String get profileLogoutConfirm;

  /// No description provided for @profileMemberSince.
  ///
  /// In en, this message translates to:
  /// **'Member since {date}'**
  String profileMemberSince(String date);

  /// No description provided for @profileTripsAsDriver.
  ///
  /// In en, this message translates to:
  /// **'As driver'**
  String get profileTripsAsDriver;

  /// No description provided for @profileTripsAsPassenger.
  ///
  /// In en, this message translates to:
  /// **'As passenger'**
  String get profileTripsAsPassenger;

  /// No description provided for @profileRating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get profileRating;

  /// No description provided for @profileSaved.
  ///
  /// In en, this message translates to:
  /// **'Profile saved'**
  String get profileSaved;

  /// No description provided for @photoFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get photoFromGallery;

  /// No description provided for @photoFromCamera.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get photoFromCamera;

  /// No description provided for @changePhoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Change phone number'**
  String get changePhoneTitle;

  /// No description provided for @changePhoneSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We will send a code to the new number. Your account and trips stay the same.'**
  String get changePhoneSubtitle;

  /// No description provided for @changePhoneNew.
  ///
  /// In en, this message translates to:
  /// **'New mobile number'**
  String get changePhoneNew;

  /// No description provided for @changePhoneSuccess.
  ///
  /// In en, this message translates to:
  /// **'Phone number changed'**
  String get changePhoneSuccess;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'App language'**
  String get settingsLanguage;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About Ýolugra'**
  String get settingsAbout;

  /// No description provided for @settingsAboutText.
  ///
  /// In en, this message translates to:
  /// **'Ýolugra connects drivers and passengers travelling between the cities of Turkmenistan. Payments are arranged directly between travellers.'**
  String get settingsAboutText;

  /// No description provided for @languageTk.
  ///
  /// In en, this message translates to:
  /// **'Türkmençe'**
  String get languageTk;

  /// No description provided for @languageRu.
  ///
  /// In en, this message translates to:
  /// **'Русский'**
  String get languageRu;

  /// No description provided for @languageEn.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEn;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @notificationsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get notificationsEmpty;

  /// No description provided for @notificationsMarkAll.
  ///
  /// In en, this message translates to:
  /// **'Mark all as read'**
  String get notificationsMarkAll;

  /// No description provided for @noteBookingRequested.
  ///
  /// In en, this message translates to:
  /// **'{name} asks for seats on {route}'**
  String noteBookingRequested(String name, String route);

  /// No description provided for @noteBookingApproved.
  ///
  /// In en, this message translates to:
  /// **'Your request for {route} was accepted'**
  String noteBookingApproved(String route);

  /// No description provided for @noteBookingRejected.
  ///
  /// In en, this message translates to:
  /// **'Your request for {route} was declined'**
  String noteBookingRejected(String route);

  /// No description provided for @noteBookingCancelledByPassenger.
  ///
  /// In en, this message translates to:
  /// **'{name} cancelled the booking on {route}'**
  String noteBookingCancelledByPassenger(String name, String route);

  /// No description provided for @noteBookingCancelledByDriver.
  ///
  /// In en, this message translates to:
  /// **'The driver cancelled your booking on {route}'**
  String noteBookingCancelledByDriver(String route);

  /// No description provided for @noteBookingExpired.
  ///
  /// In en, this message translates to:
  /// **'Your request for {route} expired without an answer'**
  String noteBookingExpired(String route);

  /// No description provided for @noteTripCancelled.
  ///
  /// In en, this message translates to:
  /// **'The trip {route} was cancelled'**
  String noteTripCancelled(String route);

  /// No description provided for @noteTripUpdated.
  ///
  /// In en, this message translates to:
  /// **'The driver updated the trip {route}'**
  String noteTripUpdated(String route);

  /// No description provided for @noteTripReminder.
  ///
  /// In en, this message translates to:
  /// **'The trip {route} starts soon'**
  String noteTripReminder(String route);

  /// No description provided for @noteTripCompleted.
  ///
  /// In en, this message translates to:
  /// **'The trip {route} is completed. Rate your travel companions'**
  String noteTripCompleted(String route);

  /// No description provided for @noteReviewReceived.
  ///
  /// In en, this message translates to:
  /// **'{name} left you a review'**
  String noteReviewReceived(String name);

  /// No description provided for @noteSomeone.
  ///
  /// In en, this message translates to:
  /// **'A user'**
  String get noteSomeone;

  /// No description provided for @filterAny.
  ///
  /// In en, this message translates to:
  /// **'Any'**
  String get filterAny;

  /// No description provided for @serverTitle.
  ///
  /// In en, this message translates to:
  /// **'Server address'**
  String get serverTitle;

  /// No description provided for @serverHint.
  ///
  /// In en, this message translates to:
  /// **'For example 192.168.1.10:8081'**
  String get serverHint;

  /// No description provided for @serverNote.
  ///
  /// In en, this message translates to:
  /// **'Test builds only. Enter the computer’s address in the same Wi-Fi network.'**
  String get serverNote;

  /// No description provided for @serverCheck.
  ///
  /// In en, this message translates to:
  /// **'Check connection'**
  String get serverCheck;

  /// No description provided for @serverReachable.
  ///
  /// In en, this message translates to:
  /// **'The server answers'**
  String get serverReachable;

  /// No description provided for @serverUnreachable.
  ///
  /// In en, this message translates to:
  /// **'No answer from {url}. Check the address, the Wi-Fi network and the computer’s firewall.'**
  String serverUnreachable(String url);

  /// No description provided for @serverInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter an address like 192.168.1.10:8081'**
  String get serverInvalid;

  /// No description provided for @serverReset.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get serverReset;

  /// No description provided for @serverSaved.
  ///
  /// In en, this message translates to:
  /// **'Server address saved'**
  String get serverSaved;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru', 'tk'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
    case 'tk':
      return AppLocalizationsTk();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
