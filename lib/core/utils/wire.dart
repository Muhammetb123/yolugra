/// Conversion between Dart enum names (camelCase) and API values (snake_case).
String wire(Enum value) => value.name.replaceAllMapped(RegExp('[A-Z]'), (m) => '_${m[0]!.toLowerCase()}');

T fromWire<T extends Enum>(List<T> values, Object? raw, T fallback) {
  for (final v in values) {
    if (wire(v) == raw) return v;
  }
  return fallback;
}

/// One page of a list endpoint.
class PageResult<T> {
  const PageResult(this.items, this.hasMore);

  final List<T> items;
  final bool hasMore;
}

DateTime? parseTime(Object? raw) => raw is String ? DateTime.tryParse(raw) : null;

double? parseDouble(Object? raw) => raw is num ? raw.toDouble() : null;
