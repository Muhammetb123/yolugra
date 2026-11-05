/// The backend booking state machine. "approved" is the accepted state.
enum BookingStatus {
  pending,
  approved,
  rejected,
  cancelledByPassenger,
  cancelledByDriver,
  completed,
  expired;

  bool get isActive => this == pending || this == approved;
  bool get isCancelled => this == cancelledByPassenger || this == cancelledByDriver;

  /// The backend shares phone numbers only in these states; the client mirrors it.
  bool get contactVisible => this == approved || this == completed;
}
