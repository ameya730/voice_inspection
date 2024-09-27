import 'package:flutter/material.dart';
import 'package:voice_poc/features/checksheets/models/m_check_sheet.dart';
import 'package:voice_poc/widgets/labels/w_label.dart';

class WDDisplayCheckListCard extends StatelessWidget {
  const WDDisplayCheckListCard({super.key, required this.model});
  final MCheckSheet model;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.grey.shade300,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            WDLabel(label: model.gROUP ?? '-'),
          ],
        ),
      ),
    );
  }
}
