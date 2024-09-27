import 'package:flutter/material.dart';
import 'package:voice_poc/features/checksheets/widgets/w_display_card.dart';
import 'package:voice_poc/pages/02_home/s_home.dart';
import 'package:voice_poc/widgets/buttons/button_with_loader.dart';

class PageHome extends StatefulWidget {
  const PageHome({super.key});

  @override
  State<PageHome> createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {
  final service = HomeServices();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => setup());
    super.initState();
  }

  setup() async => service.getCheckList('00JU0AZZ');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Speech Demo')),
      body: ListenableBuilder(
        listenable: service,
        builder: (context, child) => ListView(
          children: service.checkList
              .map(
                (e) => InkWell(
                  onTap: () => service.setToCheck = e,
                  child: WDDisplayCheckListCard(model: e),
                ),
              )
              .toList(),
        ),
      ),
      floatingActionButton: WDButtonWithLoad(
        label: 'Scan VIN',
        callback: setup,
      ),
    );
  }
}
