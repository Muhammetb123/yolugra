import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../../app/localization/l10n.dart';
import '../../../../app/router/app_router.dart';
import '../widgets/search_form.dart';

/// The search tab: the full search form.
@RoutePage()
class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.searchTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SearchForm(onSearch: (q) => context.router.push(SearchResultsRoute(query: q))),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline_rounded, size: 18, color: Theme.of(context).colorScheme.onSurfaceVariant),
              const SizedBox(width: 8),
              Expanded(child: Text(l.tripPaymentNote, style: Theme.of(context).textTheme.bodySmall)),
            ],
          ),
        ],
      ),
    );
  }
}
