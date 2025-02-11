import 'package:flutter/material.dart';
import 'package:meta_pipe/components/banner.dart';
import 'package:meta_pipe/components/output_panel.dart';
import 'package:meta_pipe/components/source_input_panel.dart';
import 'package:meta_pipe/global_state.dart';
import 'package:responsive_grid/responsive_grid.dart';

class ViewOfGenerationWithSource extends StatelessWidget {
  const ViewOfGenerationWithSource({super.key});

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
              child: GenerationBanner(functionText: 'Source'), // ***
            ),
          ),
          ResponsiveGridCol(
            xs: 12,
            md: 6,
            child: const Center(
              child: SourceInputPanel(),
            ),
          ),
          ResponsiveGridCol(
            xs: 12,
            md: 6,
            child: const OutputPanel(
              fetchFromWho: 'source',
              initImageURL: 'assets/images/init_source_output.png',
              initHelperURL: 'assets/images/init_source_picked.png',
              initMattedURL: 'assets/images/init_source_matted.png',
            ),
          ),
        ]),
      ],
    );
  }
}
