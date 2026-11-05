// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkmen (`tk`).
class AppLocalizationsTk extends AppLocalizations {
  AppLocalizationsTk([String locale = 'tk']) : super(locale);

  @override
  String get appName => 'Ýolugra';

  @override
  String get appTagline => 'Şäherleriň arasynda bile syýahat';

  @override
  String get navHome => 'Esasy';

  @override
  String get navSearch => 'Gözleg';

  @override
  String get navPublish => 'Döret';

  @override
  String get navMyTrips => 'Syýahatlar';

  @override
  String get navProfile => 'Profil';

  @override
  String get commonContinue => 'Dowam et';

  @override
  String get commonSave => 'Ýatda sakla';

  @override
  String get commonCancel => 'Ýatyr';

  @override
  String get commonRetry => 'Gaýtadan synanyş';

  @override
  String get commonClose => 'Ýap';

  @override
  String get commonDelete => 'Poz';

  @override
  String get commonEdit => 'Üýtget';

  @override
  String get commonConfirm => 'Tassykla';

  @override
  String get commonBack => 'Yza';

  @override
  String get commonNext => 'Indiki';

  @override
  String get commonDone => 'Taýýar';

  @override
  String get commonOptional => 'Hökman däl';

  @override
  String get commonNotSpecified => 'Görkezilmedi';

  @override
  String get commonCall => 'Jaň et';

  @override
  String get commonSeeAll => 'Hemmesi';

  @override
  String get commonKeep => 'Galdyr';

  @override
  String get commonLoadMore => 'Ýene görkez';

  @override
  String get authWelcomeTitle => 'Şäherleriň arasynda bile syýahat ediň';

  @override
  String get authWelcomeSubtitle =>
      'Ýoldaş tapyň ýa-da maşynyňyzdaky boş orunlary hödürläň. Mobil telefon belgiňiz bilen giriň.';

  @override
  String get authPhoneLabel => 'Mobil belgi';

  @override
  String get authPhoneHint => '6X XX XX XX';

  @override
  String get authSendCode => 'Kod al';

  @override
  String get authSmsNote =>
      'Size SMS arkaly bir gezeklik kod ibereris. Ony hiç kime aýtmaň.';

  @override
  String get authCodeTitle => 'Kody giriziň';

  @override
  String authCodeSentTo(String phone) {
    return '$phone belgä 6 sanly kod bilen SMS iberdik';
  }

  @override
  String get authCodeLabel => 'SMS-däki kod';

  @override
  String get authVerify => 'Tassykla';

  @override
  String authResendIn(int seconds) {
    return '$seconds sek. soň gaýtadan ibermek';
  }

  @override
  String get authResend => 'Kody gaýtadan iber';

  @override
  String get authChangeNumber => 'Belgini üýtget';

  @override
  String get authCodeResent => 'Täze kod iberildi';

  @override
  String get completeProfileTitle => 'Siz barada';

  @override
  String get completeProfileSubtitle =>
      'Sürüjiler we ýolagçylar adyňyzy görýär. Telefon belgiňiz bron tassyklanýança gizlin galýar.';

  @override
  String get completeProfileButton => 'Başla';

  @override
  String get firstNameLabel => 'Adyňyz';

  @override
  String get lastNameLabel => 'Familiýaňyz';

  @override
  String get bioLabel => 'Özüm barada';

  @override
  String get bioHint => 'Özüňiz barada birnäçe söz';

  @override
  String get validationRequired => 'Bu meýdany dolduryň';

  @override
  String get validationPhone =>
      'Türkmenistanyň mobil belgisini giriziň: 6 ýa-da 7 bilen başlaýan 8 san';

  @override
  String get validationCode => '6 sanly kody giriziň';

  @override
  String validationTooLong(int max) {
    return 'Gaty uzyn, iň köp $max harp';
  }

  @override
  String get validationPrice => '0-dan 100000-e çenli baha giriziň';

  @override
  String get validationYear => '1950 bilen 2100 aralygyndaky ýyly giriziň';

  @override
  String validationSeatsVehicle(int seats) {
    return 'Maşynyňyzda ýolagçylar üçin $seats orun bar';
  }

  @override
  String get validationSameStops =>
      'Her şäher ugurda diňe bir gezek bolup biler';

