import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:purchase/order.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class GridDataSource extends DataGridSource {
  GridDataSource({required List<Order> orders}) {
    _orders = orders
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(columnName: 'id', value: e.id),
              DataGridCell<String>(columnName: 'title', value: e.title),
              DataGridCell<String>(columnName: 'buyer', value: e.buyer),
              DataGridCell<int>(
                  columnName: 'unitPrice', value: e.unitPrice.value),
              DataGridCell<int>(
                  columnName: 'quantity', value: e.quantity.value),
              DataGridCell<int>(columnName: 'totalPrice', value: e.totalPrice),
              DataGridCell<String>(
                  columnName: 'order_date',
                  value: dateTimetoJalaliString(e.dateOrder)),
              DataGridCell<String>(
                  columnName: 'delivery_date',
                  value: dateTimetoJalaliString(e.dateDelivery)),
              DataGridCell<String>(columnName: 'category', value: e.category),
              DataGridCell<bool>(
                  columnName: 'approved', value: e.approved.value),
              DataGridCell<bool>(
                  columnName: 'delivered', value: e.delivered.value),
              DataGridCell<String>(columnName: 'vendor', value: e.vendor),
              DataGridCell<String>(columnName: 'priority', value: e.priority),
              DataGridCell<String>(columnName: 'comment', value: e.comment),
              DataGridCell<bool>(columnName: 'payed', value: e.payed.value),
              DataGridCell<int>(
                  columnName: 'discount', value: e.discount.value),
            ]))
        .toList();
  }
  String dateTimetoJalaliString(DateTime? date) {
    if (date == null) {
      return '';
    } else {
      return '${date.toJalali().year}/${date.toJalali().month}/${date.toJalali().day}';
    }
  }

  List<DataGridRow> _orders = [];

  @override
  List<DataGridRow> get rows => _orders;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
        alignment: (dataGridCell.columnName == 'title' ||
                dataGridCell.columnName == 'id')
            ? Alignment.centerRight
            : Alignment.centerLeft,
        padding: const EdgeInsets.all(16.0),
        child: Text(dataGridCell.value.toString()),
      );
    }).toList());
  }
}
