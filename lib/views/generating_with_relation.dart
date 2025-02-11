import 'package:flutter/material.dart';
import 'package:meta_pipe/components/banner.dart';
import 'package:meta_pipe/components/output_panel.dart';
import 'package:meta_pipe/components/relation_input_panel.dart';
import 'package:meta_pipe/global_state.dart';
import 'package:responsive_grid/responsive_grid.dart';

class ViewOfGenerationWithRelation extends StatelessWidget {
  const ViewOfGenerationWithRelation({super.key});

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
              child: GenerationBanner(functionText: 'Relation'), // ***
            ),
          ),
          ResponsiveGridCol(
            xs: 12,
            md: 6,
            child: const RelationInputPanel(),
          ),
          ResponsiveGridCol(
            xs: 12,
            md: 6,
            child: const OutputPanel(
              fetchFromWho: 'relation',
              initImageURL: 'assets/images/init_relation_output.png',
              initHelperURL: 'assets/images/init_relation_text.png',
              initMattedURL: 'assets/images/init_relation_matted.png',
            ),
          ),
        ]),
      ],
    );
  }
}
