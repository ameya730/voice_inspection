import 'package:audioplayers/audioplayers.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:timelines_plus/timelines_plus.dart';
import 'package:voice_poc/features/checksheets/constants/c_key_prompts.dart';
import 'package:voice_poc/features/checksheets/models/m_check_sheet.dart';
import 'package:voice_poc/features/checksheets/models/m_check_sheet_details.dart';
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
            border: Border(
              left: BorderSide(
                color: model.status == Keywords.passed.prompt
                    ? AppColors.success.color
                    : model.status == Keywords.failed.prompt
                        ? AppColors.failure.color
                        : model == service.toCheck
                            ? Colors.grey
                            : Colors.white,
                width: 10,
              ),
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          padding: const EdgeInsets.all(8),
          child: ExpandablePanel(
            theme: ExpandableThemeData(
              headerAlignment: ExpandablePanelHeaderAlignment.center,
            ),
            header: DisplayHeader(model: model, service: service),
            collapsed: const SizedBox(),
            expanded: DisplaySubDetails(model: model, service: service),
          ),
        ),
      ),
    );
  }
}

class DisplayHeader extends StatelessWidget {
  const DisplayHeader({
    super.key,
    required this.model,
    required this.service,
  });

  final MCheckSheet model;
  final PreDeliveryServices service;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        WDLabel(
          label: model.gROUP ?? '-',
          isFlexible: true,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: model.status != null ? Colors.grey : Colors.black,
              ),
        ),
        if (service.isRecordingVoice && service.toCheck == model) ...[
          Image.asset(
            'assets/gifs/sound_wave.gif',
            height: 32,
            fit: BoxFit.fitHeight,
          ),
        ] else if (model.recordedPath != null) ...[
          InkWell(
            onTap: () async {
              await AudioPlayer().play(DeviceFileSource(model.recordedPath!));
            },
            child: Icon(Icons.play_circle_outline, size: 32),
          ),
        ]
      ],
    );
  }
}

class DisplaySubDetails extends StatelessWidget {
  const DisplaySubDetails({
    super.key,
    required this.model,
    required this.service,
  });

  final MCheckSheet model;
  final PreDeliveryServices service;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: model.details?.length,
      itemBuilder: (context, index) {
        var e = model.details?[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0, right: 8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade50,
              border: Border(
                left: BorderSide(
                  color: e?.status == Keywords.passed.prompt
                      ? AppColors.success.color
                      : e?.status == Keywords.failed.prompt
                          ? AppColors.failure.color
                          : model == service.toCheck
                              ? Colors.grey
                              : Colors.white,
                  width: 10,
                ),
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            padding: const EdgeInsets.all(8),
            child: WDLabel(label: e?.gROUPDET ?? '-'),
          ),
        );
      },
    );
  }
}
