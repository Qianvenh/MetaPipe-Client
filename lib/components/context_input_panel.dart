import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/rpg_awesome_icons.dart';
import 'package:meta_pipe/components/editable_table.dart';
import 'package:meta_pipe/components/flow_button.dart';
import 'package:meta_pipe/components/custom_text_field.dart';
import 'package:meta_pipe/components/dropdown_menu_node.dart';
import 'package:meta_pipe/global_state.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class ContextInputPanel extends StatefulWidget {
  final List<Icon>? outterIcon;
  final double sizeOfOutterIcon;
  const ContextInputPanel({
    super.key,
    this.outterIcon,
    required this.sizeOfOutterIcon,
  });

  @override
  State<ContextInputPanel> createState() => _ContextInputPanelState();
}

class _ContextInputPanelState extends State<ContextInputPanel> {
  final List<String> scenes = [
    '*Random',
    'Bamboo forest',
    'Jungle',
    'Glacier',
    'Spacehip interior',
    'Space out of earth',
    'Sky',
    'Deep sea',
    'Sea waves',
    'The Surface of Moon',
    'The Surface of Mars',
    'Beach',
    'Beach at Night',
    'Park',
    'Autumn Pathway',
    'Lake',
    'Volcano',
    'Windmill Field',
    'Lavender Field',
    'Starry Night Sky',
    'Cherry Blossom Trees',
    'Canyon',
    'Sunset',
    'Sunrise',
    'Arena',
    'Football field',
    'Dinning room',
    'Winter Streetscape',
    'Swimming pool',
    'Gym',
    'Stage',
    'Classroom',
    'Campus',
    'Prairie',
    'Garden',
    'Desert',
    'Wildflower Field',
    'Rainy Street',
    'Old Bridge',
    'Desert Oasis',
    'City Rooftops',
    'Countryside',
    'Mountain',
    'Plateau',
    'Supermarket',
    'Skyline',
    'Old Town',
    'Waterfall',
    'Meadow',
    'Snowy Landscape',
    'Middle Ages',
    'Future',
    'Post-Apocalyptic Urban Landscape',
  ];

  final String layoutURL = 'assets/images/init_context_layout.png';

  final TextEditingController _targetController = TextEditingController();

  List<TextEditingController>? boxesPosControllers;

  @override
  void initState() {
    super.initState();

    _targetController.text =
        Provider.of<GlobalState>(context, listen: false).contextTarget;
    _targetController.addListener(() {
      setState(() {
        Provider.of<GlobalState>(context, listen: false).contextTarget =
            _targetController.text;
      });
    });
  }

  double getFitalbeFontSize(double screenWidth) {
    return screenWidth > 905 ? 28 : 16;
  }

  Future<void> Function() getFetchLayout(bool retry) {
    GlobalState globalState = Provider.of<GlobalState>(context, listen: false);
    late final String requestLayoutURL;
    late final String requestBody;
    if (retry) {
      requestLayoutURL = '$hostBase/context/relayout';
      requestBody = globalState.contextLayoutInfo;
    } else {
      requestLayoutURL = '$hostBase/context/layout';
      String context = globalState.contextContext;
      if (context == '*Random') {
        context = scenes[Random().nextInt(scenes.length)];
      }
      late final Map<String, dynamic> requestBodyJSON = {
        'target': globalState.contextTarget,
        'context': context,
      };
      requestBody = jsonEncode(requestBodyJSON);
    }
    return () async {
      if (!retry) {
        buildGlobalLoadingBar(context);
      }
      try {
        final response = await http.post(Uri.parse(requestLayoutURL),
            headers: {'Content-Type': 'application/json'}, body: requestBody);
        if (response.statusCode == 200) {
          if (jsonDecode(response.body)['error'] != null) throw "server error";
          final String layoutNewURL = jsonDecode(response.body)['layout_url'];
          setState(() {
            globalState.contextLayoutImageUrl = layoutNewURL;
            globalState.contextLayoutInfo = response.body;
          });
        } else {
          throw 'Failed to load image';
        }
        showToast('Success');
      } catch (e) {
        if (retry) {
          throw 'Error: $e';
        } else {
          showToast('Error: $e');
        }
      } finally {
        if (mounted && !retry) {
          Navigator.of(context).pop();
        }
      }
    };
  }

