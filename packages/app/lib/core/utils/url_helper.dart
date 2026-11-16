import 'dart:js_interop';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

@JS('window.open')
external void _jsWindowOpen(JSString url, JSString target);

void openExternalUrl(BuildContext context, String url, {String? title}) {
  Clipboard.setData(ClipboardData(text: url));

  if (kIsWeb) {
    try {
      _jsWindowOpen(url.toJS, '_blank'.toJS);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Abriendo ${title ?? "enlace oficial"} en una nueva pestaña...'),
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    } catch (_) {}
  }

  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.open_in_browser_rounded, color: Color(0xFFC62828)),
          const SizedBox(width: 10),
          Expanded(child: Text(title ?? 'Catálogo Oficial del Museo', style: const TextStyle(fontSize: 16))),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Accede a la ficha oficial directamente en la web de la institución:'),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.04),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.black12),
            ),
            child: SelectableText(
              url,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12, color: Color(0xFF1565C0)),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Enlace copiado al portapapeles. Pégalo en tu navegador para ver la obra en su contexto oficial.',
            style: TextStyle(fontSize: 11.5, color: Colors.grey),
          ),
        ],
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Entendido'),
        ),
      ],
    ),
  );
}
