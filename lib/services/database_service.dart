import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/reminder.dart';

class DatabaseService {

  final CollectionReference
      _remindersCollection =
      FirebaseFirestore.instance
          .collection('reminders');

  // 🔥 GET ALL
  Future<List<Reminder>>
      getAllReminders() async {

    try {

      final snapshot =
          await _remindersCollection
              .orderBy(
                'dateTime',
                descending: false,
              )
              .get();

      return snapshot.docs.map((doc) {

        return Reminder.fromMap({
          ...(doc.data()
              as Map<String, dynamic>),

          'id': doc.id,
        });

      }).toList();

    } catch (e) {

      debugPrint(
        'Get Reminder Error: $e',
      );

      return [];
    }
  }

  // 🔥 INSERT
  Future<String> insertReminder(
    Reminder reminder,
  ) async {

    try {

      final docRef =
          _remindersCollection.doc();

      final reminderWithId =
          reminder.copyWith(
        id: docRef.id,
      );

      await docRef.set(
        reminderWithId.toMap(),
      );

      debugPrint(
        'Reminder Added: ${docRef.id}',
      );

      return docRef.id;

    } catch (e) {

      debugPrint(
        'Insert Reminder Error: $e',
      );

      rethrow;
    }
  }

  // 🔥 UPDATE
  Future<void> updateReminder(
    Reminder reminder,
  ) async {

    try {

      if (reminder.id == null) return;

      await _remindersCollection
          .doc(reminder.id)
          .update(reminder.toMap());

      debugPrint(
        'Reminder Updated: ${reminder.id}',
      );

    } catch (e) {

      debugPrint(
        'Update Reminder Error: $e',
      );

      rethrow;
    }
  }

  // 🔥 DELETE
  Future<void> deleteReminder(
    String id,
  ) async {

    try {

      await _remindersCollection
          .doc(id)
          .delete();

      debugPrint(
        'Reminder Deleted: $id',
      );

    } catch (e) {

      debugPrint(
        'Delete Reminder Error: $e',
      );

      rethrow;
    }
  }
}