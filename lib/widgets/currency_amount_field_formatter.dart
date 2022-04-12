import 'package:breez/bloc/account/fiat_conversion.dart';
import 'package:flutter/services.dart';

class CurrencyAmountFieldFormatter extends TextInputFormatter {
  final FiatConversion fiatConversion;

  CurrencyAmountFieldFormatter(
    this.fiatConversion,
  );

  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final currencyData = fiatConversion.currencyData;
    final symbol = currencyData.symbol;
    final rightSideSymbol = currencyData.rightSideSymbol;
    final newText = newValue.text;
    final raw = newText.replaceAll(RegExp("[^0-9.]"), "");

    if (raw.isEmpty) {
      return TextEditingValue(
        text: symbol,
        selection: TextSelection.collapsed(
          offset: rightSideSymbol ? 0 : symbol.length,
        ),
      );
    }

    try {
      double.parse(raw);
    } catch (_) {
      return oldValue;
    }

    if (raw.contains(".")) {
      if (raw.split(".").last.length > currencyData.fractionSize) {
        return oldValue;
      }
    }

    final formatted = rightSideSymbol ? "$raw $symbol" : "$symbol $raw";
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(
        offset: rightSideSymbol
            ? formatted.length - symbol.length - 1
            : formatted.length,
      ),
    );
  }
}
