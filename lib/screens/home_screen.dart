import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/reminder_provider.dart';
import '../providers/theme_provider.dart';
import 'form_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    final primaryColor =
        themeProvider.currentThemeColor == AppThemeColor.black
            ? Colors.black
            : themeProvider.currentTheme.primaryColor;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryColor,

        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Daily Reminder',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 2),

            Text(
              'Manage your daily schedule easily',
              style: TextStyle(
                fontSize: 13,
                color: Colors.white70,
              ),
            ),
          ],
        ),

        toolbarHeight: 80,

        actions: [
          PopupMenuButton<AppThemeColor>(
            icon: const Icon(Icons.palette_rounded),

            onSelected: (color) {
              themeProvider.setThemeColor(color);
            },

            itemBuilder: (_) => AppThemeColor.values.map((color) {
              return PopupMenuItem<AppThemeColor>(
                value: color,
                child: Text(
                  '${color.name[0].toUpperCase()}${color.name.substring(1)} Theme',
                ),
              );
            }).toList(),
          ),

          Consumer<ReminderProvider>(
            builder: (context, provider, _) {
              return PopupMenuButton<ReminderSortOption>(
                icon: const Icon(Icons.sort_rounded),

                onSelected: (option) {
                  provider.setSortOption(option);
                },

                itemBuilder: (_) => const [
                  PopupMenuItem(
                    value: ReminderSortOption.byDate,
                    child: Text('Sort by Date'),
                  ),

                  PopupMenuItem(
                    value: ReminderSortOption.byCompletion,
                    child: Text('Sort by Completion'),
                  ),
                ],
              );
            },
          ),
        ],
      ),

      body: Consumer<ReminderProvider>(
        builder: (context, provider, _) {
          final reminders = provider.reminders;

          // 🔥 EMPTY STATE
          if (reminders.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Icon(
                      Icons.notifications_active_rounded,
                      size: 110,
                      color: primaryColor.withOpacity(0.8),
                    ),

                    const SizedBox(height: 25),

                    const Text(
                      'No Reminders Yet',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      'Tap the + button below to add your first reminder.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // 🔥 REMINDER LIST
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: reminders.length,

            itemBuilder: (context, index) {
              final reminder = reminders[index];

              final formattedDate = DateFormat.yMMMEd().add_jm().format(
                    reminder.dateTime,
                  );

              return Container(
                margin: const EdgeInsets.only(bottom: 18),

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),

                child: Material(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.white,

                  child: InkWell(
                    borderRadius: BorderRadius.circular(25),

                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              FormScreen(reminder: reminder),
                        ),
                      );
                    },

                    onLongPress: () {
                      provider.toggleReminderCompletion(
                        reminder.id!,
                        !reminder.isCompleted,
                      );
                    },

                    child: Padding(
                      padding: const EdgeInsets.all(20),

                      child: Row(
                        children: [

                          // 🔥 STATUS ICON
                          Container(
                            width: 60,
                            height: 60,

                            decoration: BoxDecoration(
                              color: reminder.isCompleted
                                  ? Colors.green.withOpacity(0.15)
                                  : primaryColor.withOpacity(0.15),

                              borderRadius: BorderRadius.circular(18),
                            ),

                            child: Icon(
                              reminder.isCompleted
                                  ? Icons.check_circle
                                  : Icons.notifications_active_rounded,

                              color: reminder.isCompleted
                                  ? Colors.green
                                  : primaryColor,

                              size: 32,
                            ),
                          ),

                          const SizedBox(width: 18),

                          // 🔥 TEXT
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,

                              children: [

                                Text(
                                  reminder.title,

                                  style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,

                                    decoration:
                                        reminder.isCompleted
                                            ? TextDecoration.lineThrough
                                            : null,
                                  ),
                                ),

                                const SizedBox(height: 10),

                                Row(
                                  children: [

                                    Icon(
                                      Icons.access_time_rounded,
                                      size: 18,
                                      color: Colors.grey.shade600,
                                    ),

                                    const SizedBox(width: 6),

                                    Expanded(
                                      child: Text(
                                        formattedDate,

                                        style: TextStyle(
                                          color: Colors.grey.shade700,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 12),

                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),

                                  decoration: BoxDecoration(
                                    color: reminder.isCompleted
                                        ? Colors.green.withOpacity(0.15)
                                        : Colors.orange.withOpacity(0.15),

                                    borderRadius:
                                        BorderRadius.circular(30),
                                  ),

                                  child: Text(
                                    reminder.isCompleted
                                        ? 'Completed'
                                        : 'Pending',

                                    style: TextStyle(
                                      color: reminder.isCompleted
                                          ? Colors.green
                                          : Colors.orange,

                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // 🔥 DELETE BUTTON
                          IconButton(
                            icon: const Icon(
                              Icons.delete_outline_rounded,
                              color: Colors.red,
                            ),

                            onPressed: () {
                              showDialog(
                                context: context,

                                builder: (ctx) => AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(20),
                                  ),

                                  title: const Text(
                                    'Delete Reminder?',
                                  ),

                                  content: const Text(
                                    'Are you sure you want to delete this reminder?',
                                  ),

                                  actions: [

                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(ctx).pop();
                                      },

                                      child: const Text('Cancel'),
                                    ),

                                    FilledButton(
                                      style: FilledButton.styleFrom(
                                        backgroundColor: Colors.red,
                                      ),

                                      onPressed: () {
                                        provider.deleteReminder(
                                          reminder.id!,
                                        );

                                        Navigator.of(ctx).pop();
                                      },

                                      child: const Text('Delete'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),

      // 🔥 FLOATING BUTTON
      floatingActionButton: FloatingActionButton.extended(
        elevation: 8,

        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const FormScreen(),
            ),
          );
        },

        backgroundColor: primaryColor,

        icon: const Icon(Icons.add),

        label: const Text(
          'Add Reminder',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}