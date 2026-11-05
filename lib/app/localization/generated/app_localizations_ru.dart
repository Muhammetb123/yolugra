// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appName => 'Ýolugra';

  @override
  String get appTagline => 'Попутчики между городами';

  @override
  String get navHome => 'Главная';

  @override
  String get navSearch => 'Поиск';

  @override
  String get navPublish => 'Создать';

  @override
  String get navMyTrips => 'Поездки';

  @override
  String get navProfile => 'Профиль';

  @override
  String get commonContinue => 'Продолжить';

  @override
  String get commonSave => 'Сохранить';

  @override
  String get commonCancel => 'Отмена';

  @override
  String get commonRetry => 'Повторить';

  @override
  String get commonClose => 'Закрыть';

  @override
  String get commonDelete => 'Удалить';

  @override
  String get commonEdit => 'Изменить';

  @override
  String get commonConfirm => 'Подтвердить';

  @override
  String get commonBack => 'Назад';

  @override
  String get commonNext => 'Далее';

  @override
  String get commonDone => 'Готово';

  @override
  String get commonOptional => 'Необязательно';

  @override
  String get commonNotSpecified => 'Не указано';

  @override
  String get commonCall => 'Позвонить';

  @override
  String get commonSeeAll => 'Все';

  @override
  String get commonKeep => 'Оставить';

  @override
  String get commonLoadMore => 'Показать ещё';

  @override
  String get authWelcomeTitle => 'Путешествуйте вместе между городами';

  @override
  String get authWelcomeSubtitle =>
      'Найдите попутку или предложите свободные места в своей машине. Вход по номеру мобильного телефона.';

  @override
  String get authPhoneLabel => 'Номер мобильного';

  @override
  String get authPhoneHint => '6X XX XX XX';

  @override
  String get authSendCode => 'Получить код';

  @override
  String get authSmsNote =>
      'Мы отправим одноразовый код по SMS. Никому его не сообщайте.';

  @override
  String get authCodeTitle => 'Введите код';

  @override
  String authCodeSentTo(String phone) {
    return 'Мы отправили SMS с 6-значным кодом на номер $phone';
  }

  @override
  String get authCodeLabel => 'Код из SMS';

  @override
  String get authVerify => 'Подтвердить';

  @override
  String authResendIn(int seconds) {
    return 'Отправить снова через $seconds с';
  }

  @override
  String get authResend => 'Отправить код ещё раз';

  @override
  String get authChangeNumber => 'Изменить номер';

  @override
  String get authCodeResent => 'Новый код уже в пути';

  @override
  String get completeProfileTitle => 'О вас';

  @override
  String get completeProfileSubtitle =>
      'Водители и пассажиры видят ваше имя. Номер телефона скрыт, пока бронирование не подтверждено.';

  @override
  String get completeProfileButton => 'Начать';

  @override
  String get firstNameLabel => 'Имя';

  @override
  String get lastNameLabel => 'Фамилия';

  @override
  String get bioLabel => 'О себе';

  @override
  String get bioHint => 'Несколько слов о себе';

  @override
  String get validationRequired => 'Обязательное поле';

  @override
  String get validationPhone =>
      'Введите мобильный номер Туркменистана: 8 цифр, начиная с 6 или 7';

  @override
  String get validationCode => 'Введите 6-значный код';

  @override
  String validationTooLong(int max) {
    return 'Слишком длинно, не больше $max символов';
  }

  @override
  String get validationPrice => 'Введите цену от 0 до 100000';

  @override
  String get validationYear => 'Введите год от 1950 до 2100';

  @override
  String validationSeatsVehicle(int seats) {
    return 'В вашей машине $seats пассажирских мест';
  }

  @override
  String get validationSameStops =>
      'Каждый город может быть в маршруте только один раз';

  @override
  String get validationRouteIncomplete =>
      'Выберите города отправления и назначения';

  @override
  String get validationDepartureFuture =>
      'Время отправления должно быть в будущем';

  @override
  String get validationDuration =>
      'Поездка должна длиться от 15 минут до 48 часов';

  @override
  String get validationVehicle => 'Выберите машину';

  @override
  String get validationSegment =>
      'Точка посадки должна быть раньше точки высадки';

  @override
  String get errorNetwork =>
      'Нет связи с сервером. Проверьте интернет и попробуйте снова.';

  @override
  String get errorTimeout => 'Сервер долго не отвечает. Попробуйте снова.';

  @override
  String get errorUnknown => 'Что-то пошло не так. Попробуйте снова.';

  @override
  String get errorValidation =>
      'Некоторые данные некорректны. Проверьте форму.';

  @override
  String get errorNotFound => 'Не найдено. Возможно, запись удалена.';

  @override
  String get errorForbidden => 'Это действие вам недоступно.';

  @override
  String get errorUnauthorized => 'Сеанс завершён. Войдите снова.';

  @override
  String get errorUserBlocked => 'Этот аккаунт нельзя использовать.';

  @override
  String get errorProfileIncomplete =>
      'Сначала укажите имя и фамилию в профиле.';

  @override
  String get errorTripOverlap =>
      'У вас уже есть поездка в это время. Поездки не должны пересекаться, между ними нужен небольшой перерыв.';

  @override
  String get errorInsufficientSeats =>
      'На этом участке маршрута уже недостаточно свободных мест.';

  @override
  String get errorTripNotActive => 'Эта поездка больше недоступна.';

  @override
  String get errorTripStarted => 'Поездка уже началась.';

  @override
  String get errorTripNotStarted => 'Поездка ещё не началась.';

  @override
  String get errorBookingNotPending => 'На эту заявку уже ответили.';

  @override
  String get errorInvalidSegment =>
      'Выберите точку посадки раньше точки высадки.';

  @override
  String get errorBookingExists => 'У вас уже есть заявка на эту поездку.';

  @override
  String get errorOwnTrip => 'Нельзя бронировать собственную поездку.';

  @override
  String get errorInvalidTransition => 'Это бронирование уже нельзя изменить.';

  @override
  String get errorReviewNotAllowed =>
      'Отзыв можно оставить только после завершённой поездки.';

  @override
  String get errorReviewExists => 'Вы уже оставили отзыв об этой поездке.';

  @override
  String get errorSeatsBelowBooked =>
      'Мест не может быть меньше уже подтверждённых.';

  @override
  String get errorTripHasBookings =>
      'Это нельзя изменить, пока у поездки есть заявки или пассажиры.';

  @override
  String get errorPhoneTaken => 'Этот номер уже используется другим аккаунтом.';

  @override
  String get errorLocationInactive => 'Одно из мест недоступно.';

  @override
  String get errorContactUnavailable =>
      'Номер телефона показывается только после подтверждения заявки.';

  @override
  String get errorUserUnavailable => 'Поездка с этим пользователем недоступна.';

  @override
  String get errorFileTooLarge =>
      'Фото слишком большое. Выберите файл до 5 МБ.';

  @override
  String get errorUnsupportedMedia =>
      'Выберите фото в формате JPEG, PNG или WebP.';

  @override
  String get errorRateLimited =>
      'Слишком много попыток. Подождите немного и попробуйте снова.';

  @override
  String get errorInvalidPhone => 'Введите мобильный номер Туркменистана.';

  @override
  String get errorInvalidCode => 'Код неверный или устарел.';

  @override
  String get errorServer =>
      'Сервер не смог обработать запрос. Попробуйте позже.';

  @override
  String homeGreeting(String name) {
    return 'Здравствуйте, $name!';
  }

  @override
  String get homeTitle => 'Куда едем?';

  @override
  String get homeFrom => 'Откуда';

  @override
  String get homeTo => 'Куда';

  @override
  String get homeDate => 'Дата';

  @override
  String get homeAnyDate => 'Любой день';

  @override
  String get homePassengers => 'Пассажиры';

  @override
  String get homeSearch => 'Найти поездку';

  @override
  String get homeUpcoming => 'Ваши ближайшие поездки';

  @override
  String get homeRecent => 'Недавно опубликованные';

  @override
  String get homeNoRecent =>
      'Пока нет предстоящих поездок. Опубликуйте первую!';

  @override
  String get homePublishTitle => 'Едете куда-то?';

  @override
  String get homePublishSubtitle =>
      'Предложите свободные места в машине и разделите дорогу.';

  @override
  String get homePublishButton => 'Опубликовать поездку';

  @override
  String get homeSwap => 'Поменять города';

  @override
  String get dateToday => 'Сегодня';

  @override
  String get dateTomorrow => 'Завтра';

  @override
  String get locationPickerTitle => 'Выберите место';

  @override
  String get locationSearchHint => 'Город или велаят';

  @override
  String get locationEmpty => 'Ничего не найдено';

  @override
  String get locationTypeWelayat => 'Велаят';

  @override
  String get locationWholeWelayat => 'Весь велаят';

  @override
  String get searchTitle => 'Найти поездку';

  @override
  String get searchAnywhere => 'Любое место';

  @override
  String get searchFilters => 'Фильтры';

  @override
  String get searchSort => 'Сортировка';

  @override
  String get searchEmptyTitle => 'Поездок не найдено';

  @override
  String get searchEmptySubtitle =>
      'Попробуйте другую дату, меньше мест или соседний город.';

  @override
  String get sortDeparture => 'Раньше отправление';

  @override
  String get sortPriceAsc => 'Сначала дешевле';

  @override
  String get sortPriceDesc => 'Сначала дороже';

  @override
  String get sortRating => 'Лучший рейтинг водителя';

  @override
  String get filterPriceMax => 'Максимальная цена за место';

  @override
  String get filterDepartureTime => 'Время отправления';

  @override
  String get filterTimeAny => 'Любое время';

  @override
  String get filterTimeMorning => 'Утро (до 12:00)';

  @override
  String get filterTimeAfternoon => 'День (12:00–18:00)';

  @override
  String get filterTimeEvening => 'Вечер (после 18:00)';

  @override
  String get filterComfort => 'Комфорт';

  @override
  String get filterLuggage => 'Багаж не меньше';

  @override
  String get filterMinRating => 'Рейтинг водителя от 4 звёзд';

  @override
  String get filterApply => 'Показать поездки';

  @override
  String get filterReset => 'Сбросить';

  @override
  String seatsLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Осталось $count места',
      many: 'Осталось $count мест',
      few: 'Осталось $count места',
      one: 'Осталось $count место',
      zero: 'Нет свободных мест',
    );
    return '$_temp0';
  }

  @override
  String seatsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count места',
      many: '$count мест',
      few: '$count места',
      one: '$count место',
    );
    return '$_temp0';
  }

  @override
  String passengersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count пассажира',
      many: '$count пассажиров',
      few: '$count пассажира',
      one: '$count пассажир',
    );
    return '$_temp0';
  }

  @override
  String priceAmount(String amount) {
    return '$amount ман.';
  }

  @override
  String durationValue(int hours, int minutes) {
    return '$hours ч $minutes мин';
  }

  @override
  String ratingValue(String rating, int count) {
    return '$rating · отзывов: $count';
  }

  @override
  String completedTripsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count поездки',
      many: '$count поездок',
      few: '$count поездки',
      one: '$count поездка',
      zero: 'Поездок пока нет',
    );
    return '$_temp0';
  }

  @override
  String get newDriver => 'Новичок в Ýolugra';

  @override
  String get tripTitle => 'Поездка';

  @override
  String get tripRoute => 'Маршрут';

  @override
  String get tripDriver => 'Водитель';

  @override
  String get tripVehicle => 'Машина';

  @override
  String get tripComfort => 'Комфорт';

  @override
  String get tripDescription => 'От водителя';

  @override
  String get tripConditions => 'Условия';

  @override
  String get tripPerSeat => 'за место';

  @override
  String get tripNegotiable => 'Цена договорная';

  @override
  String get tripPriceOnRequest => 'Уточните у водителя';

  @override
  String tripApproxArrival(String time) {
    return 'Прибытие ≈ $time';
  }

  @override
  String get tripEstimateNote => 'Время прибытия — оценка водителя.';

  @override
  String get tripMeetingPoint => 'Место встречи';

  @override
  String get tripPlate => 'Госномер';

  @override
  String get tripPlateHidden =>
      'Госномер показывается после того, как водитель подтвердит заявку.';

  @override
  String get tripYourOwn => 'Это ваша поездка';

  @override
  String get tripManageRequests => 'Управлять заявками';

  @override
  String get tripPaymentNote =>
      'Оплата — напрямую водителю. Ýolugra не проводит платежи.';

  @override
  String get tripStopPickupOnly => 'Только посадка';

  @override
  String get tripStopDropoffOnly => 'Только высадка';

  @override
  String get bookFormTitle => 'Запросить места';

  @override
  String get bookPickup => 'Посадка';

  @override
  String get bookDropoff => 'Высадка';

  @override
  String get bookSeats => 'Мест';

  @override
  String get bookLuggage => 'Ваш багаж';

  @override
  String get bookMessage => 'Сообщение водителю';

  @override
  String get bookMessageHint => 'Например: буду ждать у входа на автовокзал';

  @override
  String bookFreeOnSegment(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'На этом участке свободно $count места',
      many: 'На этом участке свободно $count мест',
      few: 'На этом участке свободно $count места',
      one: 'На этом участке свободно $count место',
      zero: 'На этом участке нет свободных мест',
    );
    return '$_temp0';
  }

  @override
  String bookTotal(String amount) {
    return 'Итого: $amount';
  }

  @override
  String get bookSubmit => 'Отправить заявку';

  @override
  String get bookNote =>
      'Место подтверждается только после ответа водителя. После этого станет виден его номер.';

  @override
  String get bookSent =>
      'Заявка отправлена. Мы сообщим, когда водитель ответит.';

  @override
  String get bookViewRequest => 'Моя заявка';

  @override
  String get amenityAirConditioning => 'Кондиционер';

  @override
  String get amenityAudio => 'Аудиосистема';

  @override
  String get amenityMusic => 'Музыка';

  @override
  String get amenitySmoking => 'Курение';

  @override
  String get amenityPets => 'Животные';

  @override
  String get amenityLuggage => 'Багаж';

  @override
  String get amenityChildSeat => 'Детское кресло';

  @override
  String get amenityConversation => 'Общение';

  @override
  String get optionYes => 'Да';

  @override
  String get optionNo => 'Нет';

  @override
  String get acYes => 'Есть кондиционер';

  @override
  String get acNo => 'Без кондиционера';

  @override
  String get audioYes => 'Есть аудиосистема';

  @override
  String get audioNo => 'Без аудиосистемы';

  @override
  String get musicAllowed => 'Музыка — пожалуйста';

  @override
  String get musicNone => 'Лучше без музыки';

  @override
  String get musicDriverDecides => 'Музыку выбирает водитель';

  @override
  String get smokingAllowed => 'Можно курить';

  @override
  String get smokingProhibited => 'Не курить';

  @override
  String get petsAllowed => 'Можно с животными';

  @override
  String get petsNotAllowed => 'Без животных';

  @override
  String get luggageNone => 'Без дополнительного багажа';

  @override
  String get luggageSmall => 'Небольшие сумки';

  @override
  String get luggageMedium => 'Средние чемоданы';

  @override
  String get luggageLarge => 'Большие чемоданы';

  @override
  String get childSeatYes => 'Есть детское кресло';

  @override
  String get childSeatNo => 'Нет детского кресла';

  @override
  String get conversationFriendly => 'Люблю поговорить';

  @override
  String get conversationQuiet => 'Предпочитаю тишину';

  @override
  String get conversationNoPreference => 'Как получится';

  @override
  String get tripStatusActive => 'Опубликована';

  @override
  String get tripStatusFull => 'Мест нет';

  @override
  String get tripStatusInProgress => 'В пути';

  @override
  String get tripStatusCompleted => 'Завершена';

  @override
  String get tripStatusCancelled => 'Отменена';

  @override
  String get tripStatusExpired => 'Истекла';

  @override
  String get bookingStatusPending => 'Ждёт ответа';

  @override
  String get bookingStatusApproved => 'Подтверждено';

  @override
  String get bookingStatusRejected => 'Отклонено';

  @override
  String get bookingStatusCancelledByPassenger => 'Отменено пассажиром';

  @override
  String get bookingStatusCancelledByDriver => 'Отменено водителем';

  @override
  String get bookingStatusCompleted => 'Завершено';

  @override
  String get bookingStatusExpired => 'Истекло';

  @override
  String get publishTitle => 'Новая поездка';

  @override
  String get publishStepRoute => 'Маршрут';

  @override
  String get publishStepSchedule => 'Когда';

  @override
  String get publishStepVehicle => 'Машина';

  @override
  String get publishStepComfort => 'Комфорт';

  @override
  String get publishStepPrice => 'Цена';

  @override
  String get publishStepReview => 'Проверка';

  @override
  String publishStepOf(int current, int total) {
    return 'Шаг $current из $total';
  }

  @override
  String get publishDeparture => 'Отправление';

  @override
  String get publishDestination => 'Назначение';

  @override
  String get publishChooseCity => 'Выберите город';

  @override
  String get publishMeetingPoint => 'Место встречи';

  @override
  String get publishMeetingPointHint => 'Точное место, например вход на базар';

  @override
  String get publishAddStop => 'Добавить остановку по пути';

  @override
  String publishStop(int index) {
    return 'Остановка $index';
  }

  @override
  String get publishStopType => 'Пассажиры могут';

  @override
  String get stopTypeBoth => 'Садиться и выходить';

  @override
  String get stopTypePickup => 'Только садиться';

  @override
  String get stopTypeDropoff => 'Только выходить';

  @override
  String get publishStopTime => 'Примерное время здесь';

  @override
  String get publishRemoveStop => 'Удалить остановку';

  @override
  String get publishMoveUp => 'Выше';

  @override
  String get publishMoveDown => 'Ниже';

  @override
  String get publishDate => 'Дата отправления';

  @override
  String get publishTime => 'Время отправления';

  @override
  String get publishDuration => 'Примерная длительность поездки';

  @override
  String publishArrivalPreview(String time) {
    return 'Примерное прибытие: $time';
  }

  @override
  String get publishChooseVehicle => 'На какой машине вы едете?';

  @override
  String get publishNoVehicles =>
      'Добавьте машину, чтобы пассажиры могли её узнать.';

  @override
  String get publishSeats => 'Мест для пассажиров';

  @override
  String get publishSeatsHint =>
      'Считайте только пассажирские места, без места водителя.';

  @override
  String get publishPrice => 'Цена за место, ман.';

  @override
  String get publishPriceHint =>
      'Оставьте пустым, чтобы договориться с пассажирами';

  @override
  String get publishNegotiable => 'Цена договорная';

  @override
  String get publishDescription => 'Описание поездки';

  @override
  String get publishDescriptionHint =>
      'Например: одна короткая остановка в пути, в багажник поместятся два больших чемодана';

  @override
  String get publishConditions => 'Дополнительные условия';

  @override
  String get publishConditionsHint => 'Например: пожалуйста, не опаздывайте';

  @override
  String get publishSubmit => 'Опубликовать поездку';

  @override
  String get publishSuccess => 'Поездка опубликована';

  @override
  String get publishComfortHint =>
      'Всё необязательно. Пассажиры увидят только то, что вы выберете.';

  @override
  String get vehiclesTitle => 'Мои машины';

  @override
  String get vehicleAdd => 'Добавить машину';

  @override
  String get vehicleEdit => 'Изменить машину';

  @override
  String get vehicleBrand => 'Марка';

  @override
  String get vehicleBrandHint => 'Например, Toyota';

  @override
  String get vehicleModel => 'Модель';

  @override
  String get vehicleModelHint => 'Например, Camry';

  @override
  String get vehicleColor => 'Цвет';

  @override
  String get vehiclePlate => 'Госномер';

  @override
  String get vehiclePlateNote =>
      'Госномер видят только подтверждённые пассажиры.';

  @override
  String get vehicleYear => 'Год выпуска';

  @override
  String get vehicleType => 'Тип кузова';

  @override
  String get vehicleSeats => 'Пассажирских мест';

  @override
  String get vehiclePhoto => 'Фото машины';

  @override
  String get vehicleEmpty => 'Вы ещё не добавили машину';

  @override
  String get vehicleDeleteConfirm => 'Удалить эту машину?';

  @override
  String get vehicleSaved => 'Машина сохранена';

  @override
  String get vehicleTypeSedan => 'Седан';

  @override
  String get vehicleTypeHatchback => 'Хэтчбек';

  @override
  String get vehicleTypeWagon => 'Универсал';

  @override
  String get vehicleTypeSuv => 'Внедорожник';

  @override
  String get vehicleTypeMinivan => 'Минивэн';

  @override
  String get vehicleTypeMinibus => 'Микроавтобус';

  @override
  String get vehicleTypeOther => 'Другой';

  @override
  String get myTripsTitle => 'Мои поездки';

  @override
  String get myTripsAsDriver => 'Я водитель';

  @override
  String get myTripsAsPassenger => 'Я пассажир';

  @override
  String get myTripsHistory => 'История';

  @override
  String get myTripsEmptyDriver =>
      'У вас нет предстоящих поездок в роли водителя.';

  @override
  String get myTripsEmptyPassenger => 'У вас нет предстоящих бронирований.';

  @override
  String get myTripsEmptyHistory => 'Здесь появятся ваши прошлые поездки.';

  @override
  String myTripsNewRequests(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count новые заявки',
      many: '$count новых заявок',
      few: '$count новые заявки',
      one: '$count новая заявка',
    );
    return '$_temp0';
  }

  @override
  String myTripsSeatsBooked(int booked, int total) {
    return 'Занято $booked из $total мест';
  }

  @override
  String get historyAsDriverTitle => 'Я был водителем';

  @override
  String get historyAsPassengerTitle => 'Я был пассажиром';

  @override
  String get manageTitle => 'Поездка и заявки';

  @override
  String get managePending => 'Новые заявки';

  @override
  String get manageAccepted => 'Подтверждённые пассажиры';

  @override
  String get manageOther => 'Прочие заявки';

  @override
  String get manageNoRequests =>
      'Заявок пока нет. Мы сообщим, когда пассажир запросит место.';

  @override
  String get manageAccept => 'Принять';

  @override
  String get manageReject => 'Отклонить';

  @override
  String get manageRejectConfirm => 'Отклонить эту заявку?';

  @override
  String get manageCancelBooking => 'Отменить бронирование';

  @override
  String get manageCancelBookingConfirm =>
      'Отменить бронирование пассажира? Он получит уведомление.';

  @override
  String get manageCancelTrip => 'Отменить поездку';

  @override
  String get manageCancelTripConfirm =>
      'Отменить всю поездку? Все пассажиры и заявки будут отменены и уведомлены.';

  @override
  String get manageCompleteTrip => 'Завершить поездку';

  @override
  String get manageCompleteConfirm =>
      'Отметить поездку завершённой? Пассажиры смогут оставить отзыв.';

  @override
  String get manageEditTrip => 'Изменить поездку';

  @override
  String manageRequestedAt(String time) {
    return 'Заявка $time';
  }

  @override
  String get manageAccepted1 => 'Заявка принята';

  @override
  String get manageRejected1 => 'Заявка отклонена';

  @override
  String get manageTripCancelled => 'Поездка отменена';

  @override
  String get manageTripCompleted => 'Поездка завершена';

  @override
  String get manageRatePassenger => 'Оценить пассажира';

  @override
  String get editTripTitle => 'Изменить поездку';

  @override
  String get editTripScheduleLocked =>
      'Дату и время можно изменить, только пока у поездки нет заявок.';

  @override
  String get editTripSaved => 'Поездка обновлена. Пассажиры уведомлены.';

  @override
  String get editTripClearPrice => 'Убрать цену';

  @override
  String get bookingTitle => 'Бронирование';

  @override
  String get bookingContact => 'Контакты';

  @override
  String get bookingCallDriver => 'Позвонить водителю';

  @override
  String get bookingCallPassenger => 'Позвонить пассажиру';

  @override
  String get bookingContactHidden =>
      'Номер телефона появится после того, как водитель подтвердит заявку.';

  @override
  String get bookingCancel => 'Отменить бронирование';

  @override
  String get bookingCancelConfirm =>
      'Отменить бронирование? Водитель получит уведомление.';

  @override
  String get bookingCancelled => 'Бронирование отменено';

  @override
  String get bookingRate => 'Оценить поездку';

  @override
  String get bookingReviewed => 'Спасибо, вы оценили эту поездку';

  @override
  String get bookingYourSegment => 'Ваш участок маршрута';

  @override
  String get bookingRequestedSeats => 'Запрошено мест';

  @override
  String get bookingDialerError => 'Не удалось открыть приложение телефона';

  @override
  String get reviewTitle => 'Оставить отзыв';

  @override
  String reviewAboutDriver(String name) {
    return 'Как прошла поездка с водителем $name?';
  }

  @override
  String reviewAboutPassenger(String name) {
    return 'Каким пассажиром был(а) $name?';
  }

  @override
  String get reviewCommentHint => 'Пара слов о поездке (необязательно)';

  @override
  String get reviewSubmit => 'Отправить отзыв';

  @override
  String get reviewThanks => 'Спасибо за отзыв!';

  @override
  String get reviewChooseRating => 'Выберите от 1 до 5 звёзд';

  @override
  String get reviewsTitle => 'Отзывы';

  @override
  String get reviewsEmpty => 'Отзывов пока нет';

  @override
  String get reviewByPassenger => 'Пассажир';

  @override
  String get reviewByDriver => 'Водитель';

  @override
  String get profileTitle => 'Профиль';

  @override
  String get profileEdit => 'Редактировать профиль';

  @override
  String get profileChangePhoto => 'Изменить фото';

  @override
  String get profileRemovePhoto => 'Удалить фото';

  @override
  String get profilePhone => 'Номер телефона';

  @override
  String get profileChangePhone => 'Сменить номер';

  @override
  String get profileVehicles => 'Мои машины';

  @override
  String get profileReviews => 'Отзывы обо мне';

  @override
  String get profileSettings => 'Настройки';

  @override
  String get profileLogout => 'Выйти';

  @override
  String get profileLogoutConfirm => 'Выйти из аккаунта?';

  @override
  String profileMemberSince(String date) {
    return 'Дата регистрации: $date';
  }

  @override
  String get profileTripsAsDriver => 'Водителем';

  @override
  String get profileTripsAsPassenger => 'Пассажиром';

  @override
  String get profileRating => 'Рейтинг';

  @override
  String get profileSaved => 'Профиль сохранён';

  @override
  String get photoFromGallery => 'Выбрать из галереи';

  @override
  String get photoFromCamera => 'Сделать фото';

  @override
  String get changePhoneTitle => 'Смена номера телефона';

  @override
  String get changePhoneSubtitle =>
      'Мы отправим код на новый номер. Аккаунт и поездки останутся прежними.';

  @override
  String get changePhoneNew => 'Новый номер мобильного';

  @override
  String get changePhoneSuccess => 'Номер телефона изменён';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get settingsLanguage => 'Язык приложения';

  @override
  String get settingsAbout => 'О Ýolugra';

  @override
  String get settingsAboutText =>
      'Ýolugra соединяет водителей и пассажиров, которые едут между городами Туркменистана. Оплата — напрямую между попутчиками.';

  @override
  String get languageTk => 'Türkmençe';

  @override
  String get languageRu => 'Русский';

  @override
  String get languageEn => 'English';

  @override
  String get notificationsTitle => 'Уведомления';

  @override
  String get notificationsEmpty => 'Уведомлений пока нет';

  @override
  String get notificationsMarkAll => 'Прочитать все';

  @override
  String noteBookingRequested(String name, String route) {
    return '$name запрашивает места: $route';
  }

  @override
  String noteBookingApproved(String route) {
    return 'Ваша заявка на поездку $route подтверждена';
  }

  @override
  String noteBookingRejected(String route) {
    return 'Ваша заявка на поездку $route отклонена';
  }

  @override
  String noteBookingCancelledByPassenger(String name, String route) {
    return '$name отменил(а) бронирование: $route';
  }

  @override
  String noteBookingCancelledByDriver(String route) {
    return 'Водитель отменил ваше бронирование: $route';
  }

  @override
  String noteBookingExpired(String route) {
    return 'Заявка на поездку $route истекла без ответа';
  }

  @override
  String noteTripCancelled(String route) {
    return 'Поездка $route отменена';
  }

  @override
  String noteTripUpdated(String route) {
    return 'Водитель изменил поездку $route';
  }

  @override
  String noteTripReminder(String route) {
    return 'Поездка $route скоро начнётся';
  }

  @override
  String noteTripCompleted(String route) {
    return 'Поездка $route завершена. Оцените попутчиков';
  }

  @override
  String noteReviewReceived(String name) {
    return '$name оставил(а) вам отзыв';
  }

  @override
  String get noteSomeone => 'Пользователь';

  @override
  String get filterAny => 'Любой';

  @override
  String get serverTitle => 'Адрес сервера';

  @override
  String get serverHint => 'Например, 192.168.1.10:8081';

  @override
  String get serverNote =>
      'Только в тестовых сборках. Укажите адрес компьютера в той же Wi-Fi сети.';

  @override
  String get serverCheck => 'Проверить связь';

  @override
  String get serverReachable => 'Сервер отвечает';

  @override
  String serverUnreachable(String url) {
    return 'Нет ответа от $url. Проверьте адрес, Wi-Fi и брандмауэр компьютера.';
  }

  @override
  String get serverInvalid => 'Введите адрес вида 192.168.1.10:8081';

  @override
  String get serverReset => 'По умолчанию';

  @override
  String get serverSaved => 'Адрес сервера сохранён';
}
