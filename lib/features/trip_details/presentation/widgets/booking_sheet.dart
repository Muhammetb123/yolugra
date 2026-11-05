import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/localization/l10n.dart';
import '../../../../core/bloc/paged_cubit.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../../core/errors/error_text.dart';
import '../../../../core/widgets/feedback.dart';
import '../../../../init/dependency_injection.dart';
import '../../../bookings/domain/booking.dart';
import '../../../trips/domain/trip.dart';
import '../../../trips/presentation/widgets/trip_labels.dart';
import '../bloc/trip_details_cubits.dart';

/// The seat request form. Resolves to the created booking.
Future<Booking?> showBookingSheet(BuildContext context, Trip trip, {int? seats, int? pickup, int? dropoff}) =>
    showModalBottomSheet<Booking>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => BlocProvider(
        create: (_) => BookingFormCubit(sl(), trip, seats: seats, pickup: pickup, dropoff: dropoff),
        child: const _BookingSheet(),
      ),
    );

class _BookingSheet extends StatelessWidget {
  const _BookingSheet();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final lang = context.languageCode;
    final theme = Theme.of(context);
    final fmt = Formatters.of(context);
    return BlocConsumer<BookingFormCubit, BookingFormState>(
      listener: (context, s) {
        if (s.status == LoadStatus.success && s.booking != null) Navigator.pop(context, s.booking);
      },
      builder: (context, s) {
        final cubit = context.read<BookingFormCubit>();
        final free = cubit.freeSeats;
        final trip = cubit.trip;
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            children: [
              Text(l.bookFormTitle, style: theme.textTheme.titleLarge),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                initialValue: s.pickup,
                decoration: InputDecoration(labelText: l.bookPickup, prefixIcon: const Icon(Icons.trip_origin_rounded)),
                items: [for (final st in cubit.pickupOptions) DropdownMenuItem(value: st.order, child: Text(st.location.name(lang)))],
                onChanged: (v) => v == null ? null : cubit.setPickup(v),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                key: ValueKey(s.pickup),
                initialValue: cubit.dropoffOptions.any((o) => o.order == s.dropoff) ? s.dropoff : null,
                decoration: InputDecoration(labelText: l.bookDropoff, prefixIcon: const Icon(Icons.place_rounded)),
                items: [for (final st in cubit.dropoffOptions) DropdownMenuItem(value: st.order, child: Text(st.location.name(lang)))],
                onChanged: (v) => v == null ? null : cubit.setDropoff(v),
              ),
              const SizedBox(height: 12),
              Text(l.bookFreeOnSegment(free),
                  style: theme.textTheme.bodyMedium?.copyWith(color: free > 0 ? theme.colorScheme.primary : theme.colorScheme.error)),
              const SizedBox(height: 8),
              CounterField(label: l.bookSeats, value: s.seats, min: 1, max: free < 1 ? 1 : free, onChanged: cubit.setSeats),
              const SizedBox(height: 16),
              Text(l.bookLuggage, style: theme.textTheme.titleSmall),
              const SizedBox(height: 8),
              Wrap(spacing: 8, runSpacing: 8, children: [
                for (final size in LuggageSize.values)
                  ChoiceChip(
                    label: Text(size == LuggageSize.unspecified ? l.commonNotSpecified : l.luggage(size)),
                    selected: s.luggage == size,
                    onSelected: (_) => cubit.setLuggage(size),
                  ),
              ]),
              const SizedBox(height: 16),
              TextField(
                maxLength: 500,
                maxLines: 3,
                minLines: 2,
                onChanged: cubit.setMessage,
                decoration: InputDecoration(labelText: '${l.bookMessage} (${l.commonOptional.toLowerCase()})', hintText: l.bookMessageHint),
              ),
              if (trip.price != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(l.bookTotal(fmt.price(trip.price! * s.seats)), style: theme.textTheme.titleMedium),
                ),
              if (s.status == LoadStatus.failure && s.error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(errorText(l, s.error!), style: TextStyle(color: theme.colorScheme.error)),
                ),
              Text(l.bookNote, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              const SizedBox(height: 16),
              PrimaryButton(
                label: l.bookSubmit,
                loading: s.status == LoadStatus.loading,
                onPressed: free >= s.seats && s.validSegment ? cubit.submit : null,
              ),
            ],
          ),
        );
      },
    );
  }
}
