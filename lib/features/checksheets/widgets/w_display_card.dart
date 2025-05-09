import 'package:audioplayers/audioplayers.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:voice_poc_other/features/checksheets/constants/c_key_prompts.dart';
import 'package:voice_poc_other/features/checksheets/models/m_check_sheet.dart';
import 'package:voice_poc_other/features/checksheets/models/m_check_sheet_details.dart';
import 'package:voice_poc_other/pages/03_pre_delivery/s_pre_delivery.dart';
import 'package:voice_poc_other/services/themes/constants/colors.dart';
import 'package:voice_poc_other/widgets/labels/w_label.dart';

class WDDisplayCheckListCard extends StatefulWidget {
  const WDDisplayCheckListCard(
      {super.key, required this.model, required this.service});
  final MCheckSheet model;
  final PreDeliveryServices service;

  @override
  State<WDDisplayCheckListCard> createState() => _WDDisplayCheckListCardState();
}

class _WDDisplayCheckListCardState extends State<WDDisplayCheckListCard> {
  final ExpandableController _controller = ExpandableController();

  @override
  void initState() {
    widget.service.addListener(
      () {
        if (widget.service.toCheck == widget.model) {
          if (widget.service.toCheck?.status == 'rejected') {
            _controller.expanded = true;
            if (mounted) setState(() {});
          }
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.service,
      builder: (context, child) => Padding(
        padding: const EdgeInsets.all(8),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 10),
              ),
            ],
            border: Border(
              left: BorderSide(
                color: widget.model.status == Keywords.passed.prompt
                    ? AppColors.success.color
                    : widget.model.status == Keywords.failed.prompt
                        ? AppColors.failure.color
                        : widget.model == widget.service.toCheck
                            ? Colors.grey
                            : Colors.black.withOpacity(0.1),
                width: 10,
              ),
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          padding: const EdgeInsets.all(8),
          child: ExpandablePanel(
            controller: _controller,
            theme: ExpandableThemeData(
              headerAlignment: ExpandablePanelHeaderAlignment.center,
            ),
            header: DisplayHeader(model: widget.model, service: widget.service),
            collapsed: const SizedBox(),
            expanded: DisplaySubDetails(
              model: widget.model,
              service: widget.service,
            ),
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
        return SubDetailsCard(e: e, model: model, service: service);
      },
    );
  }
}

class SubDetailsCard extends StatelessWidget {
  const SubDetailsCard({
    super.key,
    required this.e,
    required this.model,
    required this.service,
  });

  final CheckSheetDetails? e;
  final MCheckSheet model;
  final PreDeliveryServices service;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, right: 8.0, top: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.teal.shade50,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            WDLabel(label: e?.gROUPDET ?? '-'),
            if (e?.recordedPath != null) ...[
              InkWell(
                onTap: () async {
                  await AudioPlayer()
                      .play(DeviceFileSource(e?.recordedPath ?? '-'));
                },
                child: Icon(Icons.play_circle_outline, size: 32),   
              ),
            ],
          ],
        ),
      ),
    );
  }
}
