import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/localization/l10n.dart';
import '../../../../core/bloc/paged_cubit.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../../core/widgets/feedback.dart';
import '../../../../init/dependency_injection.dart';
import '../../../authentication/presentation/bloc/auth_bloc.dart';
import '../bloc/profile_cubits.dart';
import '../widgets/name_fields.dart';

@RoutePage()
class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(create: (_) => ProfileFormCubit(sl()), child: const _View());
}

class _View extends StatefulWidget {
  const _View();

  @override
  State<_View> createState() => _ViewState();
}

class _ViewState extends State<_View> {
  final _form = GlobalKey<FormState>();
  late final _profile = context.read<AuthBloc>().profile;
  late final _first = TextEditingController(text: _profile?.firstName);
  late final _last = TextEditingController(text: _profile?.lastName);
  late final _bio = TextEditingController(text: _profile?.bio);

  @override
  void dispose() {
    _first.dispose();
    _last.dispose();
    _bio.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return BlocConsumer<ProfileFormCubit, ProfileFormState>(
      listener: (context, s) {
        if (s.status == LoadStatus.success && s.profile != null) {
          context.read<AuthBloc>().add(AuthProfileChanged(s.profile!));
          showMessage(context, l.profileSaved);
          context.router.maybePop();
        } else if (s.status == LoadStatus.failure) {
          showError(context, s.error!);
        }
      },
      builder: (context, s) => Scaffold(
        appBar: AppBar(title: Text(l.profileEdit)),
        body: Form(
          key: _form,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              NameFields(first: _first, last: _last),
              const SizedBox(height: 14),
              TextFormField(
                controller: _bio,
                maxLength: 500,
                maxLines: 4,
                minLines: 2,
                decoration: InputDecoration(labelText: '${l.bioLabel} (${l.commonOptional.toLowerCase()})', hintText: l.bioHint),
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                label: l.commonSave,
                loading: s.status == LoadStatus.loading,
                onPressed: () {
                  if (_form.currentState!.validate()) {
                    context.read<ProfileFormCubit>().save(firstName: _first.text, lastName: _last.text, bio: _bio.text);
                  }
                },
              ),
              if (_profile?.photoUrl != null) ...[
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: s.photoBusy
                      ? null
                      : () async {
                          final p = await context.read<ProfileFormCubit>().removePhoto();
                          if (p != null && context.mounted) context.read<AuthBloc>().add(AuthProfileChanged(p));
                        },
                  icon: const Icon(Icons.hide_image_outlined),
                  label: Text(l.profileRemovePhoto),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
