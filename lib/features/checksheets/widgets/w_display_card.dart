import 'package:flutter/material.dart';
import 'package:voice_poc/features/checksheets/constants/c_key_prompts.dart';
import 'package:voice_poc/features/checksheets/models/m_check_sheet.dart';
import 'package:voice_poc/features/record/widgets/w_record.dart';
import 'package:voice_poc/pages/03_pre_delivery/s_pre_delivery.dart';
import 'package:voice_poc/services/themes/constants/colors.dart';
import 'package:voice_poc/widgets/labels/w_label.dart';

class WDDisplayCheckListCard extends StatelessWidget {
  const WDDisplayCheckListCard(
      {super.key, required this.model, required this.service});
  final MCheckSheet model;
  final PreDeliveryServices service;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: service,
      builder: (context, child) => Padding(
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              WDLabel(label: model.gROUP ?? '-', isFlexible: true),

              //
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // When recording is enabled
                  if (service.isRecording && service.toCheck == model) ...[
                    WDRecord(),
                  ],

                  if (model.status == Keywords.passed.prompt) ...[
                    Icon(Icons.check_circle, color: AppColors.success.color),
                  ] else if (model.status == Keywords.failed.prompt) ...[
                    Icon(Icons.check_circle, color: AppColors.failure.color),
                  ] else if (model == service.toCheck) ...[
                    const Icon(Icons.mic),
                  ]
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
