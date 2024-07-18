// a widget with an app bar and a scaffold to edit all the parameters of an order object
import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:purchase/date_picker_widget.dart';
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
    final y = DatePickerTextField(
      label: 'Delivery Date',
      initialDate: order.dateOrder,
    );
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) {
          c.actionButtonsVisible.toggle();
          return;
        }
        bool canpop = false;
        if (order.id != '' && order.buyer != '') {
          canpop = true;
        } else if (order.id == '' && order.title == '') {
          canpop = true;
        } else if (order.id == '' && order.title != '' && order.buyer != '') {
          canpop = true;
        }
        if (canpop) {
          if (order.id != '') {
            order.dateOrder = x.dateTime;
            order.dateDelivery = y.dateTime;
            database.updateOrder(order);
          } else if (order.title != '') {
            order.dateOrder = x.dateTime;
            order.dateDelivery = y.dateTime;
            c.orders.add(order);

            await database.createOrder(order);
            var resp = await database.getAllOrders();
            c.orders.clear();
            for (var element in resp) {
              c.orders.add(Order(
                id: element.id,
                title: element.data['title'],
                quantity: RxInt(element.data['quantity']),
                unitPrice: RxInt(element.data['unit_price']),
                approved: RxBool(element.data['approved']),
                delivered: RxBool(element.data['delivered']),
                payed: RxBool(element.data['payed']),
                priority: element.data['priority'],
                comment: element.data['comment'],
                buyer: c.users[element.data['buyer']] ?? 'Unknown',
                vendor: element.data['vendor'],
                category: element.data['category'],
                discount: RxInt(element.data['discount']),
                dateOrder: (element.data['date_order'] == null ||
                        element.data['date_order'] == '')
                    ? null
                    : DateTime.parse(element.data['date_order']),
                dateDelivery: (element.data['date_delivery'] == null ||
                        element.data['date_delivery'] == '')
                    ? null
                    : DateTime.parse(element.data['date_delivery']),
              ));
            }
          }
          SchedulerBinding.instance.addPostFrameCallback((_) {
            Get.back();
          });
          SchedulerBinding.instance.addPostFrameCallback((_) {
            Get.back();
          });
          // Get.back();
        } else {
          Get.showSnackbar(const GetSnackBar(
            title: 'Warning',
            duration: Duration(seconds: 5),
            message: "Title and Buyer can't be empty",
            borderColor: Colors.red,
            icon: Icon(Icons.warning),
          ));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Purchase order: ${order.title}'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'ID: ${order.id}',
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 300,
                    child: TextField(
                      autofocus: true,
                      textDirection: TextDirection.rtl,
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
                    width: 100,
                    child: x,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 100,
                    child: y,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 8.0),
              child: SizedBox(
                width: 250,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text('Category:    '),
                    Obx(() => DropdownMenu(
                          inputDecorationTheme: const InputDecorationTheme(
                              border: UnderlineInputBorder()),
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
              padding: const EdgeInsetsDirectional.only(start: 8.0),
              child: SizedBox(
                width: 250,
                child: Row(
                  children: [
                    const Text('Priority:       '),
                    Obx(() => DropdownMenu(
                          inputDecorationTheme: const InputDecorationTheme(
                              border: UnderlineInputBorder()),
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
              padding: const EdgeInsetsDirectional.only(start: 8.0),
              child: SizedBox(
                width: 250,
                child: Row(
                  children: [
                    const Text('Buyer:         '),
                    DropdownMenu(
                      inputDecorationTheme: const InputDecorationTheme(
                          border: UnderlineInputBorder()),
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
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 100,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      autofocus: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Unit Price",
                      ),
                      controller: TextEditingController(
                          text: order.unitPrice.toString()),
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
                    width: 100,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      autofocus: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Quantity",
                      ),
                      controller: TextEditingController(
                          text: order.quantity.toString()),
                      onChanged: (value) {
                        order.quantity.value =
                            value == '' ? 0 : int.parse(value);
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 100,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      autofocus: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Discount",
                      ),
                      controller: TextEditingController(
                          text: order.discount.toString()),
                      onChanged: (value) {
                        order.discount.value =
                            value == '' ? 0 : int.parse(value);
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 300,
                    child: Row(children: [
                      const Text(
                        'Total Price:  ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Obx(() => Text(
                            order.totalPrice.toString(),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          )),
                      const Text(
                        ' Tomans',
                        style: TextStyle(fontSize: 12),
                      ),
                    ]),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 200,
                    child: TextField(
                      autofocus: true,
                      textDirection: TextDirection.rtl,
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
                      textDirection: TextDirection.rtl,
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
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Text('Approved: '),
                      Obx(
                        () => AbsorbPointer(
                          absorbing: (c.username.value == 'bonakdar' ||
                                  c.username.value == 'aslani')
                              ? false
                              : true,
                          child: Switch(
                            value: order.approved.value,
                            onChanged: (value) {
                              order.approved.value = value;
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