  Future<void> updateLayout() async {
    buildGlobalLoadingBar(context);
    String layoutInfo =
        Provider.of<GlobalState>(context, listen: false).contextLayoutInfo;
    final layoutJSON = jsonDecode(layoutInfo);
    final List<dynamic> boxesData = layoutJSON['boxes'];
    try {
      String boxesEncoded = '''{"boxes":[''';
      for (int i = 0; i < boxesPosControllers!.length; i++) {
        String boxDataStr = boxesPosControllers![i].text;
        if (boxDataStr[0] != '[' || boxDataStr[boxDataStr.length - 1] != ']') {
          throw 'Not a List';
        } else {
          boxDataStr = boxDataStr.replaceAll('[', '').replaceAll(']', '');
          List<int> boxDataInt =
              boxDataStr.split(',').map((e) => int.parse(e.trim())).toList();
          if (boxDataInt.length != 4) throw "Some data missing";
          final int x1 = boxDataInt[0];
          final int y1 = boxDataInt[1];
          final int x2 = boxDataInt[2];
          final int y2 = boxDataInt[3];
          if (x1 < 0 || x1 > 512 || y1 < 0 || y1 > 512) throw "Top-Left position isn't correct";
          if (x2 < 0 || x2 > 512 || y2 < 0 || y2 > 512) throw "Bottom-Right position isn't correct";
          if (x1 > x2 || y1 > y2) throw "Positions aren't correct";
        }

        String boxItemStr =
            '''["${boxesData[i][0]}",${boxesPosControllers![i].text}]''';
        if (i != boxesPosControllers!.length - 1) {
          boxItemStr += ',';
        }
        boxesEncoded += boxItemStr;
      }
      boxesEncoded += "]}";

      final newBoxesJSON = jsonDecode(boxesEncoded);
      layoutJSON['boxes'] = newBoxesJSON['boxes'];
      debugPrint('${layoutJSON['boxes']}');
      setState(() {
        Provider.of<GlobalState>(context, listen: false).contextLayoutInfo =
            jsonEncode(layoutJSON);
      });
      await getFetchLayout(true)();
      showToast('Success');
    } catch (e) {
      showToast('$e');
    } finally {
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  Widget buildTextField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: ComplexTextField(
        controller: _targetController,
        label: "Juxtaposing Objects",
        hint: "Split given items by half-width comma",
        prefixIcon: const Icon(FontAwesome5.lightbulb),
        outterIcon: const Icon(
          Icons.keyboard_alt_outlined,
          color: Colors.black26,
        ),
      ),
    );
  }

  Widget buildDropdownMenu() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0),
      child: DropdownMenuNode(
        data: scenes,
        initialSelection:
            Provider.of<GlobalState>(context, listen: false).contextContext,
        label: 'In a Scene of: ',
        leadingIcon: const Icon(RpgAwesome.palm_tree),
        outterIcon: Icon(
          FontAwesome5.list_ul,
          size: widget.sizeOfOutterIcon,
          color: Colors.black26,
        ),
        outterIconRightPadding: widget.sizeOfOutterIcon,
        handleSelected: (String? scene) {
          setState(() {
            Provider.of<GlobalState>(context, listen: false).contextContext =
                scene ?? scenes[0];
          });
        },
      ),
    );
  }

  Widget buildLayoutPanel() {
    String? layoutURLFromGlobalState =
        Provider.of<GlobalState>(context, listen: false).contextLayoutImageUrl;
    return Wrap(children: [
      layoutURLFromGlobalState == null
          ? Image.asset(layoutURL)
          : CachedNetworkImage(
              imageUrl: layoutURLFromGlobalState,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  CircularProgressIndicator(value: downloadProgress.progress),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
    ]);
  }

  Widget buildLayoutUpdater() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25),
      child: ElevatedButton(
        onPressed: () {
          FocusScope.of(context).requestFocus(FocusNode());
          updateLayout();
        },
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              'Update ',
              style: TextStyle(
                fontSize: getFitalbeFontSize(MediaQuery.of(context).size.width),
                height: 1.8,
              ),
            ),
            const Icon(Icons.arrow_upward_rounded),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String layoutInfo =
        Provider.of<GlobalState>(context, listen: false).contextLayoutInfo;
    final List<dynamic> boxesData = jsonDecode(layoutInfo)['boxes'];
    if (boxesData.length > 10) {
      boxesData.removeRange(10, boxesData.length);
    }
    boxesPosControllers = boxesData
        .map((e) => TextEditingController(text: e[1].toString()))
        .toList();
    return Column(children: [
      buildTextField(),
      buildDropdownMenu(),
      FlowButton(
        handlePress: getFetchLayout(false),
        displayIcon: const Icon(FontAwesome5.arrow_down),
        padding: const EdgeInsets.symmetric(vertical: 15),
        btnColor: ThemeData().colorScheme.secondary,
      ),
      buildLayoutPanel(),
      buildLayoutUpdater(),
      EditableTable(cellData: boxesData, cellControllers: boxesPosControllers!),
    ]);
  }
}
