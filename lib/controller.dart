import 'package:get/get.dart';
import 'package:purchase/grid_data_source.dart';
import 'package:purchase/main.dart';
import 'package:purchase/order.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class Controller extends GetxController {
  var username = ''.obs;
  var password = ''.obs;
  var orders = <Order>[].obs;
  var actionButtonsVisible = false.obs;
  var gridDataSource = GridDataSource(orders: []).obs;
  var dataGridController = DataGridController().obs;
  var selectedIndex = 0.obs;
  Map<String, String> users = {};
  var categories = RxList<String>();
  var priorities = RxList<String>();
  Future<void> init() async {
    var uresp = await database.getAllUsers();
    priorities.value = await database.getAllPriorities();
    categories.value = await database.getAllCategories();
    for (var element in uresp) {
      users[element.id] = element.data['name'];
    }
    var resp = await database.getAllOrders();
    orders.clear();
    for (var element in resp) {
      orders.add(Order(
        id: element.id,
        title: element.data['title'],
        quantity: RxInt(element.data['quantity']),
        unitPrice: RxInt(element.data['unit_price']),
        approved: RxBool(element.data['approved']),
        delivered: RxBool(element.data['delivered']),
        payed: RxBool(element.data['payed']),
        priority: element.data['priority'],
        comment: element.data['comment'],
        buyer: users[element.data['buyer']] ?? 'Unknown',
        vendor: element.data['vendor'],
        category: element.data['category'],
        discount: RxInt(element.data['discount']),
        dateOrder: (element.data['date_order'] == null ||
                element.data['date_order'] == '')
            ? null
            : DateTime.parse(element.data['date_order']),
        dateDelivery: (element.data['delivery_date'] == null ||
                element.data['delivery_date'] == '')
            ? null
            : DateTime.parse(element.data['delivery_date']),
      ));
    }
    gridDataSource.value = GridDataSource(orders: orders);
    dataGridController.value.notifyListeners();
  }
}
