import 'package:flutter/material.dart';

import '../../../core/app_strings.dart';
import '../../../core/models/cycle_models.dart';
import '../../../ui/theme/luna_colors.dart';

class ProfileSheet extends StatefulWidget {
  const ProfileSheet({
    super.key,
    required this.initial,
    required this.isFirstSetup,
    required this.strings,
    required this.onSave,
  });

  final CycleProfile initial;
  final bool isFirstSetup;
  final AppStrings strings;
  final Future<void> Function(CycleProfile profile) onSave;

  @override
  State<ProfileSheet> createState() => _ProfileSheetState();
}

class _ProfileSheetState extends State<ProfileSheet> {
  late CycleProfile draft;
  late final TextEditingController _startController;
  late final TextEditingController _cycleController;
  late final TextEditingController _periodController;
  late final TextEditingController _cyclesController;
  late final TextEditingController _varianceController;

  AppStrings get s => widget.strings;

  @override
  void initState() {
    super.initState();
    draft = widget.initial.copyWith(
      goal: widget.strings.normalizeGoal(widget.initial.goal),
    );
    _startController = TextEditingController(text: draft.lastPeriodStart);
    _cycleController = TextEditingController(text: '${draft.cycleLength}');
    _periodController = TextEditingController(text: '${draft.periodLength}');
    _cyclesController = TextEditingController(text: '${draft.cycles}');
    _varianceController = TextEditingController(text: '${draft.variance}');
  }

  @override
  void dispose() {
    _startController.dispose();
    _cycleController.dispose();
    _periodController.dispose();
    _cyclesController.dispose();
    _varianceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              Text(
                widget.isFirstSetup ? s.profileCreateTitle : s.profileEditTitle,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: C.text,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                widget.isFirstSetup
                    ? s.profileCreateSubtitle
                    : s.profileEditSubtitle,
                style: const TextStyle(color: C.soft),
              ),
              const SizedBox(height: 16),
              Text(s.goalLabel,
                  style: const TextStyle(color: C.soft, fontSize: 12)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: s.goalOptions.map((goal) {
                  final selected = draft.goal == goal;
                  return ChoiceChip(
                    selected: selected,
                    label: Text(goal),
                    selectedColor: C.blush,
                    onSelected: (_) => setState(() {
                      draft = draft.copyWith(goal: goal);
                    }),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              _field(s.profileLastPeriodStart, _startController, (v) {
                draft = draft.copyWith(lastPeriodStart: v);
              }),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _numberField(s.profileCycleLength, _cycleController, (v) {
                      draft = draft.copyWith(cycleLength: v);
                    }),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _numberField(s.profilePeriodLength, _periodController, (v) {
                      draft = draft.copyWith(periodLength: v);
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _numberField(s.profileCyclesRecorded, _cyclesController, (v) {
                      draft = draft.copyWith(cycles: v);
                    }),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _numberField(s.profileVariance, _varianceController, (v) {
                      draft = draft.copyWith(variance: v);
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: C.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  onPressed: () async {
                    await widget.onSave(draft);
                    if (!context.mounted) return;
                    Navigator.pop(context);
                  },
                  child: Text(
                    widget.isFirstSetup ? s.profileSave : s.profileUpdate,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController controller,
    ValueChanged<String> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: C.soft, fontSize: 12)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          onChanged: onChanged,
          decoration: _inputDecoration(),
        ),
      ],
    );
  }

  Widget _numberField(
    String label,
    TextEditingController controller,
    ValueChanged<int> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: C.soft, fontSize: 12)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          onChanged: (text) {
            final parsed = int.tryParse(text);
            if (parsed != null) onChanged(parsed);
          },
          decoration: _inputDecoration(),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration() => InputDecoration(
        filled: true,
        fillColor: const Color(0xFFFAF7F9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      );
}
