import 'package:flutter/material.dart';

import '../../../core/app_strings.dart';
import '../../../core/models/cycle_models.dart';
import '../../../ui/theme/luna_colors.dart';

class RecordDetailSheet extends StatelessWidget {
  const RecordDetailSheet({
    super.key,
    required this.dateKey,
    required this.record,
    required this.strings,
    required this.onEdit,
  });

  final String dateKey;
  final DailyRecord record;
  final AppStrings strings;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final title = strings.formatDateKey(dateKey);
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 12, 22, 18),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$title',
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: C.text)),
              const SizedBox(height: 12),
              _row(Icons.water_drop, strings.flowLabel(record.flow)),
              _row(Icons.mood, strings.normalizeMood(record.mood)),
              _row(Icons.thermostat, strings.bbtLabel(record.bbt)),
              _row(
                Icons.healing,
                record.symptoms.isEmpty
                    ? strings.none
                    : strings.listJoin(
                        record.symptoms.map(strings.normalizeSymptom),
                      ),
              ),
              _row(
                Icons.local_fire_department,
                record.factors.isEmpty
                    ? strings.none
                    : strings.listJoin(
                        record.factors.map(strings.normalizeFactor),
                      ),
              ),
              if (record.note.isNotEmpty) _row(Icons.notes, record.note),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: C.primary,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    onEdit();
                  },
                  child: Text(strings.edit),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(IconData icon, String text) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: C.primary, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(text,
                  style: const TextStyle(
                      color: C.text, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      );
}

void showRecordDetailSheet({
  required BuildContext context,
  required String dateKey,
  required DailyRecord? record,
  required AppStrings strings,
  required VoidCallback onEdit,
}) {
  if (record == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(strings.noLogThisDay)),
    );
    return;
  }
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (_) => RecordDetailSheet(
      dateKey: dateKey,
      record: record,
      strings: strings,
      onEdit: onEdit,
    ),
  );
}
