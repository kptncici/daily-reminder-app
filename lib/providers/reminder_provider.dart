import 'package:flutter/material.dart';

import '../models/reminder.dart';
import '../services/database_service.dart';
import '../services/notification_service.dart';
import '../services/storage_service.dart';

enum ReminderSortOption {
  byDate,
  byCompletion,
}

class ReminderProvider with ChangeNotifier {

  final DatabaseService _databaseService =
      DatabaseService();

  final NotificationService
      _notificationService =
      NotificationService();

  final StorageService
      _storageService =
      StorageService();

  List<Reminder> _reminders = [];

  ReminderSortOption _sortOption =
      ReminderSortOption.byDate;

  bool _isLoading = false;

  String? _error;

  // 🔥 GETTERS
  List<Reminder> get reminders =>
      [..._reminders];

  ReminderSortOption get sortOption =>
      _sortOption;

  bool get isLoading => _isLoading;

  String? get error => _error;

  ReminderProvider() {
    loadReminders();
  }

  // 🔥 LOADING STATE
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // 🔥 ERROR HANDLER
  void _setError(String? message) {
    _error = message;
    notifyListeners();
  }

  // 🔥 LOAD REMINDERS
  Future<void> loadReminders() async {
    try {
      _setLoading(true);

      _reminders =
          await _databaseService
              .getAllReminders();

      // 🔥 BACKUP FIREBASE
      if (_reminders.isEmpty) {
        final firebaseReminders =
            await _storageService
                .loadRemindersFromFirebase();

        for (final reminder
            in firebaseReminders) {

          await _databaseService
              .insertReminder(reminder);
        }

        _reminders =
            await _databaseService
                .getAllReminders();
      }

      _sortReminders();

      _setError(null);

    } catch (e) {

      _setError(
        'Failed to load reminders',
      );

      debugPrint(
        'Load Reminder Error: $e',
      );

    } finally {

      _setLoading(false);
    }
  }

  // 🔥 SORT OPTION
  void setSortOption(
    ReminderSortOption option,
  ) {
    _sortOption = option;

    _sortReminders();

    notifyListeners();
  }

  // 🔥 SORTING
  void _sortReminders() {

    if (_sortOption ==
        ReminderSortOption.byDate) {

      _reminders.sort(
        (a, b) =>
            a.dateTime.compareTo(
              b.dateTime,
            ),
      );

    } else {

      _reminders.sort((a, b) {

        if (a.isCompleted ==
            b.isCompleted) {

          return a.dateTime.compareTo(
            b.dateTime,
          );
        }

        return a.isCompleted
            ? 1
            : -1;
      });
    }
  }

  // 🔥 ADD REMINDER
  Future<void> addReminder(
    Reminder reminder,
  ) async {

    try {

      // 🔥 ANTI DUPLICATE
      final exists =
          _reminders.any(
        (r) =>
            r.title ==
                reminder.title &&
            r.dateTime ==
                reminder.dateTime,
      );

      if (exists) {
        _setError(
          'Reminder already exists',
        );

        return;
      }

      final id =
          await _databaseService
              .insertReminder(reminder);

      final newReminder =
          reminder.copyWith(id: id);

      _reminders.add(newReminder);

      await _notificationService
          .scheduleMultipleNotifications(
        newReminder,
      );

      await _storageService
          .saveReminderToFirebase(
        newReminder,
      );

      _sortReminders();

      _setError(null);

      notifyListeners();

    } catch (e) {

      _setError(
        'Failed to add reminder',
      );

      debugPrint(
        'Add Reminder Error: $e',
      );
    }
  }

  // 🔥 UPDATE
  Future<void> updateReminder(
    Reminder reminder,
  ) async {

    try {

      await _databaseService
          .updateReminder(reminder);

      final index =
          _reminders.indexWhere(
        (r) => r.id == reminder.id,
      );

      if (index != -1) {

        _reminders[index] = reminder;

        await _notificationService
            .cancelNotifications(
          reminder.id!,
        );

        await _notificationService
            .scheduleMultipleNotifications(
          reminder,
        );

        await _storageService
            .saveReminderToFirebase(
          reminder,
        );

        _sortReminders();

        _setError(null);

        notifyListeners();
      }

    } catch (e) {

      _setError(
        'Failed to update reminder',
      );

      debugPrint(
        'Update Reminder Error: $e',
      );
    }
  }

  // 🔥 DELETE
  Future<void> deleteReminder(
    String id,
  ) async {

    try {

      await _databaseService
          .deleteReminder(id);

      _reminders.removeWhere(
        (r) => r.id == id,
      );

      await _notificationService
          .cancelNotifications(id);

      await _storageService
          .deleteReminderFromFirebase(
        id,
      );

      _setError(null);

      notifyListeners();

    } catch (e) {

      _setError(
        'Failed to delete reminder',
      );

      debugPrint(
        'Delete Reminder Error: $e',
      );
    }
  }

  // 🔥 TOGGLE COMPLETE
  Future<void>
      toggleReminderCompletion(
    String id,
    bool isCompleted,
  ) async {

    try {

      final index =
          _reminders.indexWhere(
        (r) => r.id == id,
      );

      if (index != -1) {

        final updatedReminder =
            _reminders[index].copyWith(
          isCompleted: isCompleted,
        );

        await _databaseService
            .updateReminder(
          updatedReminder,
        );

        await _storageService
            .saveReminderToFirebase(
          updatedReminder,
        );

        _reminders[index] =
            updatedReminder;

        _sortReminders();

        _setError(null);

        notifyListeners();
      }

    } catch (e) {

      _setError(
        'Failed to update status',
      );

      debugPrint(
        'Toggle Reminder Error: $e',
      );
    }
  }
}