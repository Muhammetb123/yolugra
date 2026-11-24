import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/localization/l10n.dart';
import '../config/app_config.dart';
import 'feedback.dart';

/// The legal pages of the public site. The name is the page's file name there.
enum SitePage { terms, privacy }

/// Opens [page] of the public site in the browser, in the app language.
Future<void> openSitePage(BuildContext context, SitePage page, {String siteUrl = AppConfig.websiteUrl}) async {
  final uri = AppConfig.sitePage(page.name, context.languageCode, base: siteUrl);
  if (uri == null) return;
  var opened = false;
  try {
    opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
  } catch (_) {
    // No browser on the device.
  }
  if (!opened && context.mounted) showMessage(context, context.l10n.linkOpenError);
}

/// Links to the terms of use and the privacy policy. Renders nothing in a build
/// without a site address (see [AppConfig.websiteUrl]).
class LegalLinks extends StatelessWidget {
  const LegalLinks({super.key, this.compact = false, this.siteUrl = AppConfig.websiteUrl});

  /// Two small text links on one line instead of list rows.
  final bool compact;

  /// The site address; only tests pass another one.
  final String siteUrl;

  @override
  Widget build(BuildContext context) {
    if (siteUrl.isEmpty) return const SizedBox.shrink();
    final l = context.l10n;
    final pages = [(SitePage.terms, l.legalTerms), (SitePage.privacy, l.legalPrivacy)];
    if (compact) {
      final style = TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: const Size(0, 32),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700),
      );
      return Wrap(
        spacing: 16,
        children: [
          for (final (page, label) in pages)
            TextButton(style: style, onPressed: () => openSitePage(context, page, siteUrl: siteUrl), child: Text(label)),
        ],
      );
    }
    return Column(children: [
      for (final (page, label) in pages)
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(label),
          trailing: const Icon(Icons.open_in_new_rounded, size: 20),
          onTap: () => openSitePage(context, page, siteUrl: siteUrl),
        ),
    ]);
  }
}
