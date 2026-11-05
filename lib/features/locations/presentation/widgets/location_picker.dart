import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/localization/l10n.dart';
import '../../../../core/bloc/paged_cubit.dart';
import '../../../../core/widgets/state_views.dart';
import '../../domain/location.dart';
import '../bloc/locations_cubit.dart';

/// Opens the place picker. With [allowWelayat] a whole welayat can be chosen, which the
/// backend expands to every active place in it (used for search, not for publishing).
Future<Location?> pickLocation(BuildContext context, {bool allowWelayat = false}) {
  final cubit = context.read<LocationsCubit>()..load();
  return showModalBottomSheet<Location>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => BlocProvider.value(
      value: cubit,
      child: FractionallySizedBox(heightFactor: 0.9, child: _LocationSheet(allowWelayat: allowWelayat)),
    ),
  );
}

class _LocationSheet extends StatefulWidget {
  const _LocationSheet({required this.allowWelayat});
  final bool allowWelayat;

  @override
  State<_LocationSheet> createState() => _LocationSheetState();
}

class _LocationSheetState extends State<_LocationSheet> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final lang = context.languageCode;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.locationPickerTitle, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          TextField(
            autofocus: true,
            decoration: InputDecoration(prefixIcon: const Icon(Icons.search_rounded), hintText: l.locationSearchHint),
            onChanged: (v) => setState(() => _query = v),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: BlocBuilder<LocationsCubit, LocationsState>(
              builder: (context, state) {
                if (state.status == LoadStatus.failure && state.all.isEmpty) {
                  return ErrorView(error: state.error!, onRetry: () => context.read<LocationsCubit>().load(refresh: true));
                }
                if (state.all.isEmpty) return const LoadingView();
                final tiles = _tiles(state, lang, l);
                if (tiles.isEmpty) return EmptyState(icon: Icons.location_off_rounded, title: l.locationEmpty);
                return ListView(children: tiles);
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _tiles(LocationsState s, String lang, AppLocalizations l) {
    final theme = Theme.of(context);
    Widget tile(Location loc, {String? subtitle, bool indent = false}) => ListTile(
          contentPadding: EdgeInsets.only(left: indent ? 16 : 0),
          leading: Icon(loc.type == LocationType.welayat ? Icons.map_outlined : Icons.location_city_rounded,
              color: theme.colorScheme.primary),
          title: Text(loc.name(lang)),
          subtitle: subtitle == null ? null : Text(subtitle),
          onTap: () => Navigator.pop(context, loc),
        );

    final out = <Widget>[];
    for (final city in s.topLevelCities.where((c) => c.matches(_query))) {
      out.add(tile(city));
    }
    for (final w in s.welayats) {
      final children = s.childrenOf(w.id).where((c) => c.matches(_query) || w.matches(_query)).toList();
      final showWelayat = widget.allowWelayat && w.matches(_query);
      if (children.isEmpty && !showWelayat) continue;
      out.add(Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 4),
        child: Text('${w.name(lang)} · ${l.locationTypeWelayat}',
            style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
      ));
      if (widget.allowWelayat) out.add(tile(w, subtitle: l.locationWholeWelayat, indent: true));
      for (final c in children) {
        out.add(tile(c, indent: true));
      }
    }
    return out;
  }
}
