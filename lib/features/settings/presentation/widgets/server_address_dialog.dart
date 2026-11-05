import 'package:flutter/material.dart';

import '../../../../app/localization/l10n.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/config/server_address.dart';
import '../../../../core/widgets/feedback.dart';
import '../../../../init/dependency_injection.dart';

/// Lets a test build point at another backend. Resolves to true when the address changed.
Future<bool> showServerAddressDialog(BuildContext context) async {
  final changed = await showDialog<bool>(context: context, builder: (_) => const _ServerAddressDialog());
  if ((changed ?? false) && context.mounted) showMessage(context, context.l10n.serverSaved);
  return changed ?? false;
}

class _ServerAddressDialog extends StatefulWidget {
  const _ServerAddressDialog();

  @override
  State<_ServerAddressDialog> createState() => _ServerAddressDialogState();
}

class _ServerAddressDialogState extends State<_ServerAddressDialog> {
  final _address = sl<ServerAddress>();
  late final _text = TextEditingController(text: _address.current);
  bool _checking = false;
  bool? _reachable;
  String? _error;

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  String? _parse() {
    final url = ServerAddress.normalize(_text.text);
    setState(() => _error = url == null ? context.l10n.serverInvalid : null);
    return url;
  }

  Future<void> _check() async {
    final url = _parse();
    if (url == null) return;
    setState(() {
      _checking = true;
      _reachable = null;
    });
    final ok = await ServerAddress.reachable(url);
    if (mounted) {
      setState(() {
        _checking = false;
        _reachable = ok;
      });
    }
  }

  Future<void> _save(String? url) async {
    final before = _address.current;
    await _address.set(url);
    if (mounted) Navigator.pop(context, _address.current != before);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final url = ServerAddress.normalize(_text.text) ?? _text.text;
    return AlertDialog(
      title: Text(l.serverTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.serverNote, style: theme.textTheme.bodySmall),
          const SizedBox(height: 12),
          TextField(
            controller: _text,
            keyboardType: TextInputType.url,
            autocorrect: false,
            decoration: InputDecoration(hintText: l.serverHint, errorText: _error),
            onChanged: (_) => setState(() => _reachable = null),
          ),
          const SizedBox(height: 8),
          Row(children: [
            TextButton.icon(
              onPressed: _checking ? null : _check,
              icon: _checking
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.wifi_tethering_rounded),
              label: Text(l.serverCheck),
            ),
          ]),
          if (_reachable != null)
            Text(
              _reachable! ? l.serverReachable : l.serverUnreachable(url),
              style: theme.textTheme.bodySmall?.copyWith(color: _reachable! ? theme.colorScheme.primary : theme.colorScheme.error),
            ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => _save(null), child: Text('${l.serverReset} (${AppConfig.buildApiBaseUrl})')),
        TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l.commonCancel)),
        FilledButton(
          style: FilledButton.styleFrom(minimumSize: const Size(0, 44)),
          onPressed: () {
            final parsed = _parse();
            if (parsed != null) _save(parsed);
          },
          child: Text(l.commonSave),
        ),
      ],
    );
  }
}
