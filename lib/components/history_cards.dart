import 'package:flutter/material.dart';
import 'package:meta_pipe/global_state.dart';
import 'package:provider/provider.dart';

class HistoryCardList extends StatelessWidget {
  final List<HistoryCardItem> cardItems;
  final String selectingName;
  const HistoryCardList({
    super.key,
    required this.cardItems,
    required this.selectingName,
  });

  Widget _buildHistoryCardItemByIndex(BuildContext context, int index) {
    int reverseIndex = (cardItems.length - 1) - index; // 反转索引
    return cardItems[reverseIndex];
  }

  double getFitalbeFontSize(double screenWidth) {
    return screenWidth > 905 ? 28 : 16;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: ThemeData().colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(children: [
        Text(
          'Visual Elaboration',
          style: TextStyle(
            fontSize: getFitalbeFontSize(MediaQuery.of(context).size.width),
          ),
        ),
        const Divider(
          height: 15,
        ),
        LayoutBuilder(
          builder: (context, constraints) => Container(
            constraints: BoxConstraints(
              maxHeight: getResponsiveHeight(
                condition: getCondition(context: context),
                width: constraints.maxWidth,
              ),
            ),
            width: constraints.maxWidth,
            child: ListView.builder(
              itemBuilder: _buildHistoryCardItemByIndex,
              itemCount: cardItems.length,
            ),
          ),
        ),
        const Divider(
          height: 10,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            'Selecting $selectingName',
            style: TextStyle(
              fontSize:
                  getFitalbeFontSize(MediaQuery.of(context).size.width) * 0.8,
              color: ThemeData().colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ]),
    );
  }
}

class HistoryCardItem extends StatefulWidget {
  final String title;
  final String content;
  final int idx;
  final void Function(dynamic v) handleOnchange;
  const HistoryCardItem({
    super.key,
    required this.title,
    required this.content,
    required this.idx,
    required this.handleOnchange,
  });
  @override
  State<HistoryCardItem> createState() => _HistoryCardsState();
}

class _HistoryCardsState extends State<HistoryCardItem> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(dividerColor: Colors.transparent),
      child: ExpansionTile(
        leading: const Icon(Icons.star),
        title: SelectableText(
          'No.${widget.idx} ${widget.title}',
          style: const TextStyle(fontSize: 12),
        ),
        // backgroundColor: Colors.grey.withAlpha(6),
        onExpansionChanged: (value) {
          // print('$value');
        },
        // initiallyExpanded: true,
        children: [
          Card(
            color: ThemeData().colorScheme.primaryContainer,
            elevation: 4,
            child: Stack(children: [
              Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.all(10),
                child: SelectableText(
                  widget.content,
                  style: const TextStyle(fontSize: 10),
                  maxLines: 8,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Radio<int>(
                  value: widget.idx,
                  activeColor: ThemeData().colorScheme.onPrimaryContainer,
                  groupValue: Provider.of<GlobalState>(context, listen: false)
                      .historyCardsGroupValue,
                  onChanged: widget.handleOnchange,
                ),
              )
            ]),
          ),
        ],
      ),
    );
  }
}
