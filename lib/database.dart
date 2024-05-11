import 'package:pocketbase/pocketbase.dart';
import 'package:purchase/main.dart';
import 'package:purchase/order.dart';

class Database {
  final _pb = PocketBase('http://192.168.10.58:32768');
  // final _pb = PocketBase('http://127.0.0.1');
  bool get isAuth {
    return _pb.authStore.isValid && _pb.authStore.token.isNotEmpty;
  }

  Future<List<RecordModel>> getAllOrders() async {
    var resp = await _pb.collection('orders').getFullList(
          sort: '-created',
        );
    return resp;
  }

  Future<List<RecordModel>> getAllUsers() async {
    var resp = await _pb.collection('users').getFullList(
          sort: '-created',
        );
    return resp;
  }

  Future<List<String>> getAllCategories() async {
    var resp = await _pb.collection('categories').getFullList(
          sort: '-created',
        );
    return resp.map((e) => e.data['title'].toString()).toList();
  }

  Future<List<String>> getAllPriorities() async {
    var resp = await _pb.collection('priorities').getFullList(
          sort: '-created',
        );
    return resp.map((e) => e.data['title'].toString()).toList();
  }

  Future<void> initialSync() async {}

  Future<void> login(String email, String password) async {
    await _pb.collection('users').authWithPassword(
          email,
          password,
        );
  }

  Future<void> init() async {
    _pb.collection('orders').subscribe(
      '*',
      (e) {
        c.init();
      },
    );
  }

  Future<void> updateOrder(Order order) async {
    String id = order.id;
    final body = <String, dynamic>{
      'title': order.title,
      'quantity': order.quantity.value,
      'unit_price': order.unitPrice.value,
      'total_price': order.totalPrice,
      'approved': order.approved.value,
      'priority': order.priority,
      'category': order.category,
      'buyer': c.users.entries
          .firstWhere((element) => element.value == order.buyer)
          .key,
      'vendor': order.vendor,
      'date_order': order.dateOrder.toString(),
      'delivery_date': order.dateDelivery.toString(),
      'delivered': order.delivered.value,
      'payed': order.payed.value,
      'discount': order.discount.value,
      'comment': order.comment,
      'archive': order.archive.value,
    };
    final record = await _pb.collection('orders').update(id, body: body);
  }

  Future<void> createOrder(Order order) async {
    final body = <String, dynamic>{
      'title': order.title,
      'quantity': order.quantity.value,
      'unit_price': order.unitPrice.value,
      'total_price': order.totalPrice,
      'approved': order.approved.value,
      'priority': order.priority,
      'category': order.category,
      'buyer': c.users.entries
          .firstWhere((element) => element.value == order.buyer)
          .key,
      'vendor': order.vendor,
      'date_order': order.dateOrder.toString(),
      'delivery_date': order.dateDelivery.toString(),
      'delivered': order.delivered.value,
      'payed': order.payed.value,
      'discount': order.discount.value,
      'comment': order.comment,
      'archive': order.archive.value,
    };
    final record = await _pb.collection('orders').create(body: body);
  }

  Future<void> removeOrder(Order order) async {
    await _pb.collection('orders').delete(order.id);
  }
}
