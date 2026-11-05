import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/localization/l10n.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/feedback.dart';

/// Opens the phone's dialer with [phone]. No in-app calling.
class CallButton extends StatelessWidget {
  const CallButton({super.key, required this.phone, required this.label});

  final String phone;
  final String label;

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonalIcon(
      style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
      onPressed: () async {
        final ok = await launchUrl(Uri(scheme: 'tel', path: phone));
        if (!ok && context.mounted) showMessage(context, context.l10n.bookingDialerError);
      },
      icon: const Icon(Icons.call_rounded),
      label: Text('$label · ${Formatters.phone(phone)}'),
    );
  }
}
