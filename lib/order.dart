import 'package:get/get.dart';

class Order {
  String id;
  String title = "";
  var quantity = 1.obs;
  var unitPrice = 0.obs;
  var discount = 0.obs;
  int get totalPrice {
    return unitPrice.value * quantity.value - discount.value;
  }

  var approved = false.obs;
  var delivered = false.obs;
  var payed = false.obs;
  var archive = false.obs;
  String priority = 'low';
  String comment = '';
  String buyer = '';
  String vendor = '';
  String category = '';
  DateTime? dateOrder;
  DateTime? dateDelivery;

  Order(
      {required this.id,
      required this.title,
      required this.quantity,
      required this.unitPrice,
      required this.approved,
      required this.delivered,
      required this.payed,
      required this.priority,
      required this.comment,
      required this.buyer,
      required this.vendor,
      required this.category,
      required this.discount,
      this.dateOrder,
      this.dateDelivery});
}
