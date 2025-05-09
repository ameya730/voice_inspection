import 'package:flutter/material.dart';
import 'package:voice_poc_other/widgets/labels/w_label.dart';

class InspectionTypeCard extends StatefulWidget {
  const InspectionTypeCard(
      {super.key, required this.heading, required this.onclick, required this.index});
  final String heading;
  final Function() onclick;
  final int index;

  @override
  State<InspectionTypeCard> createState() => _InspectionTypeCardState();
}

class _InspectionTypeCardState extends State<InspectionTypeCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onclick,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black.withOpacity(0.1)),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 10),),],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Theme.of(context).appBarTheme.backgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  widget.index.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: WDLabel(
                  label: widget.heading,
                  isExpanded: true,
                  textAlign: TextAlign.left,
                ),
              ),
              Icon(
                Icons.arrow_right,
                size: 26,
                color: Colors.black,
              ),
              const SizedBox(width: 10),
            ],
          ),
        ),
      ),
    );
  }
}
