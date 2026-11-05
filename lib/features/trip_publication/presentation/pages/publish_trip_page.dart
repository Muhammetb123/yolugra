import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/localization/l10n.dart';
import '../../../../app/router/app_router.dart';
import '../../../../core/bloc/paged_cubit.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../../core/widgets/feedback.dart';
import '../../../../init/dependency_injection.dart';
import '../bloc/publish_trip_cubit.dart';
import '../widgets/comfort_step.dart';
import '../widgets/price_step.dart';
import '../widgets/review_step.dart';
import '../widgets/route_step.dart';
import '../widgets/schedule_step.dart';
import '../widgets/vehicle_step.dart';

@RoutePage()
class PublishTripPage extends StatelessWidget {
  const PublishTripPage({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocProvider(create: (_) => PublishTripCubit(sl(), sl())..loadVehicles(), child: const _PublishView());
}

String issueText(AppLocalizations l, PublishIssue issue, {int? seats}) => switch (issue) {
      PublishIssue.routeIncomplete => l.validationRouteIncomplete,
      PublishIssue.duplicateStop => l.validationSameStops,
      PublishIssue.departurePast => l.validationDepartureFuture,
      PublishIssue.durationRange => l.validationDuration,
      PublishIssue.noVehicle => l.validationVehicle,
      PublishIssue.seatsOverVehicle => l.validationSeatsVehicle(seats ?? 0),
      PublishIssue.priceRange => l.validationPrice,
    };

class _PublishView extends StatelessWidget {
  const _PublishView();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final titles = {
      PublishStep.route: l.publishStepRoute,
      PublishStep.schedule: l.publishStepSchedule,
      PublishStep.vehicle: l.publishStepVehicle,
      PublishStep.comfort: l.publishStepComfort,
      PublishStep.price: l.publishStepPrice,
      PublishStep.review: l.publishStepReview,
    };
    return BlocConsumer<PublishTripCubit, PublishTripState>(
      listenWhen: (a, b) => a.issue != b.issue || a.submitStatus != b.submitStatus,
      listener: (context, s) {
        if (s.issue != null) showMessage(context, issueText(l, s.issue!, seats: s.maxSeats));
        if (s.submitStatus == LoadStatus.failure && s.error != null) {
          showError(context, s.error!);
          // An overlap needs a different date or time.
          if (s.error is AppException && (s.error as AppException).code == 'TRIP_OVERLAP') {
            context.read<PublishTripCubit>().goTo(PublishStep.schedule);
          }
        }
        if (s.submitStatus == LoadStatus.success && s.published != null) {
          showMessage(context, l.publishSuccess);
          final id = s.published!.id;
          context.read<PublishTripCubit>().reset();
          context.router.push(TripManageRoute(tripId: id));
        }
      },
      builder: (context, s) {
        final cubit = context.read<PublishTripCubit>();
        final index = PublishStep.values.indexOf(s.step);
        final last = s.step == PublishStep.review;
        return PopScope(
          canPop: index == 0,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) cubit.back();
          },
          child: Scaffold(
            appBar: AppBar(
              leading: index > 0 ? IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: cubit.back) : null,
              title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(titles[s.step]!),
                Text(l.publishStepOf(index + 1, PublishStep.values.length), style: Theme.of(context).textTheme.bodySmall),
              ]),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(4),
                child: LinearProgressIndicator(value: (index + 1) / PublishStep.values.length),
              ),
            ),
            body: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: KeyedSubtree(
                key: ValueKey(s.step),
                child: switch (s.step) {
                  PublishStep.route => const RouteStep(),
                  PublishStep.schedule => const ScheduleStep(),
                  PublishStep.vehicle => const VehicleStep(),
                  PublishStep.comfort => const ComfortStep(),
                  PublishStep.price => const PriceStep(),
                  PublishStep.review => const ReviewStep(),
                },
              ),
            ),
            bottomNavigationBar: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: PrimaryButton(
                  label: last ? l.publishSubmit : l.commonNext,
                  loading: s.submitStatus == LoadStatus.loading,
                  onPressed: last ? cubit.submit : cubit.next,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
