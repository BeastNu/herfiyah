import 'package:flutter/material.dart';

// =============================================================================
// OTP Code Field (حقل إدخال رمز التحقق)
//
// A 6-digit OTP input that consists of 6 separate square fields.
// As the user types a digit, focus automatically moves to the next field
// (or the previous field when deleting). This gives a smooth native feel
// similar to WhatsApp / Telegram OTP screens.
//
// ┌───┐ ┌───┐ ┌───┐ ┌───┐ ┌───┐ ┌───┐
// │ 1 │ │ 2 │ │ 3 │ │ 4 │ │ 5 │ │ 6 │
// └───┘ └───┘ └───┘ └───┘ └───┘ └───┘
// =============================================================================

/// A 6-digit OTP input with auto-advancing focus.
///
/// Example usage:
/// ```dart
/// OtpCodeField(
///   onCompleted: (code) => print('OTP entered: $code'),
///   onChanged: (partial) => print('Partial: $partial'),
/// )
/// ```
class OtpCodeField extends StatefulWidget {
  const OtpCodeField({
    super.key,
    this.onCompleted,
    this.onChanged,
    this.fieldCount = 6,
  });

  /// Called when all 6 digits have been entered.
  final ValueChanged<String>? onCompleted;

  /// Called after every keystroke with the current partial code.
  final ValueChanged<String>? onChanged;

  /// Number of OTP digits (default 6 — standard SMS OTP length).
  final int fieldCount;

  @override
  State<OtpCodeField> createState() => _OtpCodeFieldState();
}

class _OtpCodeFieldState extends State<OtpCodeField> {
  // We create a separate controller and focus node for each digit field.
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.fieldCount,
      (_) => TextEditingController(),
    );
    _focusNodes = List.generate(
      widget.fieldCount,
      (_) => FocusNode(),
    );
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  /// Return the concatenated code from all fields.
  String get _code =>
      _controllers.map((c) => c.text).join();

  /// Move focus to the field at [index], or unfocus all if out of range.
  void _focusField(int index) {
    if (index >= 0 && index < widget.fieldCount) {
      _focusNodes[index].requestFocus();
    } else {
      _focusNodes[widget.fieldCount - 1].unfocus();
    }
  }

  /// Called when the text in field [index] changes.
  void _onFieldChanged(int index, String value) {
    // Only allow a single digit per field.
    if (value.length > 1) {
      // If the user pastes multiple digits, distribute them.
      for (int i = 0; i < value.length && index + i < widget.fieldCount; i++) {
        _controllers[index + i].text = value[i];
      }
      _focusField(index + value.length);
    } else if (value.isNotEmpty) {
      // Single digit entered → move to next field.
      _focusField(index + 1);
    }

    // Notify parent of every change.
    widget.onChanged?.call(_code);

    // If all fields are filled, call onCompleted.
    if (_code.length == widget.fieldCount) {
      widget.onCompleted?.call(_code);
    }
  }

  /// Handle backspace — delete digit and move to previous field.
  void _onFieldSubmitted(int index) {
    // Empty — not used; we handle navigation via onChanged.
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Directionality(
      // The OTP fields should read left-to-right so digits display correctly,
      // even though the surrounding screen is RTL.
      textDirection: TextDirection.ltr,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(widget.fieldCount, (index) {
          return Padding(
            padding: EdgeInsetsDirectional.only(
              end: index < widget.fieldCount - 1 ? 8 : 0,
            ),
            child: SizedBox(
              width: 52,
              height: 58,
              child: TextField(
                controller: _controllers[index],
                focusNode: _focusNodes[index],
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 1, // Only one digit per field.
                buildCounter: (_, {required currentLength, required isFocused, maxLength}) =>
                    null, // Hide the character counter.
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
                decoration: InputDecoration(
                  counterText: '',
                  filled: true,
                  fillColor: theme.inputDecorationTheme.fillColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: theme.colorScheme.outline.withValues(alpha: 0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: theme.colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 14,
                  ),
                ),
                onChanged: (value) => _onFieldChanged(index, value),
                // Handle backspace/delete when field is empty.
                onKeyEvent: (node, event) {
                  if (event is KeyDownEvent &&
                      event.logicalKey == LogicalKeyboardKey.backspace &&
                      _controllers[index].text.isEmpty &&
                      index > 0) {
                    _focusField(index - 1);
                    _controllers[index - 1].clear();
                  }
                  return KeyEventResult.ignored;
                },
              ),
            ),
          );
        }),
      ),
    );
  }
}