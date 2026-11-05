import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../app/localization/l10n.dart';

/// Lets the user take or choose a photo. Returns the local file path, resized so
/// uploads stay small on mobile networks.
Future<String?> pickPhoto(BuildContext context) async {
  final l = context.l10n;
  final source = await showModalBottomSheet<ImageSource>(
    context: context,
    builder: (ctx) => SafeArea(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        ListTile(leading: const Icon(Icons.photo_library_outlined), title: Text(l.photoFromGallery), onTap: () => Navigator.pop(ctx, ImageSource.gallery)),
        ListTile(leading: const Icon(Icons.photo_camera_outlined), title: Text(l.photoFromCamera), onTap: () => Navigator.pop(ctx, ImageSource.camera)),
      ]),
    ),
  );
  if (source == null) return null;
  final file = await ImagePicker().pickImage(source: source, maxWidth: 1280, maxHeight: 1280, imageQuality: 85);
  return file?.path;
}
