import 'package:flutter/material.dart';

import '../../../../app/localization/l10n.dart';
import '../../../trips/domain/trip.dart';
import '../../../trips/presentation/widgets/trip_labels.dart';

/// Filters and sorting for search results. Resolves to the new query, or null.
Future<SearchQuery?> showFiltersSheet(BuildContext context, SearchQuery query) => showModalBottomSheet<SearchQuery>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => _FiltersSheet(query),
    );

class _FiltersSheet extends StatefulWidget {
  const _FiltersSheet(this.initial);
  final SearchQuery initial;

  @override
  State<_FiltersSheet> createState() => _FiltersSheetState();
}

class _FiltersSheetState extends State<_FiltersSheet> {
  late SearchQuery _q = widget.initial;
  late final _price = TextEditingController(text: widget.initial.priceMax?.toStringAsFixed(0) ?? '');

  @override
  void dispose() {
    _price.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    Widget heading(String t) => Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 8),
          child: Text(t, style: theme.textTheme.titleMedium),
        );
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      builder: (context, scroll) => Column(
        children: [
          Expanded(
            child: ListView(
              controller: scroll,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                Row(children: [
                  Expanded(child: Text(l.searchFilters, style: theme.textTheme.titleLarge)),
                  TextButton(onPressed: () => setState(() {
                    _q = _q.withoutFilters();
                    _price.clear();
                  }), child: Text(l.filterReset)),
                ]),
                heading(l.searchSort),
                Wrap(spacing: 8, runSpacing: 8, children: [
                  for (final (s, label) in [
                    (SearchSort.departure, l.sortDeparture),
                    (SearchSort.priceAsc, l.sortPriceAsc),
                    (SearchSort.priceDesc, l.sortPriceDesc),
                    (SearchSort.rating, l.sortRating),
                  ])
                    ChoiceChip(label: Text(label), selected: _q.sort == s, onSelected: (_) => setState(() => _q = _q.copyWith(sort: s))),
                ]),
                heading(l.filterDepartureTime),
                Wrap(spacing: 8, runSpacing: 8, children: [
                  for (final (w, label) in [
                    (TimeWindow.any, l.filterTimeAny),
                    (TimeWindow.morning, l.filterTimeMorning),
                    (TimeWindow.afternoon, l.filterTimeAfternoon),
                    (TimeWindow.evening, l.filterTimeEvening),
                  ])
                    ChoiceChip(label: Text(label), selected: _q.timeWindow == w, onSelected: (_) => setState(() => _q = _q.copyWith(timeWindow: w))),
                ]),
                heading(l.filterPriceMax),
                TextField(
                  controller: _price,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(suffixText: 'TMT', hintText: l.commonOptional),
                  onChanged: (v) => _q = _q.copyWith(priceMax: () => double.tryParse(v)),
                ),
                heading(l.filterComfort),
                SwitchListTile(contentPadding: EdgeInsets.zero, title: Text(l.amenityAirConditioning), value: _q.airConditioning,
                    onChanged: (v) => setState(() => _q = _q.copyWith(airConditioning: v))),
                SwitchListTile(contentPadding: EdgeInsets.zero, title: Text(l.petsAllowed), value: _q.petsAllowed,
                    onChanged: (v) => setState(() => _q = _q.copyWith(petsAllowed: v))),
                SwitchListTile(contentPadding: EdgeInsets.zero, title: Text(l.smokingProhibited), value: _q.noSmoking,
                    onChanged: (v) => setState(() => _q = _q.copyWith(noSmoking: v))),
                SwitchListTile(contentPadding: EdgeInsets.zero, title: Text(l.childSeatYes), value: _q.childSeat,
                    onChanged: (v) => setState(() => _q = _q.copyWith(childSeat: v))),
                SwitchListTile(contentPadding: EdgeInsets.zero, title: Text(l.filterMinRating), value: _q.topRated,
                    onChanged: (v) => setState(() => _q = _q.copyWith(topRated: v))),
                heading(l.filterLuggage),
                Wrap(spacing: 8, runSpacing: 8, children: [
                  ChoiceChip(label: Text(l.filterAny), selected: _q.minLuggage == null,
                      onSelected: (_) => setState(() => _q = _q.copyWith(minLuggage: () => null))),
                  for (final s in [LuggageSize.small, LuggageSize.medium, LuggageSize.large])
                    ChoiceChip(label: Text(l.luggage(s)), selected: _q.minLuggage == s,
                        onSelected: (_) => setState(() => _q = _q.copyWith(minLuggage: () => s))),
                ]),
                const SizedBox(height: 24),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: FilledButton(onPressed: () => Navigator.pop(context, _q), child: Text(l.filterApply)),
            ),
          ),
        ],
      ),
    );
  }
}
