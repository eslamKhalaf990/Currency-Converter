import 'package:flutter/material.dart';

import '../../../../core/theme/dimens.dart';

class CurrencyDropdown extends StatelessWidget {
  final String title;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const CurrencyDropdown({
    super.key,
    required this.title,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      initialValue: value,
      onSelected: onChanged,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.radiusM),
      ),
      itemBuilder: (context) {
        return items.map((String currency) {
          return PopupMenuItem<String>(
            value: currency,
            child: Text(currency), // Just the code
          );
        }).toList();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: Dimens.spacingL,
          horizontal: Dimens.spacingM,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(Dimens.radiusM),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: Dimens.spacingM),
            Text(
              value,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: Dimens.spacingS),
            const Icon(Icons.keyboard_arrow_down, color: Colors.black),
            // Removed the currency name bottom text completely here
          ],
        ),
      ),
    );
  }
}
