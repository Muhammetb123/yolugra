import 'package:flutter/material.dart';

import '../../../../app/localization/l10n.dart';

/// Validated first and last name inputs, shared by profile completion and editing.
class NameFields extends StatelessWidget {
  const NameFields({super.key, required this.first, required this.last});

  final TextEditingController first;
  final TextEditingController last;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    String? validate(String? v) {
      final t = v?.trim() ?? '';
      if (t.isEmpty) return l.validationRequired;
      if (t.length > 50) return l.validationTooLong(50);
      return null;
    }

    return Column(
      children: [
        TextFormField(
          controller: first,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.givenName],
          decoration: InputDecoration(labelText: l.firstNameLabel),
          validator: validate,
        ),
        const SizedBox(height: 14),
        TextFormField(
          controller: last,
          textCapitalization: TextCapitalization.words,
          autofillHints: const [AutofillHints.familyName],
          decoration: InputDecoration(labelText: l.lastNameLabel),
          validator: validate,
        ),
      ],
    );
  }
}
