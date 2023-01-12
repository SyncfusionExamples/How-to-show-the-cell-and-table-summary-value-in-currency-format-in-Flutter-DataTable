import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SfDataGridDemo()));
}

class SfDataGridDemo extends StatefulWidget {
  const SfDataGridDemo({Key? key}) : super(key: key);

  @override
  SfDataGridDemoState createState() => SfDataGridDemoState();
}

class SfDataGridDemoState extends State<SfDataGridDemo> {
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
}

List<Employee> getEmployeeData() {
  return [
    Employee(10001, 'Jack', 'Project Manager', 100000.0),
    Employee(10002, 'Kathryn', 'Project Lead', 75000.0),
    Employee(10003, 'Lara', 'Developer', 40000.0),
    Employee(10004, 'Crowley', 'Designer', 32000.0),
    Employee(10005, 'Landry', 'Developer', 32000.0),
    Employee(10006, 'Adams', 'Developer', 33000.0),
    Employee(10007, 'Perry', 'Developer', 34000.0),
    Employee(10008, 'Balnc', 'Designer', 32000.0),
    Employee(10009, 'Gable', 'Developer', 37000.0),
    Employee(10010, 'Irvine', 'Developer', 35000.0)
  ];
}

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

class Employee {
  Employee(this.id, this.name, this.designation, this.salary);

  final int id;
  final String name;
  final String designation;
  final double salary;
}