  @override
  String get validationRouteIncomplete => 'Ugraýan we barýan şäheriňizi saýlaň';

  @override
  String get validationDepartureFuture => 'Ugraýyş wagty geljekde bolmaly';

  @override
  String get validationDuration =>
      'Syýahat 15 minutdan 48 sagada çenli dowam etmeli';

  @override
  String get validationVehicle => 'Maşyny saýlaň';

  @override
  String get validationSegment => 'Münýän ýeriňiz düşýän ýeriňizden öň bolmaly';

  @override
  String get errorNetwork =>
      'Serwer bilen aragatnaşyk ýok. Interneti barlap, gaýtadan synanyşyň.';

  @override
  String get errorTimeout =>
      'Serwer köp wagtlap jogap bermeýär. Gaýtadan synanyşyň.';

  @override
  String get errorUnknown => 'Bir zat nädogry boldy. Gaýtadan synanyşyň.';

  @override
  String get errorValidation => 'Käbir maglumatlar nädogry. Formany barlaň.';

  @override
  String get errorNotFound => 'Tapylmady. Ol pozulan bolmagy mümkin.';

  @override
  String get errorForbidden => 'Bu hereket size rugsat berilmeýär.';

  @override
  String get errorUnauthorized => 'Sessiýa tamamlandy. Täzeden giriň.';

  @override
  String get errorUserBlocked => 'Bu hasaby ulanyp bolmaýar.';

  @override
  String get errorProfileIncomplete =>
      'Ilki profiliňize adyňyzy we familiýaňyzy goşuň.';

  @override
  String get errorTripOverlap =>
      'Bu wagtda sizde eýýäm syýahat bar. Syýahatlaryňyz biri-birine gabat gelmeli däl we olaryň arasynda gysga arakesme gerek.';

  @override
  String get errorInsufficientSeats =>
      'Ugruň bu böleginde indi ýeterlik boş orun ýok.';

  @override
  String get errorTripNotActive => 'Bu syýahat indi elýeterli däl.';

  @override
  String get errorTripStarted => 'Syýahat eýýäm başlandy.';

  @override
  String get errorTripNotStarted => 'Syýahat entek başlanmady.';

  @override
  String get errorBookingNotPending => 'Bu haýyşa eýýäm jogap berildi.';

  @override
  String get errorInvalidSegment =>
      'Münýän ýeriňizi düşýän ýeriňizden öň saýlaň.';

  @override
  String get errorBookingExists => 'Bu syýahat üçin sizde eýýäm haýyş bar.';

  @override
  String get errorOwnTrip => 'Öz syýahatyňyzda orun bronlap bilmeýärsiňiz.';

  @override
  String get errorInvalidTransition => 'Bu brony indi üýtgedip bolmaýar.';

  @override
  String get errorReviewNotAllowed =>
      'Diňe tamamlanan syýahatdan soň syn galdyryp bolýar.';

  @override
  String get errorReviewExists => 'Siz bu syýahata eýýäm baha berdiňiz.';

  @override
  String get errorSeatsBelowBooked =>
      'Orun sany tassyklanan orunlardan az bolup bilmez.';

  @override
  String get errorTripHasBookings =>
      'Syýahatda haýyşlar ýa-da ýolagçylar barka muny üýtgedip bolmaýar.';

  @override
  String get errorPhoneTaken => 'Bu belgi başga hasapda ulanylýar.';

  @override
  String get errorLocationInactive => 'Ýerleriň biri elýeterli däl.';

  @override
  String get errorContactUnavailable =>
      'Telefon belgisi diňe haýyş tassyklanandan soň görünýär.';

  @override
  String get errorUserUnavailable => 'Bu ulanyjy bilen syýahat edip bolmaýar.';

  @override
  String get errorFileTooLarge => 'Surat gaty uly. 5 MB-a çenli surat saýlaň.';

  @override
  String get errorUnsupportedMedia => 'JPEG, PNG ýa-da WebP suraty saýlaň.';

  @override
  String get errorRateLimited =>
      'Gaty köp synanyşyk. Biraz garaşyp, gaýtadan synanyşyň.';

  @override
  String get errorInvalidPhone => 'Türkmenistanyň mobil belgisini giriziň.';

