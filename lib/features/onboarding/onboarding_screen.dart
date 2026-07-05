import 'package:flutter/material.dart';

import '../../core/app_strings.dart';
import '../../ui/theme/luna_colors.dart';
import '../../ui/widgets/language_picker_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({
    super.key,
    required this.strings,
    required this.localeCode,
    required this.onSwitchLanguage,
    required this.onComplete,
  });

  final AppStrings strings;
  final String localeCode;
  final ValueChanged<String> onSwitchLanguage;
  final VoidCallback onComplete;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  AppStrings get s => widget.strings;

  List<({IconData icon, Color color, String title, String body})> get _slides => [
        (
          icon: Icons.lock_outline,
          color: C.primary,
          title: s.onboardingTitle1,
          body: s.onboardingBody1,
        ),
        (
          icon: Icons.visibility_off_outlined,
          color: C.purple,
          title: s.onboardingTitle2,
          body: s.onboardingBody2,
        ),
        (
          icon: Icons.water_drop_outlined,
          color: C.mint,
          title: s.onboardingTitle3,
          body: s.onboardingBody3,
        ),
      ];

  void _next() {
    if (_page >= _slides.length - 1) {
      widget.onComplete();
      return;
    }
    _controller.nextPage(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final slides = _slides;
    return Scaffold(
      backgroundColor: C.bg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  Text(
                    s.appName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: C.text,
                    ),
                  ),
                  const Spacer(),
                  LanguagePickerButton(
                    strings: s,
                    localeCode: widget.localeCode,
                    onSelected: widget.onSwitchLanguage,
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: slides.length,
                onPageChanged: (index) => setState(() => _page = index),
                itemBuilder: (context, index) {
                  final slide = slides[index];
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(28, 24, 28, 0),
                    child: Column(
                      children: [
                        const Spacer(flex: 2),
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: slide.color.withValues(alpha: .12),
                            borderRadius: BorderRadius.circular(36),
                          ),
                          child: Icon(slide.icon, size: 56, color: slide.color),
                        ),
                        const SizedBox(height: 36),
                        Text(
                          slide.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: C.text,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          slide.body,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            color: C.soft,
                            height: 1.45,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(flex: 3),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      slides.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: index == _page ? 22 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: index == _page ? C.primary : C.blush,
                          borderRadius: BorderRadius.circular(99),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: C.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: _next,
                      child: Text(
                        _page >= slides.length - 1
                            ? s.onboardingStart
                            : s.onboardingNext,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
