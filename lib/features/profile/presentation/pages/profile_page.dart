import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/localization/l10n.dart';
import '../../../../app/router/app_router.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/feedback.dart';
import '../../../../core/widgets/photo_source.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../../init/dependency_injection.dart';
import '../../../authentication/presentation/bloc/auth_bloc.dart';
import '../../domain/profile.dart';
import '../bloc/profile_cubits.dart';
import '../widgets/profile_header.dart';

@RoutePage()
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(create: (_) => ProfileFormCubit(sl()), child: const _ProfileView());
}

class _ProfileView extends StatefulWidget {
  const _ProfileView();

  @override
  State<_ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<_ProfileView> {
  @override
  void initState() {
    super.initState();
    _refresh();
  }

  /// Counts and rating change as trips complete, so the tab reloads the profile.
  Future<void> _refresh() async {
    try {
      final p = await sl<ProfileRepository>().me();
      if (mounted) context.read<AuthBloc>().add(AuthProfileChanged(p));
    } catch (_) {
      // The cached profile stays on screen.
    }
  }

  Future<void> _photo(Profile profile) async {
    final cubit = context.read<ProfileFormCubit>();
    final path = await pickPhoto(context);
    if (path == null) return;
    final p = await cubit.setPhoto(path);
    if (!mounted) return;
    if (p != null) {
      context.read<AuthBloc>().add(AuthProfileChanged(p));
    } else if (cubit.state.error != null) {
      showError(context, cubit.state.error!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final profile = context.select((AuthBloc b) => b.profile);
    final busy = context.select((ProfileFormCubit c) => c.state.photoBusy);
    if (profile == null) return const Scaffold(body: LoadingView());
    Widget item(IconData icon, String title, VoidCallback onTap, {String? subtitle}) => ListTile(
          leading: Icon(icon),
          title: Text(title),
          subtitle: subtitle == null ? null : Text(subtitle),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: onTap,
        );
    return Scaffold(
      appBar: AppBar(
        title: Text(l.profileTitle),
        actions: [IconButton(tooltip: l.profileEdit, onPressed: () => context.router.push(const EditProfileRoute()), icon: const Icon(Icons.edit_outlined))],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ProfileHeader(profile: profile, photoBusy: busy, onPhotoTap: () => _photo(profile)),
            const SizedBox(height: 20),
            Card(
              child: Column(children: [
                item(Icons.phone_iphone_rounded, l.profilePhone, () => context.router.push(const ChangePhoneRoute()),
                    subtitle: profile.phone == null ? null : Formatters.phone(profile.phone!)),
                const Divider(indent: 56),
                item(Icons.directions_car_outlined, l.profileVehicles, () => context.router.push(const VehiclesRoute())),
                const Divider(indent: 56),
                item(Icons.star_outline_rounded, l.profileReviews, () => context.router.push(PublicProfileRoute(userId: profile.id))),
                const Divider(indent: 56),
                item(Icons.notifications_none_rounded, l.notificationsTitle, () => context.router.push(const NotificationsRoute())),
                const Divider(indent: 56),
                item(Icons.settings_outlined, l.profileSettings, () => context.router.push(const SettingsRoute())),
              ]),
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error),
              onPressed: () async {
                if (await confirm(context, l.profileLogoutConfirm, confirmLabel: l.profileLogout, danger: true) && context.mounted) {
                  context.read<AuthBloc>().add(const AuthLogoutRequested());
                }
              },
              icon: const Icon(Icons.logout_rounded),
              label: Text(l.profileLogout),
            ),
          ],
        ),
      ),
    );
  }
}
