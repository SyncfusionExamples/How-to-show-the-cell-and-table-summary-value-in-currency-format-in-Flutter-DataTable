# How-to-show-the-cell-and-table-summary-value-in-currency-format-in-Flutter-DataTable

The Syncfusion [Flutter DataGrid](https://www.syncfusion.com/flutter-widgets/flutter-datagrid) provides built-in support to display concise information about the rows by using the table summary rows. Table summary rows allow you to display summarized information about the rows in the DataGrid, such as the sum, average, maximum, and minimum value of a column. This can be useful when you want to provide a quick overview of the data in the DataGrid.
In this article, we will show you how to format the column and its summary data in the DataGrid as a currency format. We will use the built-in table summary types provided by DataGrid to achieve this.

## STEP 1:
Import the following package in your project to access the table summary types provided by the DataGrid.

```dart
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:intl/intl.dart';

```
## STEP 2:
Initialize the [SfDataGrid](https://pub.dev/documentation/syncfusion_flutter_datagrid/latest/datagrid/SfDataGrid-class.html) widget with all the required properties. 

```dart
late EmployeeDataSource _employeeDataSource;
  List<Employee> employees = <Employee>[];

  @override
  void initState() {
    super.initState();
    employees = getEmployeeData();
    _employeeDataSource = EmployeeDataSource(employees);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter SfDataGrid')),
      body: SfDataGrid(
        source: _employeeDataSource,
        columns: [
          GridColumn(
            columnName: 'id',
            label: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              alignment: Alignment.center,
              child: const Text('ID'),
            ),
          ),
          GridColumn(
            columnName: 'name',
            label: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              alignment: Alignment.center,
              child: const Text('Name'),
            ),
          ),
          GridColumn(
            columnName: 'designation',
            label: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              alignment: Alignment.center,
              child: const Text('Designation'),
            ),
          ),
          GridColumn(
            columnName: 'salary',
            label: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              alignment: Alignment.center,
              child: const Text('Salary '),
            ),
          ),
        ],
        columnWidthMode: ColumnWidthMode.auto,
        tableSummaryRows: [
          GridTableSummaryRow(
              showSummaryInRow: false,
              columns: [
                const GridSummaryColumn(
                    name: 'Sum',
                    columnName: 'salary',
                    summaryType: GridSummaryType.sum)
              ],
              position: GridTableSummaryRowPosition.bottom)
        ],
      ),
    );
  }

```
## STEP 3: 
Create a data source class by extending [DataGridSource](https://pub.dev/documentation/syncfusion_flutter_datagrid/latest/datagrid/DataGridSource-class.html) for mapping data to the SfDataGrid. In the [buildTableSummaryCellWidget](https://pub.dev/documentation/syncfusion_flutter_datagrid/latest/datagrid/DataGridSource/buildTableSummaryCellWidget.html) method, you can format the table summary value using the  [NumberFormat.currency](https://api.flutter.dev/flutter/intl/NumberFormat/NumberFormat.currency.html) constructor. This method is called for each table summary cell, and it returns the widget that should be displayed in the cell.

You can also format the cell value in the [buildRow](https://pub.dev/documentation/syncfusion_flutter_datagrid/latest/datagrid/DataGridSource/buildRow.html) method. This method is called for each row in the DataGrid, and it returns the widget that should be displayed in the row.

```dart
class EmployeeDataSource extends DataGridSource {
  EmployeeDataSource(List<Employee> employees) {
    buildDataGridRow(employees);
  }

  void buildDataGridRow(List<Employee> employeeData) {
    dataGridRow = employeeData.map<DataGridRow>((employee) {
      return DataGridRow(cells: [
        DataGridCell<int>(columnName: 'id', value: employee.id),
        DataGridCell<String>(columnName: 'name', value: employee.name),
        DataGridCell<String>(
            columnName: 'designation', value: employee.designation),
        DataGridCell<double>(columnName: 'salary', value: employee.salary)
      ]);
    }).toList();
  }

  List<DataGridRow> dataGridRow = <DataGridRow>[];

  @override
  List<DataGridRow> get rows => dataGridRow.isEmpty ? [] : dataGridRow;

  final formatter = NumberFormat.currency(symbol: '\$');

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
          alignment: Alignment.center,
          child: Text(
            dataGridCell.columnName == 'salary'
                ? formatter.format(dataGridCell.value)
                : dataGridCell.value.toString(),
          ));
    }).toList());
  }

  @override
  Widget? buildTableSummaryCellWidget(
      GridTableSummaryRow summaryRow,
      GridSummaryColumn? summaryColumn,
      RowColumnIndex rowColumnIndex,
      String summaryValue) {
    String value = formatter.format(double.parse(summaryValue));
    return Container(alignment: Alignment.center, child: Text(value));
  }
}

```