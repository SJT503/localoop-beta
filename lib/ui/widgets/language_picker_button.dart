import 'package:flutter/material.dart';

import '../../core/app_strings.dart';
import '../../core/l10n/supported_locales.dart';
import '../theme/luna_colors.dart';

class LanguagePickerButton extends StatelessWidget {
  const LanguagePickerButton({
    super.key,
    required this.strings,
    required this.localeCode,
    required this.onSelected,
    this.iconColor = C.text,
  });

  final AppStrings strings;
  final String localeCode;
  final ValueChanged<String> onSelected;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final current = normalizeLocaleCode(localeCode);
    return PopupMenuButton<String>(
      tooltip: strings.language,
      icon: Icon(Icons.language, color: iconColor),
      initialValue: current,
      onSelected: onSelected,
      itemBuilder: (context) => supportedLocales
          .map(
            (locale) => PopupMenuItem<String>(
              value: locale.code,
              child: Row(
                children: [
                  SizedBox(
                    width: 22,
                    child: locale.code == current
                        ? Icon(Icons.check, size: 18, color: C.primary)
                        : null,
                  ),
                  Text(locale.label),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
