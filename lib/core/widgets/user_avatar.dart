import 'package:flutter/material.dart';

import '../config/app_config.dart';

/// A round photo with the person's initials as a fallback. An empty [name] (a deleted
/// account) shows a neutral person icon.
class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key, required this.name, this.photoUrl, this.radius = 22});

  final String name;
  final String? photoUrl;
  final double radius;

  String get _initials {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    return parts.take(2).map((p) => p.characters.first.toUpperCase()).join();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final initials = _initials;
    final Widget fallback = initials.isEmpty
        ? Icon(Icons.person_outline_rounded, size: radius * 1.1, color: scheme.onPrimaryContainer)
        : Text(initials, style: TextStyle(fontSize: radius * 0.72, fontWeight: FontWeight.w700, color: scheme.onPrimaryContainer));
    final url = photoUrl;
    return CircleAvatar(
      radius: radius,
      backgroundColor: scheme.primaryContainer,
      child: url == null || url.isEmpty
          ? fallback
          : ClipOval(
              child: Image.network(
                AppConfig.mediaUrl(url),
                width: radius * 2,
                height: radius * 2,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => fallback,
              ),
            ),
    );
  }
}
