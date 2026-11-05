import 'package:flutter/material.dart';

import '../../../../app/localization/l10n.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/feedback.dart';
import '../../../locations/domain/location.dart';
import '../../../locations/presentation/widgets/location_picker.dart';
import '../../../trips/domain/trip.dart';

/// From, to, date and passengers. Calls [onSearch] with the query.
class SearchForm extends StatefulWidget {
  const SearchForm({super.key, this.initial = const SearchQuery(), required this.onSearch});

  final SearchQuery initial;
  final ValueChanged<SearchQuery> onSearch;

  @override
  State<SearchForm> createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {
  late SearchQuery _q = widget.initial;

  Future<void> _pick(bool from) async {
    final loc = await pickLocation(context, allowWelayat: true);
    if (loc == null) return;
    setState(() => _q = from ? _q.copyWith(from: () => loc) : _q.copyWith(to: () => loc));
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final d = await showDatePicker(
      context: context,
      firstDate: DateUtils.dateOnly(now),
      lastDate: now.add(const Duration(days: 90)),
      initialDate: _q.date ?? now,
    );
    if (d != null) setState(() => _q = _q.copyWith(date: () => d));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final lang = context.languageCode;
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.centerRight,
              children: [
                Column(children: [
                  _Field(icon: Icons.trip_origin_rounded, label: l.homeFrom, value: _q.from?.name(lang), placeholder: l.searchAnywhere, onTap: () => _pick(true)),
                  const Divider(indent: 48),
                  _Field(icon: Icons.place_rounded, label: l.homeTo, value: _q.to?.name(lang), placeholder: l.searchAnywhere, onTap: () => _pick(false)),
                ]),
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: IconButton.filledTonal(
                    tooltip: l.homeSwap,
                    onPressed: () => setState(() {
                      final from = _q.from;
                      _q = _q.copyWith(from: () => _q.to, to: () => from);
                    }),
                    icon: const Icon(Icons.swap_vert_rounded),
                  ),
                ),
              ],
            ),
            const Divider(indent: 48),
            Row(
              children: [
                Expanded(
                  child: _Field(
                    icon: Icons.event_rounded,
                    label: l.homeDate,
                    value: _q.date == null ? null : Formatters.of(context).relativeDay(_q.date!),
                    placeholder: l.homeAnyDate,
                    onTap: _pickDate,
                    trailing: _q.date == null
                        ? null
                        : IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => setState(() => _q = _q.copyWith(date: () => null))),
                  ),
                ),
              ],
            ),
            const Divider(indent: 48),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 4, 4),
              child: Row(
                children: [
                  Icon(Icons.person_rounded, color: theme.colorScheme.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CounterField(
                      label: l.passengersCount(_q.seats),
                      value: _q.seats,
                      min: 1,
                      max: 8,
                      onChanged: (v) => setState(() => _q = _q.copyWith(seats: v)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(4),
              child: FilledButton.icon(
                onPressed: () => widget.onSearch(_q),
                icon: const Icon(Icons.search_rounded),
                label: Text(l.homeSearch),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({required this.icon, required this.label, required this.value, required this.placeholder, required this.onTap, this.trailing});

  final IconData icon;
  final String label;
  final String? value;
  final String placeholder;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Icon(icon, color: theme.colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                  Text(value ?? placeholder,
                      style: theme.textTheme.titleMedium?.copyWith(color: value == null ? theme.colorScheme.onSurfaceVariant : null),
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            if (trailing != null) trailing! else const SizedBox(width: 48),
          ],
        ),
      ),
    );
  }
}

/// Helper used by the results page header.
String routeTitle(BuildContext context, Location? from, Location? to) {
  final l = context.l10n;
  final lang = context.languageCode;
  return '${from?.name(lang) ?? l.searchAnywhere} → ${to?.name(lang) ?? l.searchAnywhere}';
}
