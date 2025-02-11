import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttericon/mfg_labs_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta_pipe/components/custom_text_field.dart';

import 'package:meta_pipe/global_state.dart';
import 'package:provider/provider.dart';

class SourceInputPanel extends StatefulWidget {
  const SourceInputPanel({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _SourceInputPanelState();
}

class _SourceInputPanelState extends State<SourceInputPanel> {
  TextEditingController targetController = TextEditingController();
  @override
  void initState() {
    super.initState();

    GlobalState globalState = Provider.of<GlobalState>(context, listen: false);

    targetController.text = globalState.sourceTarget;
    targetController.addListener(() {
      setState(() {
        globalState.sourceTarget = targetController.text;
      });
    });
  }

  double getFitalbeFontSize(double screenWidth) {
    return screenWidth > 905 ? 28 : 16;
  }

  Future<void> pickFile() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    try {
      if (image == null) throw "fail to load image";
      final Uint8List resultBytes = await image.readAsBytes();
      setState(() {
        Provider.of<GlobalState>(context, listen: false).sourcePickedImageData =
            resultBytes;
      });
    } catch (e) {
      showToast('$e');
    }
  }

  Widget buildTextField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0),
      child: ComplexTextField(
        controller: targetController,
        label: "Mixing Object",
        hint: "Always nouns",
        prefixIcon: const Icon(Icons.local_bar_rounded),
        outterIcon: const Icon(
          Icons.keyboard_alt_outlined,
          color: Colors.black26,
        ),
      ),
    );
  }

  Widget buildFilePicker() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25),
      child: ElevatedButton(
        onPressed: () {
          FocusScope.of(context).requestFocus(FocusNode());
          pickFile();
        },
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            if (getCondition(context: context, screenWidth: 600))
              const Icon(MfgLabs.upload),
            Text(
              ' Pick a Mixing Image',
              style: TextStyle(
                fontSize: getFitalbeFontSize(MediaQuery.of(context).size.width),
                height: 1.8,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildImagePicking(double width) {
    Uint8List? imageBytes =
        Provider.of<GlobalState>(context, listen: false).sourcePickedImageData;

    return Container(
      width: width,
      alignment: Alignment.center,
      child: Container(
        width: getResponsiveHeight(
          condition: getCondition(context: context),
          width: width,
          alpha: 1.2,
        ),
        height: getResponsiveHeight(
          condition: getCondition(context: context),
          width: width,
          alpha: 1.2,
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              width: 3,
              color: ThemeData().colorScheme.primary,
            ),
            image: DecorationImage(
                image: imageBytes != null
                    ? MemoryImage(imageBytes)
                    : const AssetImage('assets/images/init_source_picked.png'),
                fit: BoxFit.cover)),
      ),
    );
  }

  Widget buildLayoutPanel() {
    return Wrap(children: [
      LayoutBuilder(
          builder: (context, constraints) =>
              buildImagePicking(constraints.maxWidth)),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      buildTextField(),
      buildFilePicker(),
      buildLayoutPanel(),
    ]);
  }
}
