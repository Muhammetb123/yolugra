import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../app/localization/l10n.dart';

/// The app mark: a stylised road in a rounded square.
class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 72});
  final double size;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.3),
        gradient: LinearGradient(colors: [scheme.primary, Color.lerp(scheme.primary, scheme.secondary, 0.35)!],
            begin: Alignment.topLeft, end: Alignment.bottomRight),
      ),
      child: Icon(Icons.alt_route_rounded, color: scheme.onPrimary, size: size * 0.55),
    );
  }
}

/// Eight national digits after a fixed +993 prefix.
class PhoneField extends StatelessWidget {
  const PhoneField({super.key, required this.controller, this.errorText, this.onSubmitted, this.autofocus = true, this.label});

  final TextEditingController controller;
  final String? errorText;
  final ValueChanged<String>? onSubmitted;
  final bool autofocus;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return TextField(
      controller: controller,
      autofocus: autofocus,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.done,
      autofillHints: const [AutofillHints.telephoneNumberNational],
      inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(8)],
      style: Theme.of(context).textTheme.titleLarge,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        labelText: label ?? l.authPhoneLabel,
        hintText: l.authPhoneHint,
        prefixText: '+993 ',
        prefixIcon: const Icon(Icons.phone_iphone_rounded),
        errorText: errorText,
      ),
    );
  }
}

/// Six-digit code input. The code is never generated or checked on the device.
class CodeField extends StatelessWidget {
  const CodeField({super.key, required this.controller, this.errorText, this.onCompleted});

  final TextEditingController controller;
  final String? errorText;
  final ValueChanged<String>? onCompleted;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      autofocus: true,
      keyboardType: TextInputType.number,
      autofillHints: const [AutofillHints.oneTimeCode],
      textAlign: TextAlign.center,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(6)],
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(letterSpacing: 12),
      onChanged: (v) {
        if (v.length == 6) onCompleted?.call(v);
      },
      decoration: InputDecoration(labelText: context.l10n.authCodeLabel, counterText: '', errorText: errorText),
    );
  }
}
