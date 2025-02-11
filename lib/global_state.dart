import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

const String hostBase = 'http://localhost:8000';

bool getCondition({required BuildContext context, double screenWidth = 905}) {
  return MediaQuery.of(context).size.width > screenWidth;
}

EdgeInsets getResponsivePadding(bool condition) {
  return condition
      ? const EdgeInsets.only(left: 25, right: 25, bottom: 10)
      : const EdgeInsets.only(left: 10, right: 10, bottom: 5);
}

double getResponsiveHeight({
  required bool condition,
  required double width,
  double alpha = 1,
}) {
  return condition ? width * 0.618 * alpha : width;
}

void showToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT, // 显示时间
    gravity: ToastGravity.BOTTOM, // 显示位置
    timeInSecForIosWeb: 1, // iOS Web 显示时间
    backgroundColor: Colors.black,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

Future<dynamic> buildGlobalLoadingBar(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: false, // 禁止点击外部关闭加载框
    builder: (BuildContext context) {
      return Center(
        child: Wrap(
          direction: Axis.vertical,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            CircularProgressIndicator(
              color: ThemeData().colorScheme.onSecondary,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Text("It may take 1~2 minutes",
                  style: TextStyle(
                      fontSize: 20,
                      color: ThemeData().colorScheme.onSecondary)),
            ),
          ],
        ),
      );
    },
  );
}

class VisualElaboration {
  String title;
  String content;
  VisualElaboration({required this.title, required this.content});
}

class GlobalState with ChangeNotifier {
  String _contextTarget = "A panda, A soccer, A piano, A tree";
  String get contextTarget => _contextTarget;
  set contextTarget(String newValue) {
    _contextTarget = newValue;
    notifyListeners();
  }

  String _contextContext = "*Random";
  String get contextContext => _contextContext;
  set contextContext(String newValue) {
    _contextContext = newValue;
    notifyListeners();
  }

  String _contextLayoutInfo =
      '''{"boxes":[["a panda",[30,171,242,397]],["a soccer",[300,300,380,380]],["a piano",[50,350,350,500]],["a tree",[400,50,500,250]]],"background":"A realistic scene of a spaceship interior","prompt_for_image":"A realistic image of A panda, A soccer, A piano, A tree in a scene of Spacehip interior","layout_url":""} ''';
  String get contextLayoutInfo => _contextLayoutInfo;
  set contextLayoutInfo(String newValue) {
    _contextLayoutInfo = newValue;
    notifyListeners();
  }

  String? _contextLayoutImageUrl;
  String? get contextLayoutImageUrl => _contextLayoutImageUrl;
  set contextLayoutImageUrl(String? newValue) {
    _contextLayoutImageUrl = newValue;
    notifyListeners();
  }

  String? _contextOutputImageUrl;
  String? get contextOutputImageUrl => _contextOutputImageUrl;
  set contextOutputImageUrl(String? newValue) {
    _contextOutputImageUrl = newValue;
    notifyListeners();
  }

  String? _contextHelpImageUrl;
  String? get contextHelpImageUrl => _contextHelpImageUrl;
  set contextHelpImageUrl(String? newValue) {
    _contextHelpImageUrl = newValue;
    notifyListeners();
  }

  String? _contextMattedImageUrl;
  String? get contextMattedImageUrl => _contextMattedImageUrl;
  set contextMattedImageUrl(String? newValue) {
    _contextMattedImageUrl = newValue;
    notifyListeners();
  }

  String? _contextCachedImageUrl;
  String? get contextCachedImageUrl => _contextCachedImageUrl;
  set contextCachedImageUrl(String? newValue) {
    _contextCachedImageUrl = newValue;
    notifyListeners();
  }

  String _relationTarget = "Soda";
  String get relationTarget => _relationTarget;
  set relationTarget(String newValue) {
    _relationTarget = newValue;
    notifyListeners();
  }

  String _relationRelation = "Powerful";
  String get relationRelation => _relationRelation;
  set relationRelation(String newValue) {
    _relationRelation = newValue;
    notifyListeners();
  }

  int _historyCardsGroupValue = 0;
  int get historyCardsGroupValue => _historyCardsGroupValue;
  set historyCardsGroupValue(int? newValue) {
    if (newValue != null) {
      _historyCardsGroupValue = newValue;
    } else {
      _historyCardsGroupValue = 0;
    }
    notifyListeners();
  }

  List<VisualElaboration> visualElaborationList = [
    VisualElaboration(
      title: "powerful soda",
      content:
          "Soda is powerful just like a rocket: A soda can with a rocket nozzle attached at the bottom, launching upward with a trail of fiery exhaust beneath it.",
    ),
  ];
  void addVisualElaborationItem(VisualElaboration item) {
    visualElaborationList.add(item);
    notifyListeners();
  }

  String? _relationOutputImageUrl;
  String? get relationOutputImageUrl => _relationOutputImageUrl;
  set relationOutputImageUrl(String? newValue) {
    _relationOutputImageUrl = newValue;
    notifyListeners();
  }

  String? _relationHelpImageUrl;
  String? get relationHelpImageUrl => _relationHelpImageUrl;
  set relationHelpImageUrl(String? newValue) {
    _relationHelpImageUrl = newValue;
    notifyListeners();
  }

  String? _relationMattedImageUrl;
  String? get relationMattedImageUrl => _relationMattedImageUrl;
  set relationMattedImageUrl(String? newValue) {
    _relationMattedImageUrl = newValue;
    notifyListeners();
  }

  String? _relationCachedImageUrl;
  String? get relationCachedImageUrl => _relationCachedImageUrl;
  set relationCachedImageUrl(String? newValue) {
    _relationCachedImageUrl = newValue;
    notifyListeners();
  }

  Uint8List? _sourcePickedImageData;
  Uint8List? get sourcePickedImageData => _sourcePickedImageData;
  set sourcePickedImageData(Uint8List? newValue) {
    _sourcePickedImageData = newValue;
    notifyListeners();
  }

  String _sourceTarget = "Cake";
  String get sourceTarget => _sourceTarget;
  set sourceTarget(String newValue) {
    _sourceTarget = newValue;
    notifyListeners();
  }

  String? _sourceOutputImageUrl;
  String? get sourceOutputImageUrl => _sourceOutputImageUrl;
  set sourceOutputImageUrl(String? newValue) {
    _sourceOutputImageUrl = newValue;
    notifyListeners();
  }

  String? _sourceHelpImageUrl;
  String? get sourceHelpImageUrl => _sourceHelpImageUrl;
  set sourceHelpImageUrl(String? newValue) {
    _sourceHelpImageUrl = newValue;
    notifyListeners();
  }

  String? _sourceMattedImageUrl;
  String? get sourceMattedImageUrl => _sourceMattedImageUrl;
  set sourceMattedImageUrl(String? newValue) {
    _sourceMattedImageUrl = newValue;
    notifyListeners();
  }

  String? _sourceCachedImageUrl;
  String? get sourceCachedImageUrl => _sourceCachedImageUrl;
  set sourceCachedImageUrl(String? newValue) {
    _sourceCachedImageUrl = newValue;
    notifyListeners();
  }
}
