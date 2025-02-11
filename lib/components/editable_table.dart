import 'package:flutter/material.dart';

class EditableTable extends StatelessWidget {
  // 需要被通知
  final List<dynamic> cellData;
  final List<TextEditingController> cellControllers;
  const EditableTable(
      {super.key, required this.cellData, required this.cellControllers});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          DataColumn(
            label: Column(children: [
              Text(
                'Objects',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: ThemeData().colorScheme.primary),
              ),
              const Text(
                'It show 10 items at most',
                style: TextStyle(color: Colors.black38),
              )
            ]),
          ),
          DataColumn(
            label: Column(children: [
              Text(
                'Coordinate',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: ThemeData().colorScheme.primary),
              ),
              const Text(
                '[Top-Left:(x1,y1), Bottom-Right:(x2,y2)]',
                style: TextStyle(color: Colors.black38),
              ),
            ]),
          ),
        ],
        rows: cellData.asMap().entries.map((e) {
          return DataRow(
            cells: [
              DataCell(
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    e.value[0].toString(),
                    style: const TextStyle(color: Colors.black87, fontSize: 16),
                  ),
                ),
              ),
              DataCell(
                EditableText(
                  controller: cellControllers[e.key],
                  focusNode: FocusNode(),
                  style: const TextStyle(color: Colors.black54, fontSize: 16),
                  cursorColor: ThemeData().colorScheme.primary,
                  backgroundCursorColor: ThemeData().colorScheme.primary,
                  selectionControls: MaterialTextSelectionControls(),
                  onSubmitted: (value) {},
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
