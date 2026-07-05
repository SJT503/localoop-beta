import 'package:flutter/material.dart';

import '../../../core/app_strings.dart';
import '../../../core/models/cycle_models.dart';
import '../../../core/storage/cycle_store.dart';
import '../../../ui/theme/luna_colors.dart';

class LogSheet extends StatefulWidget {
  const LogSheet({
    super.key,
    required this.store,
    required this.strings,
    required this.onSaved,
  });

  final CycleStore store;
  final AppStrings strings;
  final Future<void> Function() onSaved;

  @override
  State<LogSheet> createState() => _LogSheetState();
}

class _LogSheetState extends State<LogSheet> {
  late int step;
  late int flow;
  late double bbt;
  late String mood;
  late String note;
  late Set<String> symptoms;
  late Set<String> factors;
  late final TextEditingController _noteController;

  AppStrings get s => widget.strings;

  @override
  void initState() {
    super.initState();
    final record = widget.store.todayRecord;
    step = 0;
    flow = record.flow;
    bbt = record.bbt;
    mood = record.mood.isEmpty
        ? (s.moodOptions.isNotEmpty ? s.moodOptions.first : '')
        : s.normalizeMood(record.mood);
    note = record.note;
    symptoms = record.symptoms.map(s.normalizeSymptom).toSet();
    factors = record.factors.map(s.normalizeFactor).toSet();
    _noteController = TextEditingController(text: note);
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final titles = s.logStepTitles;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(22, 12, 22, 18),
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
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE7DDE2),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          titles[step],
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: C.text,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(s.logQuickHint,
                            style: const TextStyle(color: C.soft)),
                      ],
                    ),
                  ),
                  _pill('${step + 1}/5'),
                ],
              ),
              const SizedBox(height: 20),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                child: _stepContent(),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  if (step > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => setState(() => step--),
                        child: Text(s.logBack),
                      ),
                    ),
                  if (step > 0) const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: C.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      onPressed: _onNext,
                      child: Text(step < 4 ? s.logNext : s.logSave),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onNext() async {
    if (step < 4) {
      setState(() => step++);
      return;
    }
    await widget.store.saveRecord(
      DailyRecord(
        flow: flow,
        bbt: double.parse(bbt.toStringAsFixed(2)),
        mood: mood,
        symptoms: symptoms.toList(),
        factors: factors.toList(),
        note: note,
      ),
    );
    if (!mounted) return;
    await widget.onSaved();
  }

  Widget _stepContent() {
    switch (step) {
      case 0:
        return _flowPick();
      case 1:
        return _chipWrap(s.symptomOptions, symptoms);
      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(s.factorDisclaimer,
                style: const TextStyle(color: C.soft, fontSize: 12)),
            const SizedBox(height: 10),
            _chipWrap(s.factorOptions, factors),
          ],
        );
      case 3:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 10,
              children: s.moodOptions
                  .map(
                    (m) => ChoiceChip(
                      selected: mood == m,
                      label: Text(m),
                      onSelected: (_) => setState(() => mood = m),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 20),
            Text(
              s.bbtLabel(bbt),
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
            Slider(
              value: bbt,
              min: 35.8,
              max: 37.6,
              divisions: 36,
              activeColor: C.amber,
              onChanged: (v) => setState(() => bbt = v),
            ),
          ],
        );
      default:
        return TextField(
          key: const ValueKey('note'),
          controller: _noteController,
          minLines: 4,
          maxLines: 5,
          onChanged: (v) => note = v,
          decoration: InputDecoration(
            hintText: s.noteHint,
            filled: true,
            fillColor: const Color(0xFFFAF7F9),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
          ),
        );
    }
  }

  Widget _flowPick() {
    return Column(
      children: s.flowOptions.map((item) {
        final selected = flow == item.level;
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: InkWell(
            onTap: () => setState(() => flow = item.level),
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: selected ? C.blush : const Color(0xFFFAF7F9),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: selected ? C.primary : Colors.transparent,
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.water_drop, color: C.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: const TextStyle(fontWeight: FontWeight.w900),
                        ),
                        Text(
                          item.subtitle,
                          style: const TextStyle(color: C.soft),
                        ),
                      ],
                    ),
                  ),
                  if (selected)
                    const Icon(Icons.check_circle, color: C.primary),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _chipWrap(List<String> options, Set<String> selected) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: options
          .map(
            (label) => FilterChip(
              selected: selected.contains(label),
              showCheckmark: false,
              label: Text(label),
              selectedColor: C.blush,
              onSelected: (_) => setState(() {
                if (selected.contains(label)) {
                  selected.remove(label);
                } else {
                  selected.add(label);
                }
              }),
            ),
          )
          .toList(),
    );
  }

  Widget _pill(String text) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: C.blush,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: C.dark,
            fontWeight: FontWeight.w900,
            fontSize: 12,
          ),
        ),
      );
}
