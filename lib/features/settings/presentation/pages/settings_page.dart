import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/localization/l10n.dart';
import '../../../../core/config/server_address.dart';
import '../../../../core/widgets/section_card.dart';
import '../../../../init/dependency_injection.dart';
import '../../../authentication/presentation/bloc/auth_bloc.dart';
import '../../../profile/domain/profile.dart';
import '../bloc/settings_cubit.dart';
import '../widgets/language_switcher.dart';
import '../widgets/server_address_dialog.dart';

@RoutePage()
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  Future<void> _setLocale(BuildContext context, Locale locale) async {
    await context.read<SettingsCubit>().setLocale(locale);
    // The account remembers the language too, so SMS texts follow it. Best effort.
    try {
      await sl<ProfileRepository>().update(locale: locale.languageCode);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final current = context.watch<SettingsCubit>().state;
    return Scaffold(
      appBar: AppBar(title: Text(l.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SectionCard(
            title: l.settingsLanguage,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: RadioGroup<String>(
              groupValue: current.languageCode,
              onChanged: (code) => code == null ? null : _setLocale(context, Locale(code)),
              child: Column(children: [
                for (final loc in supportedLocales)
                  RadioListTile<String>(
                    contentPadding: EdgeInsets.zero,
                    value: loc.languageCode,
                    title: Text(languageName(l, loc.languageCode)),
                  ),
              ]),
            ),
          ),
          if (ServerAddress.editable) ...[
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                leading: const Icon(Icons.dns_outlined),
                title: Text(l.serverTitle),
                subtitle: Text(sl<ServerAddress>().current),
                trailing: const Icon(Icons.edit_outlined),
                onTap: () async {
                  // The session belongs to the previous server, so a new address signs out.
                  if (await showServerAddressDialog(context) && context.mounted) {
                    context.read<AuthBloc>().add(const AuthLogoutRequested());
                  }
                },
              ),
            ),
          ],
          const SizedBox(height: 12),
          SectionCard(
            title: l.settingsAbout,
            child: Text(l.settingsAboutText),
          ),
        ],
      ),
    );
  }
}
