import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:http/http.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:meta_pipe/components/custom_tab_bar_view.dart';
import 'package:meta_pipe/components/flow_button.dart';
import 'package:meta_pipe/global_state.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class OutputPanel extends StatefulWidget {
  final double sideHorizontalPadding = 25;
  final String fetchFromWho;
  final String initImageURL;
  final String initHelperURL;
  final String initMattedURL;
  const OutputPanel({
    super.key,
    required this.fetchFromWho,
    required this.initImageURL,
    required this.initHelperURL,
    required this.initMattedURL,
  });
  @override
  State<OutputPanel> createState() => _OutputPannelState();
}

class _OutputPannelState extends State<OutputPanel>
    with SingleTickerProviderStateMixin {
  final List<String> tabs = const ['Output', 'Layers'];
  late TabController diyTabController;

  @override
  void initState() {
    super.initState();
    diyTabController = TabController(vsync: this, length: tabs.length);
  }

  List<String?> getImageURLs() {
    GlobalState globalState = Provider.of<GlobalState>(context, listen: false);
    if (widget.fetchFromWho == 'context') {
      return [
        globalState.contextOutputImageUrl,
        globalState.contextHelpImageUrl
      ];
    } else if (widget.fetchFromWho == 'relation') {
      return [
        globalState.relationOutputImageUrl,
        globalState.relationHelpImageUrl
      ];
    } else {
      assert(widget.fetchFromWho == 'source');
      return [
        globalState.sourceOutputImageUrl,
        globalState.sourceHelpImageUrl,
      ];
    }
  }

  List<String?> getMattedImagesURLs() {
    GlobalState globalState = Provider.of<GlobalState>(context, listen: false);
    if (widget.fetchFromWho == 'context') {
      return [
        globalState.contextMattedImageUrl,
        globalState.contextCachedImageUrl,
      ];
    } else if (widget.fetchFromWho == 'relation') {
      return [
        globalState.relationMattedImageUrl,
        globalState.relationCachedImageUrl,
      ];
    } else {
      assert(widget.fetchFromWho == 'source');
      return [
        globalState.sourceMattedImageUrl,
        globalState.sourceCachedImageUrl,
      ];
    }
  }

  void setImageURLs(dynamic imageURLs) {
    GlobalState globalState = Provider.of<GlobalState>(context, listen: false);
    List<String> idx = ['image1_url', 'image2_url'];
    if (widget.fetchFromWho == 'context') {
      setState(() {
        globalState.contextOutputImageUrl = imageURLs[idx[0]];
        globalState.contextHelpImageUrl = imageURLs[idx[1]];
      });
    } else if (widget.fetchFromWho == 'relation') {
      setState(() {
        globalState.relationOutputImageUrl = imageURLs[idx[0]];
        globalState.relationHelpImageUrl = imageURLs[idx[1]];
      });
    } else {
      assert(widget.fetchFromWho == 'source');
      setState(() {
        globalState.sourceOutputImageUrl = imageURLs[idx[0]];
        globalState.sourceHelpImageUrl = imageURLs[idx[1]];
      });
    }
  }

  Future<void> fetchImage() async {
    buildGlobalLoadingBar(context);
    final String outputRequestURL = '$hostBase/${widget.fetchFromWho}/output';
    final requestHeaders = {'Content-Type': 'application/json'};
    try {
      final globalState = Provider.of<GlobalState>(context, listen: false);
      final Response response;
      if (widget.fetchFromWho == 'context') {
        response = await http.post(Uri.parse(outputRequestURL),
            headers: requestHeaders, body: globalState.contextLayoutInfo);
      } else if (widget.fetchFromWho == 'relation') {
        final int historyCardsIdx = globalState.historyCardsGroupValue;
        final Map<String, dynamic> requestBody = {
          'elaboration':
              globalState.visualElaborationList[historyCardsIdx].content,
        };
        response = await http.post(
          Uri.parse(outputRequestURL),
          headers: requestHeaders,
          body: jsonEncode(requestBody),
        );
      } else {
        assert(widget.fetchFromWho == 'source');
        globalState.sourcePickedImageData ??=
            (await rootBundle.load('assets/images/init_source_picked.png'))
                .buffer
                .asUint8List();
        Map<String, dynamic> requestBody = {
          'target': globalState.sourceTarget,
          'mixing_image_str':
              base64Encode(globalState.sourcePickedImageData!.toList())
        };
        response = await http.post(
          Uri.parse(outputRequestURL),
          headers: requestHeaders,
          body: jsonEncode(requestBody),
        );
      }
      if (response.statusCode == 200) {
        debugPrint(response.body);
        if (jsonDecode(response.body)['error'] != null) throw "server error";
        final imageURLs = jsonDecode(response.body);
        setImageURLs(imageURLs);
      } else {
        throw 'Failed to load image';
      }
      diyTabController.animateTo(0);
      showToast('Success');
    } catch (e) {
      showToast('Error: $e');
    } finally {
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  Future<void> fetchMatting() async {
    buildGlobalLoadingBar(context);
    try {
      GlobalState globalState =
          Provider.of<GlobalState>(context, listen: false);
      String? nowOutputURL = getImageURLs()[0];
      if (nowOutputURL == null) {
        return;
      }
      Map<String, dynamic> requestBody = {'url_to_matte': nowOutputURL};
      final response = await http.post(
        Uri.parse('$hostBase/matting'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );
      if (response.statusCode == 200) {
        debugPrint(response.body);
        if (jsonDecode(response.body)['error'] != null) throw "server error";
        final imageURLs = jsonDecode(response.body);
        if (widget.fetchFromWho == 'context') {
          setState(() {
            globalState.contextCachedImageUrl = nowOutputURL;
            globalState.contextMattedImageUrl = imageURLs['image1_url'];
          });
        } else if (widget.fetchFromWho == 'relation') {
          setState(() {
            globalState.relationCachedImageUrl = nowOutputURL;
            globalState.relationMattedImageUrl = imageURLs['image1_url'];
          });
        } else {
          assert(widget.fetchFromWho == 'source');
          setState(() {
            globalState.sourceCachedImageUrl = nowOutputURL;
            globalState.sourceMattedImageUrl = imageURLs['image1_url'];
          });
        }
        diyTabController.animateTo(1);
      } else {
        throw 'Failed to load image';
      }
      showToast('Success');
    } catch (e) {
      showToast('$e');
    } finally {
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  Future<void> Function() getDownloadImageFunc(bool matted) {
    late final String? imgURL;
    late final String imgPath;
    if (matted) {
      imgURL = getMattedImagesURLs()[0];
      imgPath = 'assets/images/init_${widget.fetchFromWho}_matted.png';
    } else {
      imgURL = getImageURLs()[0];
      imgPath = 'assets/images/init_${widget.fetchFromWho}_output.png';
    }
    late final Uint8List imageBytes4Downloading;

    return () async {
      int timestamp = DateTime.now().millisecondsSinceEpoch;
      try {
        if (imgURL == null) {
          imageBytes4Downloading =
              (await rootBundle.load(imgPath)).buffer.asUint8List();
        } else {
          final response = await http.get(Uri.parse(imgURL));
          if (response.statusCode == 200) {
            imageBytes4Downloading = response.bodyBytes;
          } else {
            throw Exception('Can\'t load images');
          }
        }
        String dir = (await getTemporaryDirectory()).path;
        File file = File('$dir/$timestamp.png');
        await file.writeAsBytes(imageBytes4Downloading);
        await ImageGallerySaver.saveFile(file.path);
        showToast('Success');
      } catch (e) {
        showToast('$e');
      }
    };
  }

  double getResponsivePadding(BuildContext context) {
    return getCondition(context: context) ? widget.sideHorizontalPadding : 15;
  }

  Icon getGeneratingBtnIcon(bool condition) {
    return condition
        ? const Icon(FontAwesome5.arrow_right)
        : const Icon(FontAwesome5.arrow_down);
  }

  EdgeInsets getGeneratingBtnPadding(condition) {
    return condition
        ? const EdgeInsets.symmetric(horizontal: 25)
        : const EdgeInsets.symmetric(vertical: 15);
  }

  Widget buildFirstOutputImageBlock(double contentWidth, String? outputImageURL,
      String initImageURL, bool matted) {
    return Container(
      width: contentWidth,
      height: contentWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: !matted
            ? Border.all(width: 3, color: ThemeData().colorScheme.primary)
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(17),
        child: outputImageURL == null
            ? Image.asset(
                initImageURL,
                fit: BoxFit.fill,
              )
            : CachedNetworkImage(
                imageUrl: outputImageURL,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Center(
                        child: CircularProgressIndicator(
                            value: downloadProgress.progress)),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  List<Widget> buildReversedFlowBtn(double boxWidth, bool matted) {
    return [
      if (!matted)
        Transform.rotate(
          // 剪刀图标
          angle: -135 * 3.141592653589793 / 180,
          alignment: Alignment.center,
          child: FlowButton(
            displayIcon: const Icon(FontAwesome.scissors),
            handlePress: fetchMatting,
            btnColor: ThemeData().colorScheme.tertiary,
            btnSize: boxWidth,
          ),
        ),
      if (matted)
        FlowButton(
          // 返回图标
          displayIcon: const Icon(Entypo.back),
          handlePress: () => {diyTabController.animateTo(0)},
          btnColor: ThemeData().colorScheme.tertiary,
          btnSize: boxWidth,
        ),
      FlowButton(
        // 下载图标
        displayIcon: const Icon(Icons.file_download_outlined),
        handlePress: getDownloadImageFunc(matted),
        btnColor: ThemeData().colorScheme.tertiary,
        btnSize: boxWidth,
      ),
    ];
  }

  Widget buildSecondaryOutputImageBlock(double contenetWidth,
      String? helpImageUrl, String initHelpImageUrl, bool matted) {
    // 输入面板中，分割线下面的部分
    return Expanded(
      child: Align(
        alignment: Alignment.center,
        child: LayoutBuilder(
          builder: (context, constraints) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image(
                width: constraints.maxHeight,
                image: helpImageUrl != null
                    ? CachedNetworkImageProvider(helpImageUrl)
                    : AssetImage(initHelpImageUrl),
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child; // 图片加载完成，显示图片
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                (loadingProgress.expectedTotalBytes ?? 1)
                            : null,
                      ),
                    ); // 图片加载中，显示加载指示器
                  }
                },
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: buildReversedFlowBtn(contenetWidth * 0.12, matted)
                    .map((item) => Expanded(child: item))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildOutputImageBlocks(double contentWidth) {
    return Column(children: [
      buildFirstOutputImageBlock(
          contentWidth, getImageURLs()[0], widget.initImageURL, false),
      Divider(
        height: getResponsivePadding(context),
        thickness: 2,
      ),
      buildSecondaryOutputImageBlock(
          contentWidth, getImageURLs()[1], widget.initHelperURL, false),
    ]);
  }

  Widget buildOutputMattedBlocks(double contentWidth) {
    return Column(children: [
      buildFirstOutputImageBlock(
          contentWidth, getMattedImagesURLs()[0], widget.initMattedURL, true),
      Divider(
        height: getResponsivePadding(context),
        thickness: 2,
      ),
      buildSecondaryOutputImageBlock(
          contentWidth, getMattedImagesURLs()[1], widget.initImageURL, true),
    ]);
  }

  Widget buildOutputPanel() {
    return LayoutBuilder(
      builder: (context, constraints) {
        double responsiveHorizontalPadding = getResponsivePadding(context);
        double contentWidth =
            constraints.maxWidth - responsiveHorizontalPadding * 2;
        return Container(
          padding:
              EdgeInsets.symmetric(horizontal: responsiveHorizontalPadding),
          decoration: BoxDecoration(
            color: ThemeData().colorScheme.primaryContainer,
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          height: constraints.maxWidth / 0.618,
          child: CustomTabBarView(
            tabs: tabs,
            diyTabController: diyTabController,
            tabBarHeight: responsiveHorizontalPadding + 25,
            verticalPadding: responsiveHorizontalPadding * 0.5,
            views: [
              buildOutputImageBlocks(contentWidth),
              buildOutputMattedBlocks(contentWidth),
            ],
          ),
        );
      },
    );
  }

  List<Widget> buildFlowBtnAndOuputputPanel(Widget outputPanel) {
    return [
      FlowButton(
        displayIcon: getGeneratingBtnIcon(getCondition(context: context)),
        padding: getGeneratingBtnPadding(getCondition(context: context)),
        btnColor: ThemeData().colorScheme.secondary,
        handlePress: fetchImage,
      ),
      outputPanel,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return getCondition(context: context)
        ? Row(
            children: buildFlowBtnAndOuputputPanel(
            Expanded(child: buildOutputPanel()),
          ))
        : Column(children: buildFlowBtnAndOuputputPanel(buildOutputPanel()));
  }
}
