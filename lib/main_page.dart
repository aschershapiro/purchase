import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:purchase/grid_data_source.dart';
import 'package:purchase/main.dart';
import 'package:purchase/order.dart';
import 'package:purchase/purchase.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Page'),
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
                      icon: Icon(Icons.edit)),
                ),
              )),
          Obx(() => Visibility(
                visible: c.actionButtonsVisible.value,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton.filled(
                      onPressed: null, icon: Icon(Icons.delete_forever)),
                ),
              )),
          Obx(() => Visibility(
                visible: c.actionButtonsVisible.value,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton.filled(
                      onPressed: null, icon: Icon(Icons.archive)),
                ),
              ))
        ],
      ),
      body: Center(
          child: Obx(
        () => SfDataGrid(
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
                    padding: EdgeInsets.all(16.0),
                    alignment: Alignment.centerRight,
                    child: Text(
                      'id',
                    ))),
            GridColumn(
                columnName: 'title',
                label: Container(
                    padding: EdgeInsets.all(16.0),
                    alignment: Alignment.centerRight,
                    child: Text(
                      'title',
                    ))),
            GridColumn(
                columnName: 'buyer',
                label: Container(
                    padding: EdgeInsets.all(16.0),
                    alignment: Alignment.centerLeft,
                    child: Text('buyer'))),
            GridColumn(
                columnName: 'unitPrice',
                width: 120,
                label: Container(
                    padding: EdgeInsets.all(16.0),
                    alignment: Alignment.centerLeft,
                    child: Text('unitPrice'))),
            GridColumn(
                columnName: 'quantity',
                label: Container(
                    padding: EdgeInsets.all(16.0),
                    alignment: Alignment.centerRight,
                    child: Text('quantity'))),
            GridColumn(
              columnName: 'totalPrice',
              label: Container(
                  padding: EdgeInsets.all(16.0),
                  alignment: Alignment.centerRight,
                  child: Text('totalPrice')),
            ),
            GridColumn(
              columnName: 'order_date',
              label: Container(
                  padding: EdgeInsets.all(16.0),
                  alignment: Alignment.centerRight,
                  child: Text('order_date')),
            ),
            GridColumn(
              columnName: 'delivery_date',
              label: Container(
                  padding: EdgeInsets.all(16.0),
                  alignment: Alignment.centerRight,
                  child: Text('delivery_date')),
            ),
            GridColumn(
              columnName: 'category',
              label: Container(
                  padding: EdgeInsets.all(16.0),
                  alignment: Alignment.centerRight,
                  child: Text('category')),
            ),
            GridColumn(
              columnName: 'approved',
              allowSorting: false,
              allowFiltering: false,
              label: Container(
                  padding: EdgeInsets.all(16.0),
                  alignment: Alignment.centerRight,
                  child: Text('approved')),
            ),
            GridColumn(
              columnName: 'delivered',
              allowSorting: false,
              allowFiltering: false,
              label: Container(
                  padding: EdgeInsets.all(16.0),
                  alignment: Alignment.centerRight,
                  child: Text('delivered')),
            ),
            GridColumn(
              columnName: 'vendor',
              label: Container(
                  padding: EdgeInsets.all(16.0),
                  alignment: Alignment.centerRight,
                  child: Text('vendor')),
            ),
            GridColumn(
              columnName: 'priority',
              label: Container(
                  padding: EdgeInsets.all(16.0),
                  alignment: Alignment.centerRight,
                  child: Text('priority')),
            ),
            GridColumn(
              columnName: 'comment',
              allowSorting: false,
              allowFiltering: false,
              label: Container(
                  padding: EdgeInsets.all(16.0),
                  alignment: Alignment.centerRight,
                  child: Text('comment')),
            ),
            GridColumn(
              columnName: 'payed',
              allowSorting: false,
              allowFiltering: false,
              label: Container(
                  padding: EdgeInsets.all(16.0),
                  alignment: Alignment.centerRight,
                  child: Text('payed')),
            ),
            GridColumn(
              columnName: 'discount',
              label: Container(
                  padding: EdgeInsets.all(16.0),
                  alignment: Alignment.centerRight,
                  child: Text('discount')),
            ),
          ],
        ),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
