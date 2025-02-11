import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttericon/elusive_icons.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:meta_pipe/components/flow_button.dart';
import 'package:meta_pipe/components/custom_text_field.dart';
import 'package:meta_pipe/components/history_cards.dart';
import 'package:meta_pipe/global_state.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class RelationInputPanel extends StatefulWidget {
  final List<Icon>? outterIcon;
  const RelationInputPanel({
    super.key,
    this.outterIcon,
  });

  @override
  State<StatefulWidget> createState() => _ContextInputPanelState();
}

class _ContextInputPanelState extends State<RelationInputPanel> {
  TextEditingController targetController = TextEditingController();
  TextEditingController relationController = TextEditingController();
  GlobalState? globalState;

  @override
  void initState() {
    super.initState();

    targetController.text =
        Provider.of<GlobalState>(context, listen: false).relationTarget;

    targetController.addListener(() {
      setState(() {
        Provider.of<GlobalState>(context, listen: false).relationTarget =
            targetController.text;
      });
    });

    relationController.text =
        Provider.of<GlobalState>(context, listen: false).relationRelation;
    relationController.addListener(() {
      setState(() {
        Provider.of<GlobalState>(context, listen: false).relationRelation =
            relationController.text;
      });
    });
  }

  Future<void> fetchVE() async {
    buildGlobalLoadingBar(context);
    GlobalState globalState = Provider.of<GlobalState>(context, listen: false);
    try {
      final Map<String, dynamic> requestBody = {
        'relation': globalState.relationRelation,
        'target': globalState.relationTarget,
      };

      final response = await http.post(
          Uri.parse('$hostBase/relation/elaboration'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(requestBody));
      if (response.statusCode == 200) {
        final resBody = jsonDecode(response.body);
        debugPrint(response.body);
        if (resBody['error'] != null) throw "server error";
        setState(() {
          globalState.addVisualElaborationItem(VisualElaboration(
              title: resBody['title'], content: resBody['content']));
        });
      } else {
        throw 'Failed to load image';
      }
    } catch (e) {
      showToast('Error: $e');
    } finally {
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  List<Widget> buildTextFields() {
    return [
      Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: ComplexTextField(
          controller: relationController,
          label: "What's aspect you highlight?",
          hint: "An adjective",
          prefixIcon: const Icon(FontAwesome.magic),
          outterIcon: const Icon(
            Icons.keyboard_alt_outlined,
            color: Colors.black26,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 0),
        child: ComplexTextField(
          controller: targetController,
          label: "What's the subject in design?",
          hint: "Always nuons",
          prefixIcon: const Icon(Elusive.target),
          outterIcon: const Icon(
            Icons.keyboard_alt_outlined,
            color: Colors.black26,
          ),
        ),
      ),
    ];
  }

  void onChangeHistoryCardsGroupValue(v) {
    setState(() => Provider.of<GlobalState>(context, listen: false)
        .historyCardsGroupValue = v);
  }

  @override
  Widget build(BuildContext context) {
    List<VisualElaboration> visualElaborationList =
        Provider.of<GlobalState>(context, listen: false).visualElaborationList;
    int selectedIdx =
        Provider.of<GlobalState>(context, listen: false).historyCardsGroupValue;
    return Column(children: [
      ...buildTextFields(),
      FlowButton(
        handlePress: fetchVE,
        displayIcon: const Icon(FontAwesome5.arrow_down),
        padding: const EdgeInsets.symmetric(vertical: 15),
        btnColor: ThemeData().colorScheme.secondary,
      ),
      HistoryCardList(
        selectingName:
            'No.$selectedIdx, ${visualElaborationList[selectedIdx].title}',
        cardItems: visualElaborationList
            .asMap()
            .entries
            .map((e) => HistoryCardItem(
                  title: e.value.title,
                  content: e.value.content,
                  idx: e.key,
                  handleOnchange: onChangeHistoryCardsGroupValue,
                ))
            .toList(),
      ),
    ]);
  }
}
