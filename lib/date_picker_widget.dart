import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
// import 'package:shamsi_date/shamsi_date.dart';

class DatePickerTextField extends StatelessWidget {
  DatePickerTextField(
      {super.key, required this.label, required this.initialDate});
  final TextEditingController _dateController = TextEditingController();
  final String label;
  late DateTime? initialDate;
  DateTime? dateTime;
  @override
  Widget build(BuildContext context) {
    _dateController.text =
        '${initialDate?.toJalali().year}/${initialDate?.toJalali().month}/${initialDate?.toJalali().day}';
    dateTime = initialDate;
    return TextField(
      readOnly: true,
      controller: _dateController,
      decoration: InputDecoration(
        border: const UnderlineInputBorder(),
        labelText: label,
      ),
      onTap: () async {
        var item = await showPersianDatePicker(
            context: context,
            initialDate: Jalali.now(),
            firstDate: Jalali(1400),
            lastDate: Jalali(1500));
        DateTime? pickedDate = item?.toDateTime();
        if (pickedDate != null) {
          _dateController.text = '${item?.year}/${item?.month}/${item?.day}';
          dateTime = pickedDate;
        } else {
          dateTime = initialDate;
        }
      },
    );
  }
}
