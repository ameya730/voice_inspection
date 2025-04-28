import 'package:flutter/material.dart';
import 'package:voice_poc_other/services/themes/constants/colors.dart';

class WDButtonWithLoad extends StatefulWidget {
  const WDButtonWithLoad({
    super.key,
    required this.label,
    required this.callback,
    this.isDisabled,
  });
  final String label;
  final Function() callback;
  final bool? isDisabled;

  @override
  State<WDButtonWithLoad> createState() => _WDButtonWithLoadState();
}

class _WDButtonWithLoadState extends State<WDButtonWithLoad> {
  bool isLoading = false;

  onClickFn() async {
    if (isLoading) return;

    if (widget.isDisabled == true) return;

    isLoading = true;
    if (mounted) setState(() {});
    await Future.delayed(
      const Duration(milliseconds: 200),
      () async => await widget.callback(),
    );
    isLoading = false;
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(
          isLoading || (widget.isDisabled == true)
              ? AppColors.disabled.color
              : AppColors.primary.color,
        ),
      ),
      onPressed: () => onClickFn(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.label, style: TextStyle(color: Colors.white)),
          if (isLoading) ...[
            const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator.adaptive(
                  backgroundColor: Colors.transparent,
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
