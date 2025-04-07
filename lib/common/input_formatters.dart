import 'package:flutter/services.dart';

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

  MaxValueFormatter(this.maxValue, {this.isDecimal = true});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) return newValue;

    if (newValue.text.startsWith("00")) {
      return oldValue;
    }

    double? value = double.tryParse(newValue.text);

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
