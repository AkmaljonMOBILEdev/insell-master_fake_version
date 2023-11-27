import 'package:flutter/material.dart';

class AppDataTableWidget extends StatefulWidget {
  const AppDataTableWidget({super.key, required this.columnLabels, required this.rows});

  final List<String> columnLabels;
  final List<DataRow> rows;

  @override
  State<AppDataTableWidget> createState() => _AppDataTableWidgetState();
}

class _AppDataTableWidgetState extends State<AppDataTableWidget> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        dividerColor: Colors.transparent,
        scaffoldBackgroundColor: Colors.transparent,
        canvasColor: Colors.transparent,
        cardColor: Colors.transparent,
        shadowColor: Colors.transparent,
        unselectedWidgetColor: Colors.transparent,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
          labelLarge: TextStyle(color: Colors.white),
          bodySmall: TextStyle(color: Colors.white),
          displayLarge: TextStyle(color: Colors.white),
          displayMedium: TextStyle(color: Colors.white),
          displaySmall: TextStyle(color: Colors.white),
          headlineMedium: TextStyle(color: Colors.white),
          headlineSmall: TextStyle(color: Colors.white),
          titleLarge: TextStyle(color: Colors.white),
          labelSmall: TextStyle(color: Colors.white),
          titleMedium: TextStyle(color: Colors.white),
          titleSmall: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      child: PaginatedDataTable(
          sortAscending: true,
          availableRowsPerPage: const [10, 15, 20, 30, 40, 50, 100],
          rowsPerPage: 16,
          headingRowHeight: 40,
          arrowHeadColor: Colors.transparent,
          dataRowMaxHeight: 30,
          dataRowMinHeight: 30,
          columns: widget.columnLabels.map((e) {
            int index = widget.columnLabels.indexOf(e);
            bool isLast = index == widget.columnLabels.length - 1;
            bool isFirst = index == 0;
            return DataColumn(
              label: Expanded(
                  child: Text(
                e,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
                textAlign: isFirst
                    ? TextAlign.start
                    : isLast
                        ? TextAlign.end
                        : TextAlign.center,
              )),
              tooltip: e,
            );
          }).toList(),
          source: RowSource(
            rows: widget.rows,
          )),
    );
  }
}

class RowSource extends DataTableSource {
  RowSource({required this.rows});

  final List<DataRow> rows;

  @override
  DataRow? getRow(int index) {
    return DataRow(
      cells: rows[index].cells,
      color: MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
          if (index % 2 == 0) return Colors.blueGrey.withOpacity(0.2);
          return null; // Use default value for other states and odd rows.
        },
      ),
    );
  }

  @override
  bool get isRowCountApproximate => true;

  @override
  int get rowCount => 20;

  @override
  int get selectedRowCount => 20;
}
