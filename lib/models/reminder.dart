import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Reminder {

  final String? id;

  final String title;

  final String description;

  final DateTime dateTime;

  final bool isCompleted;

  const Reminder({
    this.id,
    required this.title,
    required this.description,
    required this.dateTime,
    this.isCompleted = false,
  });

  // 🔥 FORMAT DATE
  String get formattedDateTime {
    return DateFormat(
      'EEEE, MMM d • HH:mm',
    ).format(dateTime);
  }

  // 🔥 COPY WITH
  Reminder copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dateTime,
    bool? isCompleted,
  }) {
    return Reminder(
      id: id ?? this.id,

      title: title ?? this.title,

      description:
          description ?? this.description,

      dateTime:
          dateTime ?? this.dateTime,

      isCompleted:
          isCompleted ?? this.isCompleted,
    );
  }

  // 🔥 LOCAL MAP
  Map<String, dynamic> toMap() {
    return {
      'id': id,

      'title': title,

      'description': description,

      'dateTime':
          dateTime.toIso8601String(),

      'isCompleted': isCompleted,
    };
  }

  // 🔥 FROM MAP
  factory Reminder.fromMap(
    Map<String, dynamic> map,
  ) {
    return Reminder(
      id: map['id']?.toString(),

      title: map['title'] ?? '',

      description:
          map['description'] ?? '',

      dateTime:
          _parseDateTime(
        map['dateTime'],
      ),

      isCompleted:
          map['isCompleted'] == true ||
          map['isCompleted'] == 1,
    );
  }

  // 🔥 FIRESTORE MAP
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,

      'description': description,

      'dateTime':
          Timestamp.fromDate(dateTime),

      'isCompleted': isCompleted,
    };
  }

  // 🔥 FROM FIRESTORE
  factory Reminder.fromFirestore(
    DocumentSnapshot doc,
  ) {
    final data =
        doc.data()
            as Map<String, dynamic>;

    return Reminder(
      id: doc.id,

      title: data['title'] ?? '',

      description:
          data['description'] ?? '',

      dateTime:
          _parseDateTime(
        data['dateTime'],
      ),

      isCompleted:
          data['isCompleted'] ?? false,
    );
  }

  // 🔥 SAFE DATE PARSER
  static DateTime _parseDateTime(
    dynamic value,
  ) {

    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is String) {
      return DateTime.tryParse(value)
              ?.toLocal() ??
          DateTime.now();
    }

    return DateTime.now();
  }
}