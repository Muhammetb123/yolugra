import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/paged_cubit.dart';
import 'state_views.dart';

/// Renders a [PagedCubit] with loading, error, empty, pull-to-refresh and infinite scroll.
class PagedListView<T> extends StatelessWidget {
  const PagedListView({super.key, required this.itemBuilder, required this.empty, this.padding = const EdgeInsets.all(16)});

  final Widget Function(BuildContext context, T item) itemBuilder;
  final Widget empty;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PagedCubit<T>, PagedState<T>>(
      builder: (context, s) {
        final cubit = context.read<PagedCubit<T>>();
        if (s.status == LoadStatus.failure && s.items.isEmpty) return ErrorView(error: s.error!, onRetry: cubit.refresh);
        if ((s.status == LoadStatus.loading || s.status == LoadStatus.initial) && s.items.isEmpty) return const LoadingView();
        return RefreshIndicator(
          onRefresh: cubit.refresh,
          child: s.items.isEmpty
              ? ListView(children: [const SizedBox(height: 60), empty])
              : NotificationListener<ScrollNotification>(
                  onNotification: (n) {
                    if (n.metrics.pixels > n.metrics.maxScrollExtent - 300) cubit.loadMore();
                    return false;
                  },
                  child: ListView.separated(
                    padding: padding,
                    itemCount: s.items.length + (s.hasMore ? 1 : 0),
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, i) => i == s.items.length
                        ? const Padding(padding: EdgeInsets.all(16), child: LoadingView())
                        : itemBuilder(context, s.items[i]),
                  ),
                ),
        );
      },
    );
  }
}