  @override
  String get errorInvalidCode => 'Kod nädogry ýa-da möhleti geçdi.';

  @override
  String get errorServer =>
      'Serwer haýyşy ýerine ýetirip bilmedi. Soňrak synanyşyň.';

  @override
  String homeGreeting(String name) {
    return 'Salam, $name!';
  }

  @override
  String get homeTitle => 'Nirä barýarsyňyz?';

  @override
  String get homeFrom => 'Nireden';

  @override
  String get homeTo => 'Nirä';

  @override
  String get homeDate => 'Sene';

  @override
  String get homeAnyDate => 'Islendik gün';

  @override
  String get homePassengers => 'Ýolagçylar';

  @override
  String get homeSearch => 'Syýahat tap';

  @override
  String get homeUpcoming => 'Ýakyn syýahatlaryňyz';

  @override
  String get homeRecent => 'Täze goşulanlar';

  @override
  String get homeNoRecent =>
      'Häzirlikçe geljekki syýahat ýok. Birinji bolup goşuň!';

  @override
  String get homePublishTitle => 'Bir ýere barýarsyňyzmy?';

  @override
  String get homePublishSubtitle =>
      'Maşynyňyzdaky boş orunlary hödürläň we ýoly paýlaşyň.';

  @override
  String get homePublishButton => 'Syýahat goş';

  @override
  String get homeSwap => 'Şäherleri çalyş';

  @override
  String get dateToday => 'Şu gün';

  @override
  String get dateTomorrow => 'Ertir';

  @override
  String get locationPickerTitle => 'Ýeri saýlaň';

  @override
  String get locationSearchHint => 'Şäher ýa-da welaýat';

  @override
  String get locationEmpty => 'Hiç zat tapylmady';

  @override
  String get locationTypeWelayat => 'Welaýat';

  @override
  String get locationWholeWelayat => 'Tutuş welaýat';

  @override
  String get searchTitle => 'Syýahat tap';

  @override
  String get searchAnywhere => 'Islendik ýer';

  @override
  String get searchFilters => 'Süzgüçler';

  @override
  String get searchSort => 'Tertip';

  @override
  String get searchEmptyTitle => 'Syýahat tapylmady';

  @override
  String get searchEmptySubtitle =>
      'Başga senäni, azrak orny ýa-da golaýdaky şäheri synap görüň.';

  @override
  String get sortDeparture => 'Ilki ugraýanlar';

  @override
  String get sortPriceAsc => 'Ilki arzanlar';

  @override
  String get sortPriceDesc => 'Ilki gymmatlar';

  @override
  String get sortRating => 'Iň gowy bahaly sürüjiler';

  @override
  String get filterPriceMax => 'Bir orun üçin iň ýokary baha';

  @override
  String get filterDepartureTime => 'Ugraýyş wagty';

  @override
  String get filterTimeAny => 'Islendik wagt';

  @override
  String get filterTimeMorning => 'Irden (12:00-a çenli)';

  @override
  String get filterTimeAfternoon => 'Gündiz (12:00–18:00)';

  @override
  String get filterTimeEvening => 'Agşam (18:00-dan soň)';

  @override
  String get filterComfort => 'Amatlyk';

  @override
  String get filterLuggage => 'Ýük azyndan';

  @override
  String get filterMinRating => 'Sürüjiniň bahasy 4 ýyldyzdan';

  @override
  String get filterApply => 'Syýahatlary görkez';

  @override
  String get filterReset => 'Arassala';

