import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Timestamp? calculateSelectedDateTime(
  DateTime? selectedDate,
  TimeOfDay? selectedTime,
) {
  if (selectedDate != null) {
    if (selectedTime != null) {
      return Timestamp.fromDate(
        DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        ),
      );
    } else {
      return Timestamp.fromDate(selectedDate);
    }
  }
  return null;
}
