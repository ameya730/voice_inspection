import 'package:flutter/material.dart';
import 'package:voice_poc/services/routes/c_routes.dart';
import 'package:voice_poc/widgets/labels/w_label.dart';

class InspectionTypeCard extends StatefulWidget {
  const InspectionTypeCard(
      {super.key, required this.heading, required this.onclick});
  final String heading;
  final Function() onclick;

  @override
  State<InspectionTypeCard> createState() => _InspectionTypeCardState();
}

class _InspectionTypeCardState extends State<InspectionTypeCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onclick,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              WDLabel(label: widget.heading, isFlexible: true),
              Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: Colors.black,
              )
            ],
          ),
        ),
      ),
    );
  }
}
