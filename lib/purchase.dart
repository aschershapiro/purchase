// a widget with an app bar and a scaffold to edit all the parameters of an order object
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:purchase/date_picker_widget.dart';
import 'package:purchase/grid_data_source.dart';
import 'package:purchase/main.dart';
import 'package:purchase/order.dart';

class Purchase extends StatelessWidget {
  final Order order;

  const Purchase({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final x = DatePickerTextField(
      label: 'Order Date',
      initialDate: order.dateOrder,
    );
    return PopScope(
      onPopInvoked: (didPop) {
        order.dateOrder = x.dateTime;
        c.gridDataSource.value = GridDataSource(orders: c.orders.value);
        c.dataGridController.value.notifyListeners();
        database.updateOrder(order);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Purchase'),
        ),
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 300,
                  child: TextField(
                    autofocus: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Title",
                    ),
                    controller: TextEditingController(text: order.title),
                    onChanged: (value) {
                      order.title = value;
                      // c.gridDataSource.value =
                      //     GridDataSource(orders: c.orders.value);
                      // c.dataGridController.value.notifyListeners();
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 300,
                  child: x,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 300,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    autofocus: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Unit Price",
                    ),
                    controller:
                        TextEditingController(text: order.unitPrice.toString()),
                    onChanged: (value) {
                      order.unitPrice.value =
                          value == '' ? 0 : int.parse(value);
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 300,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    autofocus: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Quantity",
                    ),
                    controller:
                        TextEditingController(text: order.quantity.toString()),
                    onChanged: (value) {
                      order.quantity.value = value == '' ? 0 : int.parse(value);
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 300,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    autofocus: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Discount",
                    ),
                    controller:
                        TextEditingController(text: order.discount.toString()),
                    onChanged: (value) {
                      order.discount.value = value == '' ? 0 : int.parse(value);
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 300,
                  child: Row(children: [
                    Text('Total Price:'),
                    Obx(() => Text(order.totalPrice.toString()))
                  ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 300,
                  child: TextField(
                    autofocus: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Vendor",
                    ),
                    controller: TextEditingController(text: order.vendor),
                    onChanged: (value) {
                      order.vendor = value;
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 300,
                  child: TextField(
                    autofocus: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Comment",
                    ),
                    controller: TextEditingController(text: order.comment),
                    onChanged: (value) {
                      order.comment = value;
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 300,
                  child: Row(
                    children: [
                      const Text('Approved: '),
                      Obx(
                        () => Switch(
                          value: order.approved.value,
                          onChanged: (value) {
                            order.approved.value = value;
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 300,
                  child: Row(
                    children: [
                      const Text('Delivered: '),
                      Obx(
                        () => Switch(
                          value: order.delivered.value,
                          onChanged: (value) {
                            order.delivered.value = value;
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 300,
                  child: Row(
                    children: [
                      const Text('Payed: '),
                      Obx(
                        () => Switch(
                          value: order.payed.value,
                          onChanged: (value) {
                            order.payed.value = value;
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 300,
                  child: Row(
                    children: [
                      const Text('Category: '),
                      Obx(() => DropdownMenu(
                            controller:
                                TextEditingController(text: order.category),
                            onSelected: (value) {
                              value != null ? order.category = value : 0;
                            },
                            dropdownMenuEntries: c.categories
                                .map((element) => DropdownMenuEntry(
                                      value: element,
                                      label: element,
                                    ))
                                .toList(),
                          ))
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 300,
                  child: Row(
                    children: [
                      const Text('Priority: '),
                      Obx(() => DropdownMenu(
                            controller:
                                TextEditingController(text: order.priority),
                            onSelected: (value) {
                              value != null ? order.priority = value : 0;
                            },
                            dropdownMenuEntries: c.priorities
                                .map((element) => DropdownMenuEntry(
                                      value: element,
                                      label: element,
                                    ))
                                .toList(),
                          ))
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 300,
                  child: Row(
                    children: [
                      const Text('Buyer: '),
                      DropdownMenu(
                        controller: TextEditingController(text: order.buyer),
                        onSelected: (value) {
                          value != null ? order.buyer = value : 0;
                        },
                        dropdownMenuEntries: c.users.values
                            .map((element) => DropdownMenuEntry(
                                  value: element,
                                  label: element,
                                ))
                            .toList(),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
