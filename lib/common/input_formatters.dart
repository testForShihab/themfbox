import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class NoLeadingZeroInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.startsWith('0') && newValue.text.isNotEmpty) {
      return oldValue;
    }
    return newValue;
  }
}

class MaxValueFormatter extends TextInputFormatter {
  final double maxValue;
  final bool isDecimal;
  final bool isReadableInput;

  MaxValueFormatter(this.maxValue,
      {this.isDecimal = true, this.isReadableInput = false});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) return newValue;

    if (newValue.text.startsWith("00")) {
      return oldValue;
    }

    double? value = isReadableInput
        ? double.tryParse(newValue.text.split(',').join())
        : double.tryParse(newValue.text);

    if (value == null) {
      return oldValue;
    }

    if (value > maxValue) {
      if (!isDecimal) {
        return TextEditingValue(
          text: maxValue.round().toString(),
          selection: TextSelection.collapsed(
              offset: maxValue.round().toString().length),
        );
      }
      return TextEditingValue(
        text: maxValue.toString(),
        selection: TextSelection.collapsed(offset: maxValue.toString().length),
      );
    }

    return newValue;
  }
}

class SingleDecimalFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text;

    if (text.indexOf('.') != text.lastIndexOf('.')) {
      return oldValue;
    }

    if (text.contains('.')) {
      final parts = text.split('.');
      if (parts.length > 1 && parts[1].length > 1) {
        return oldValue;
      }
    }

    return newValue;
  }
}

class DoubleDecimalFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text;

    if (text.indexOf('.') != text.lastIndexOf('.')) {
      return oldValue;
    }
    if (text.contains('.')) {
      final parts = text.split('.');
      if (parts.length > 1 && parts[1].length > 2) {
        text = '${parts[0]}.${parts[1].substring(0, 2)}';
      }
    }
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

class SingleLeadingZeroFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text;

    if (text.startsWith('00')) {
      return oldValue;
    }

    return newValue;
  }
}

class ReadableNumberFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat.decimalPattern('en_IN');

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text.replaceAll(',', '');

    if (newText.isEmpty) {
      return newValue;
    }

    final number = num.tryParse(newText);
    if (number == null) {
      return oldValue;
    }

    final formatted = _formatter.format(number);

    int newCursorPosition =
        formatted.length - (newText.length - newValue.selection.baseOffset);

    if (newCursorPosition < 0) newCursorPosition = 0;
    if (newCursorPosition > formatted.length) {
      newCursorPosition = formatted.length;
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: newCursorPosition),
    );
  }
}
