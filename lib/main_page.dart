import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:purchase/grid_data_source.dart';
import 'package:purchase/main.dart';
import 'package:purchase/order.dart';
import 'package:purchase/purchase.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<SfDataGridState> key = GlobalKey<SfDataGridState>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders List'),
        leading: IconButton(
            onPressed: () async {
              final Workbook workbook =
                  key.currentState!.exportToExcelWorkbook();
              final List<int> bytes = workbook.saveAsStream();
              workbook.dispose();
              //Get the storage folder location using path_provider package.
              final Directory directory =
                  await path_provider.getApplicationSupportDirectory();
              final String path = directory.path;
              final File file = File(Platform.isWindows
                  ? '$path\\output.xlsx'
                  : '$path/output.xlsx');
              await file.writeAsBytes(bytes, flush: true);
              if (Platform.isWindows) {
                await Process.run('start', <String>['$path\\output.xlsx'],
                    runInShell: true);
              } else if (Platform.isMacOS) {
                await Process.run('open', <String>['$path/output.xlsx'],
                    runInShell: true);
              } else if (Platform.isLinux) {
                await Process.run('xdg-open', <String>['$path/output.xlsx'],
                    runInShell: true);
              }
            },
            icon: const Icon(Icons.file_open)),
        actions: [
          Obx(() => Visibility(
                visible: c.actionButtonsVisible.value,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton.filled(
                      onPressed: () {
                        var ord = c.orders.firstWhere((element) =>
                            element.id ==
                            c.dataGridController.value.selectedRow
                                ?.getCells()
                                .first
                                .value
                                .toString());
                        Get.to(Purchase(order: ord));
                      },
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.white,
                      )),
                ),
              )),
          Obx(() => Visibility(
                visible: c.actionButtonsVisible.value,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton.filled(
                      onPressed: () {
                        var ord = c.orders.firstWhere((element) =>
                            element.id ==
                            c.dataGridController.value.selectedRow
                                ?.getCells()
                                .first
                                .value
                                .toString());
                        database.removeOrder(ord);
                        c.orders.remove(ord);
                        c.actionButtonsVisible.toggle();
                        c.gridDataSource.value =
                            GridDataSource(orders: c.orders.value);
                        c.dataGridController.value.notifyListeners();
                      },
                      icon: const Icon(
                        Icons.delete_forever,
                        color: Colors.white,
                      )),
                ),
              )),
          Obx(() => Visibility(
                visible: c.actionButtonsVisible.value,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton.filled(
                      onPressed: () {
                        var ord = c.orders.firstWhere((element) =>
                            element.id ==
                            c.dataGridController.value.selectedRow
                                ?.getCells()
                                .first
                                .value
                                .toString());
                        ord.archive.toggle();
                        database.updateOrder(ord);
                      },
                      icon: const Icon(
                        Icons.archive,
                        color: Colors.white,
                      )),
                ),
              ))
        ],
      ),
      body: Center(
          child: Obx(
        () => SfDataGrid(
          key: key,
          controller: c.dataGridController.value,
          onSelectionChanged: (addedRows, removedRows) {
            if (addedRows.isNotEmpty) {
              c.actionButtonsVisible.value = true;
              c.selectedIndex.value = c.dataGridController.value.selectedIndex;
            } else {
              c.actionButtonsVisible.value = false;
            }
          },
          columnWidthMode: ColumnWidthMode.fitByColumnName,
          rowsPerPage: 5,
          allowSorting: true,
          allowFiltering: true,
          selectionMode: SelectionMode.singleDeselect,
          source: c.gridDataSource.value,
          columns: <GridColumn>[
            GridColumn(
                columnName: 'id',
                label: Container(
                    padding: const EdgeInsets.all(8.0),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'id',
                    ))),
            GridColumn(
                columnName: 'title',
                label: Container(
                    padding: EdgeInsets.all(8.0),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Title',
                    ))),
            GridColumn(
                columnName: 'buyer',
                label: Container(
                    padding: const EdgeInsets.all(8.0),
                    alignment: Alignment.centerLeft,
                    child: const Text('Buyer'))),
            GridColumn(
                columnName: 'unitPrice',
                width: 120,
                label: Container(
                    padding: const EdgeInsets.all(8.0),
                    alignment: Alignment.centerLeft,
                    child: const Text('Unit Price'))),
            GridColumn(
                columnName: 'quantity',
                label: Container(
                    padding: const EdgeInsets.all(8.0),
                    alignment: Alignment.centerLeft,
                    child: const Text('Quantity'))),
            GridColumn(
              columnName: 'totalPrice',
              label: Container(
                  padding: const EdgeInsets.all(8.0),
                  alignment: Alignment.centerLeft,
                  child: const Text('Total Price')),
            ),
            GridColumn(
              columnName: 'order_date',
              label: Container(
                  padding: const EdgeInsets.all(8.0),
                  alignment: Alignment.centerLeft,
                  child: const Text('Order')),
            ),
            GridColumn(
              columnName: 'delivery_date',
              label: Container(
                  padding: const EdgeInsets.all(8.0),
                  alignment: Alignment.centerLeft,
                  child: const Text('Delivery')),
            ),
            GridColumn(
              columnName: 'category',
              label: Container(
                  padding: const EdgeInsets.all(8.0),
                  alignment: Alignment.centerLeft,
                  child: const Text('Category')),
            ),
            GridColumn(
              columnName: 'approved',
              allowSorting: false,
              allowFiltering: false,
              label: Container(
                  padding: const EdgeInsets.all(8.0),
                  alignment: Alignment.centerLeft,
                  child: const Text('Approved')),
            ),
            GridColumn(
              columnName: 'delivered',
              allowSorting: false,
              allowFiltering: false,
              label: Container(
                  padding: const EdgeInsets.all(8.0),
                  alignment: Alignment.centerLeft,
                  child: const Text('Delivered')),
            ),
            GridColumn(
              columnName: 'payed',
              allowSorting: false,
              allowFiltering: false,
              label: Container(
                  padding: const EdgeInsets.all(8.0),
                  alignment: Alignment.centerLeft,
                  child: const Text('Payed')),
            ),
            GridColumn(
              columnName: 'priority',
              label: Container(
                  padding: const EdgeInsets.all(8.0),
                  alignment: Alignment.centerLeft,
                  child: const Text('Priority')),
            ),
            GridColumn(
              columnName: 'vendor',
              label: Container(
                  padding: const EdgeInsets.all(8.0),
                  alignment: Alignment.centerLeft,
                  child: const Text('Vendor')),
            ),
            GridColumn(
              columnName: 'comment',
              allowSorting: false,
              allowFiltering: false,
              label: Container(
                  padding: const EdgeInsets.all(8.0),
                  alignment: Alignment.centerLeft,
                  child: const Text('Comment')),
            ),
            GridColumn(
              columnName: 'discount',
              label: Container(
                  padding: const EdgeInsets.all(8.0),
                  alignment: Alignment.centerLeft,
                  child: const Text('Discount')),
            ),
          ],
        ),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(Purchase(
              order: Order(
                  id: '',
                  title: '',
                  quantity: 0.obs,
                  unitPrice: 0.obs,
                  approved: RxBool(false),
                  delivered: RxBool(false),
                  payed: RxBool(false),
                  priority: 'low',
                  comment: '',
                  buyer: '',
                  vendor: '',
                  category: 'Structure',
                  discount: 0.obs)));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
