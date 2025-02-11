import 'package:flutter/material.dart';
import 'package:meta_pipe/components/banner.dart';
import 'package:meta_pipe/components/context_input_panel.dart';
import 'package:meta_pipe/components/output_panel.dart';
import 'package:meta_pipe/global_state.dart';
import 'package:responsive_grid/responsive_grid.dart';

class ViewOfGenerationWithContext extends StatelessWidget {
  final double sizeOfOutterIcon = 20;
  // bool _isLoading = true;

  const ViewOfGenerationWithContext({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: getResponsivePadding(getCondition(context: context)),
      children: [
        ResponsiveGridRow(children: [
          ResponsiveGridCol(
            xs: 12,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: GenerationBanner(functionText: 'Context'), // ***
            ),
          ),
          ResponsiveGridCol(
            xs: 12,
            md: 6,
            child: ContextInputPanel(sizeOfOutterIcon: sizeOfOutterIcon),
          ),
          ResponsiveGridCol(
            xs: 12,
            md: 6,
            child: const OutputPanel(
              fetchFromWho: 'context',
              initImageURL: 'assets/images/init_context_output.png',
              initHelperURL: 'assets/images/init_context_helper.png',
              initMattedURL: 'assets/images/init_context_matted.png',
            ),
          ),
        ]),
      ],
    );
  }
}