  @override
  String seatsLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count boş orun',
      zero: 'Boş orun ýok',
    );
    return '$_temp0';
  }

  @override
  String seatsCount(int count) {
    return '$count orun';
  }

  @override
  String passengersCount(int count) {
    return '$count ýolagçy';
  }

  @override
  String priceAmount(String amount) {
    return '$amount manat';
  }

  @override
  String durationValue(int hours, int minutes) {
    return '$hours sag. $minutes min.';
  }

  @override
  String ratingValue(String rating, int count) {
    return '$rating · $count syn';
  }

  @override
  String completedTripsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count syýahat',
      zero: 'Entek syýahat ýok',
    );
    return '$_temp0';
  }

  @override
  String get newDriver => 'Ýolugra-da täze';

  @override
  String get tripTitle => 'Syýahat';

  @override
  String get tripRoute => 'Ugur';

  @override
  String get tripDriver => 'Sürüji';

  @override
  String get tripVehicle => 'Maşyn';

  @override
  String get tripComfort => 'Amatlyk';

  @override
  String get tripDescription => 'Sürüjiden';

  @override
  String get tripConditions => 'Şertler';

  @override
  String get tripPerSeat => 'bir orun';

  @override
  String get tripNegotiable => 'Bahasy ylalaşyk boýunça';

  @override
  String get tripPriceOnRequest => 'Sürüjiden soraň';

  @override
  String tripApproxArrival(String time) {
    return 'Barýan wagty ≈ $time';
  }

  @override
  String get tripEstimateNote => 'Barýan wagty sürüjiniň çaklamasy.';

  @override
  String get tripMeetingPoint => 'Duşuşyk ýeri';

  @override
  String get tripPlate => 'Belgisi';

  @override
  String get tripPlateHidden =>
      'Maşynyň belgisi sürüji haýyşyňyzy tassyklandan soň görünýär.';

  @override
  String get tripYourOwn => 'Bu siziň syýahatyňyz';

  @override
  String get tripManageRequests => 'Haýyşlary dolandyr';

  @override
  String get tripPaymentNote =>
      'Töleg göni sürüji bilen ylalaşylýar. Ýolugra töleg kabul etmeýär.';

  @override
  String get tripStopPickupOnly => 'Diňe münmek';

  @override
  String get tripStopDropoffOnly => 'Diňe düşmek';

  @override
  String get bookFormTitle => 'Orun sora';

  @override
  String get bookPickup => 'Münýän ýeri';

  @override
  String get bookDropoff => 'Düşýän ýeri';

  @override
  String get bookSeats => 'Orun';

  @override
  String get bookLuggage => 'Ýüküňiz';

  @override
  String get bookMessage => 'Sürüjä hat';

  @override
  String get bookMessageHint =>
      'Mysal üçin: awtomenziliň girelgesinde garaşaryn';

  @override
  String bookFreeOnSegment(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Bu bölekde $count boş orun bar',
      zero: 'Bu bölekde boş orun ýok',
    );
    return '$_temp0';
  }

  @override
  String bookTotal(String amount) {
    return 'Jemi: $amount';
  }

  @override
  String get bookSubmit => 'Haýyş iber';

  @override
  String get bookNote =>
      'Orun diňe sürüji haýyşy tassyklandan soň berilýär. Şondan soň onuň belgisi görüner.';

  @override
  String get bookSent =>
      'Haýyş iberildi. Sürüji jogap berende size habar bereris.';

  @override
  String get bookViewRequest => 'Meniň haýyşym';

  @override
  String get amenityAirConditioning => 'Kondisioner';

  @override
  String get amenityAudio => 'Aýdym-saz enjamy';

  @override
  String get amenityMusic => 'Aýdym-saz';

  @override
  String get amenitySmoking => 'Çilim';

  @override
  String get amenityPets => 'Öý haýwanlary';

  @override
  String get amenityLuggage => 'Ýük';

  @override
  String get amenityChildSeat => 'Çaga oturgyjy';

  @override
  String get amenityConversation => 'Gürrüňdeşlik';

  @override
  String get optionYes => 'Hawa';

  @override
  String get optionNo => 'Ýok';

  @override
  String get acYes => 'Kondisioner bar';

  @override
  String get acNo => 'Kondisioner ýok';

  @override
  String get audioYes => 'Aýdym-saz enjamy bar';

  @override
  String get audioNo => 'Aýdym-saz enjamy ýok';

  @override
  String get musicAllowed => 'Aýdym-saz bolup biler';

  @override
  String get musicNone => 'Aýdym-sazsyz gowy';

  @override
  String get musicDriverDecides => 'Aýdym-sazy sürüji saýlaýar';

  @override
  String get smokingAllowed => 'Çilim çekip bolýar';

  @override
  String get smokingProhibited => 'Çilim çekilmeýär';

  @override
  String get petsAllowed => 'Öý haýwany bilen bolýar';

  @override
  String get petsNotAllowed => 'Öý haýwansyz';

  @override
  String get luggageNone => 'Goşmaça ýük ýok';

  @override
  String get luggageSmall => 'Kiçi sumkalar';

  @override
  String get luggageMedium => 'Orta çemodanlar';

  @override
  String get luggageLarge => 'Uly çemodanlar';

  @override
  String get childSeatYes => 'Çaga oturgyjy bar';

  @override
  String get childSeatNo => 'Çaga oturgyjy ýok';

  @override
  String get conversationFriendly => 'Gürrüň etmegi halaýar';

  @override
  String get conversationQuiet => 'Ümsüm ýoly halaýar';

  @override
  String get conversationNoPreference => 'Tapawudy ýok';

  @override
  String get tripStatusActive => 'Goşuldy';

  @override
  String get tripStatusFull => 'Orun ýok';

  @override
  String get tripStatusInProgress => 'Ýolda';

  @override
  String get tripStatusCompleted => 'Tamamlandy';

  @override
  String get tripStatusCancelled => 'Ýatyryldy';

  @override
  String get tripStatusExpired => 'Möhleti geçdi';

  @override
  String get bookingStatusPending => 'Jogap garaşylýar';

  @override
  String get bookingStatusApproved => 'Tassyklandy';

  @override
  String get bookingStatusRejected => 'Ret edildi';

  @override
  String get bookingStatusCancelledByPassenger => 'Ýolagçy ýatyrdy';

  @override
  String get bookingStatusCancelledByDriver => 'Sürüji ýatyrdy';

  @override
  String get bookingStatusCompleted => 'Tamamlandy';

  @override
  String get bookingStatusExpired => 'Möhleti geçdi';

  @override
  String get publishTitle => 'Täze syýahat';

  @override
  String get publishStepRoute => 'Ugur';

  @override
  String get publishStepSchedule => 'Haçan';

  @override
  String get publishStepVehicle => 'Maşyn';

  @override
  String get publishStepComfort => 'Amatlyk';

  @override
  String get publishStepPrice => 'Baha';

  @override
  String get publishStepReview => 'Barlag';

  @override
  String publishStepOf(int current, int total) {
    return '$total ädimden $current-nji';
  }

  @override
  String get publishDeparture => 'Ugraýan ýeri';

  @override
  String get publishDestination => 'Barýan ýeri';

  @override
  String get publishChooseCity => 'Şäheri saýlaň';

  @override
  String get publishMeetingPoint => 'Duşuşyk ýeri';

  @override
  String get publishMeetingPointHint =>
      'Takyk ýer, mysal üçin bazaryň girelgesi';

  @override
  String get publishAddStop => 'Ýoluň ugrunda duralga goş';

  @override
  String publishStop(int index) {
    return '$index-nji duralga';
  }

  @override
  String get publishStopType => 'Ýolagçylar';

  @override
  String get stopTypeBoth => 'Münüp we düşüp bilýär';

  @override
  String get stopTypePickup => 'Diňe münüp bilýär';

  @override
  String get stopTypeDropoff => 'Diňe düşüp bilýär';

  @override
  String get publishStopTime => 'Bu ýerdäki takmynan wagt';

  @override
  String get publishRemoveStop => 'Duralgany aýyr';

  @override
  String get publishMoveUp => 'Ýokary';

  @override
  String get publishMoveDown => 'Aşak';

  @override
  String get publishDate => 'Ugraýan senesi';

  @override
  String get publishTime => 'Ugraýan wagty';

  @override
  String get publishDuration => 'Syýahatyň takmynan dowamlylygy';

  @override
  String publishArrivalPreview(String time) {
    return 'Takmynan barýan wagty: $time';
  }

  @override
  String get publishChooseVehicle => 'Haýsy maşynda barýarsyňyz?';

  @override
  String get publishNoVehicles => 'Ýolagçylar tanar ýaly maşynyňyzy goşuň.';

  @override
  String get publishSeats => 'Ýolagçylar üçin orun';

  @override
  String get publishSeatsHint =>
      'Diňe ýolagçy orunlaryny sanaň, sürüjiniň ornuny goşmaň.';

  @override
  String get publishPrice => 'Bir orun üçin baha, manat';

  @override
  String get publishPriceHint => 'Ýolagçylar bilen ylalaşmak üçin boş goýuň';

  @override
  String get publishNegotiable => 'Bahasy ylalaşyk boýunça';

  @override
  String get publishDescription => 'Syýahatyň beýany';

  @override
  String get publishDescriptionHint =>
      'Mysal üçin: ýolda bir gysga duralga, ýük bölüminde iki uly çemodan ýerleşýär';

  @override
  String get publishConditions => 'Goşmaça şertler';

  @override
  String get publishConditionsHint => 'Mysal üçin: wagtynda geliň';

  @override
  String get publishSubmit => 'Syýahaty goş';

  @override
  String get publishSuccess => 'Syýahatyňyz goşuldy';

  @override
  String get publishComfortHint =>
      'Hemmesi hökman däl. Ýolagçylar diňe siziň saýlanyňyzy görer.';

  @override
  String get vehiclesTitle => 'Maşynlarym';

  @override
  String get vehicleAdd => 'Maşyn goş';

  @override
  String get vehicleEdit => 'Maşyny üýtget';

  @override
  String get vehicleBrand => 'Markasy';

  @override
  String get vehicleBrandHint => 'Mysal üçin Toyota';

  @override
  String get vehicleModel => 'Modeli';

  @override
  String get vehicleModelHint => 'Mysal üçin Camry';

  @override
  String get vehicleColor => 'Reňki';

  @override
  String get vehiclePlate => 'Belgisi';

  @override
  String get vehiclePlateNote =>
      'Maşynyň belgisini diňe tassyklanan ýolagçylar görýär.';

  @override
  String get vehicleYear => 'Öndürilen ýyly';

  @override
  String get vehicleType => 'Görnüşi';

  @override
  String get vehicleSeats => 'Ýolagçy orunlary';

  @override
  String get vehiclePhoto => 'Maşynyň suraty';

  @override
  String get vehicleEmpty => 'Siz entek maşyn goşmadyňyz';

  @override
  String get vehicleDeleteConfirm => 'Bu maşyny pozmalymy?';

  @override
  String get vehicleSaved => 'Maşyn ýatda saklandy';

  @override
  String get vehicleTypeSedan => 'Sedan';

  @override
  String get vehicleTypeHatchback => 'Hetçbek';

  @override
  String get vehicleTypeWagon => 'Uniwersal';

  @override
  String get vehicleTypeSuv => 'Ýolsuzlyk maşyny';

  @override
  String get vehicleTypeMinivan => 'Miniwen';

  @override
  String get vehicleTypeMinibus => 'Mikroawtobus';

  @override
  String get vehicleTypeOther => 'Başga';

  @override
  String get myTripsTitle => 'Syýahatlarym';

  @override
  String get myTripsAsDriver => 'Sürüji';

  @override
  String get myTripsAsPassenger => 'Ýolagçy';

  @override
  String get myTripsHistory => 'Taryh';

  @override
  String get myTripsEmptyDriver => 'Sürüji hökmünde ýakyn syýahatyňyz ýok.';

  @override
  String get myTripsEmptyPassenger => 'Ýakyn bronuňyz ýok.';

  @override
  String get myTripsEmptyHistory => 'Geçen syýahatlaryňyz şu ýerde görüner.';

  @override
  String myTripsNewRequests(int count) {
    return '$count täze haýyş';
  }

  @override
  String myTripsSeatsBooked(int booked, int total) {
    return '$total orundan $booked eýelendi';
  }

  @override
  String get historyAsDriverTitle => 'Sürüji bolan syýahatlarym';

  @override
  String get historyAsPassengerTitle => 'Ýolagçy bolan syýahatlarym';

  @override
  String get manageTitle => 'Syýahat we haýyşlar';

  @override
  String get managePending => 'Täze haýyşlar';

  @override
  String get manageAccepted => 'Tassyklanan ýolagçylar';

  @override
  String get manageOther => 'Beýleki haýyşlar';

  @override
  String get manageNoRequests =>
      'Häzirlikçe haýyş ýok. Ýolagçy orun soranda size habar bereris.';

  @override
  String get manageAccept => 'Kabul et';

  @override
  String get manageReject => 'Ret et';

  @override
  String get manageRejectConfirm => 'Bu haýyşy ret etmelimi?';

  @override
  String get manageCancelBooking => 'Brony ýatyr';

  @override
  String get manageCancelBookingConfirm =>
      'Ýolagçynyň bronuny ýatyrmalymy? Oňa habar iberiler.';

  @override
  String get manageCancelTrip => 'Syýahaty ýatyr';

  @override
  String get manageCancelTripConfirm =>
      'Tutuş syýahaty ýatyrmalymy? Ähli ýolagçylar we haýyşlar ýatyrylar we olara habar berler.';

  @override
  String get manageCompleteTrip => 'Syýahaty tamamla';

  @override
  String get manageCompleteConfirm =>
      'Syýahaty tamamlanan diýip bellemelimi? Ýolagçylar baha berip bilerler.';

  @override
  String get manageEditTrip => 'Syýahaty üýtget';

  @override
  String manageRequestedAt(String time) {
    return 'Haýyş: $time';
  }

  @override
  String get manageAccepted1 => 'Haýyş kabul edildi';

  @override
  String get manageRejected1 => 'Haýyş ret edildi';

  @override
  String get manageTripCancelled => 'Syýahat ýatyryldy';

  @override
  String get manageTripCompleted => 'Syýahat tamamlandy';

  @override
  String get manageRatePassenger => 'Ýolagça baha ber';

  @override
  String get editTripTitle => 'Syýahaty üýtget';

  @override
  String get editTripScheduleLocked =>
      'Senäni we wagty diňe syýahatda haýyş ýok wagty üýtgedip bolýar.';

  @override
  String get editTripSaved => 'Syýahat täzelendi. Ýolagçylara habar berildi.';

  @override
  String get editTripClearPrice => 'Bahany aýyr';

  @override
  String get bookingTitle => 'Bron';

  @override
  String get bookingContact => 'Aragatnaşyk';

  @override
  String get bookingCallDriver => 'Sürüjä jaň et';

  @override
  String get bookingCallPassenger => 'Ýolagça jaň et';

  @override
  String get bookingContactHidden =>
      'Telefon belgisi sürüji haýyşy tassyklandan soň görüner.';

  @override
  String get bookingCancel => 'Brony ýatyr';

  @override
  String get bookingCancelConfirm =>
      'Bronuňyzy ýatyrmalymy? Sürüjä habar iberiler.';

  @override
  String get bookingCancelled => 'Bron ýatyryldy';

  @override
  String get bookingRate => 'Syýahata baha ber';

  @override
  String get bookingReviewed => 'Sag boluň, siz bu syýahata baha berdiňiz';

  @override
  String get bookingYourSegment => 'Ugruň siziň bölegiňiz';

  @override
  String get bookingRequestedSeats => 'Soralan orun';

  @override
  String get bookingDialerError => 'Telefon programmasyny açyp bolmady';

  @override
  String get reviewTitle => 'Syn galdyr';

  @override
  String reviewAboutDriver(String name) {
    return '$name bilen syýahatyňyz nähili geçdi?';
  }

  @override
  String reviewAboutPassenger(String name) {
    return '$name nähili ýolagçy boldy?';
  }

  @override
  String get reviewCommentHint => 'Syýahat barada birnäçe söz (hökman däl)';

  @override
  String get reviewSubmit => 'Syny iber';

  @override
  String get reviewThanks => 'Synyňyz üçin sag boluň!';

  @override
  String get reviewChooseRating => '1-den 5-e çenli ýyldyz saýlaň';

  @override
  String get reviewsTitle => 'Synlar';

  @override
  String get reviewsEmpty => 'Häzirlikçe syn ýok';

  @override
  String get reviewByPassenger => 'Ýolagçy';

  @override
  String get reviewByDriver => 'Sürüji';

  @override
  String get profileTitle => 'Profil';

  @override
  String get profileEdit => 'Profili üýtget';

  @override
  String get profileChangePhoto => 'Suraty çalyş';

  @override
  String get profileRemovePhoto => 'Suraty aýyr';

  @override
  String get profilePhone => 'Telefon belgisi';

  @override
  String get profileChangePhone => 'Belgini çalyş';

  @override
  String get profileVehicles => 'Maşynlarym';

  @override
  String get profileReviews => 'Men barada synlar';

  @override
  String get profileSettings => 'Sazlamalar';

  @override
  String get profileLogout => 'Çykmak';

  @override
  String get profileLogoutConfirm => 'Hasabyňyzdan çykmalymy?';

  @override
  String profileMemberSince(String date) {
    return 'Agza bolan wagty: $date';
  }

  @override
  String get profileTripsAsDriver => 'Sürüji';

  @override
  String get profileTripsAsPassenger => 'Ýolagçy';

  @override
  String get profileRating => 'Baha';

  @override
  String get profileSaved => 'Profil ýatda saklandy';

  @override
  String get photoFromGallery => 'Galereýadan saýla';

  @override
  String get photoFromCamera => 'Surata düş';

  @override
  String get changePhoneTitle => 'Telefon belgisini çalyşmak';

  @override
  String get changePhoneSubtitle =>
      'Täze belgä kod ibereris. Hasabyňyz we syýahatlaryňyz şol bolşy ýaly galar.';

  @override
  String get changePhoneNew => 'Täze mobil belgi';

  @override
  String get changePhoneSuccess => 'Telefon belgisi çalşyldy';

  @override
  String get settingsTitle => 'Sazlamalar';

  @override
  String get settingsLanguage => 'Programmanyň dili';

  @override
  String get settingsAbout => 'Ýolugra barada';

  @override
  String get settingsAboutText =>
      'Ýolugra Türkmenistanyň şäherleriniň arasynda syýahat edýän sürüjileri we ýolagçylary birleşdirýär. Töleg göni ýoldaşlaryň arasynda ylalaşylýar.';

  @override
  String get languageTk => 'Türkmençe';

  @override
  String get languageRu => 'Русский';

  @override
  String get languageEn => 'English';

  @override
  String get notificationsTitle => 'Habarlar';

  @override
  String get notificationsEmpty => 'Häzirlikçe habar ýok';

  @override
  String get notificationsMarkAll => 'Hemmesini okalan et';

  @override
  String noteBookingRequested(String name, String route) {
    return '$name $route syýahatynda orun soraýar';
  }

  @override
  String noteBookingApproved(String route) {
    return '$route syýahaty üçin haýyşyňyz tassyklandy';
  }

  @override
  String noteBookingRejected(String route) {
    return '$route syýahaty üçin haýyşyňyz ret edildi';
  }

  @override
  String noteBookingCancelledByPassenger(String name, String route) {
    return '$name $route syýahatyndaky bronuny ýatyrdy';
  }

  @override
  String noteBookingCancelledByDriver(String route) {
    return 'Sürüji $route syýahatyndaky bronuňyzy ýatyrdy';
  }

  @override
  String noteBookingExpired(String route) {
    return '$route syýahaty üçin haýyşyňyzyň jogapsyz möhleti geçdi';
  }

  @override
  String noteTripCancelled(String route) {
    return '$route syýahaty ýatyryldy';
  }

  @override
  String noteTripUpdated(String route) {
    return 'Sürüji $route syýahatyny üýtgetdi';
  }

  @override
  String noteTripReminder(String route) {
    return '$route syýahaty ýakynda başlaýar';
  }

  @override
  String noteTripCompleted(String route) {
    return '$route syýahaty tamamlandy. Ýol ýoldaşlaryňyza baha beriň';
  }

  @override
  String noteReviewReceived(String name) {
    return '$name size syn galdyrdy';
  }

  @override
  String get noteSomeone => 'Ulanyjy';

  @override
  String get filterAny => 'Islendik';

  @override
  String get serverTitle => 'Serweriň salgysy';

  @override
  String get serverHint => 'Mysal üçin 192.168.1.10:8081';

  @override
  String get serverNote =>
      'Diňe synag gurnamalarynda. Şol bir Wi-Fi ulgamyndaky kompýuteriň salgysyny giriziň.';

  @override
  String get serverCheck => 'Baglanyşygy barla';

  @override
  String get serverReachable => 'Serwer jogap berýär';

  @override
  String serverUnreachable(String url) {
    return '$url jogap bermeýär. Salgyny, Wi-Fi ulgamyny we kompýuteriň goragyny (firewall) barlaň.';
  }

  @override
  String get serverInvalid => '192.168.1.10:8081 görnüşinde salgy giriziň';

  @override
  String get serverReset => 'Başlangyç';

  @override
  String get serverSaved => 'Serweriň salgysy ýatda saklandy';
}
