import 'package:flutter/material.dart';

import '../models/reminder.dart';

class DetailScreen extends StatelessWidget {
  final Reminder reminder;

  const DetailScreen({
    super.key,
    required this.reminder,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor =
        Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor:
          const Color(0xFFF5F7FB),

      appBar: AppBar(
        elevation: 0,

        title: const Text(
          'Reminder Details',
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),

        children: [

          // 🔥 TOP ICON CARD
          Container(
            padding: const EdgeInsets.all(30),

            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  primaryColor,
                  primaryColor.withOpacity(0.75),
                ],
              ),

              borderRadius:
                  BorderRadius.circular(30),

              boxShadow: [
                BoxShadow(
                  color: primaryColor
                      .withOpacity(0.25),

                  blurRadius: 20,

                  offset: const Offset(0, 8),
                ),
              ],
            ),

            child: Column(
              children: [

                const Icon(
                  Icons.notifications_active_rounded,
                  size: 80,
                  color: Colors.white,
                ),

                const SizedBox(height: 20),

                Text(
                  reminder.title,

                  textAlign: TextAlign.center,

                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // 🔥 DESCRIPTION CARD
          Container(
            padding: const EdgeInsets.all(22),

            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius:
                  BorderRadius.circular(25),

              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(
                    0.05,
                  ),

                  blurRadius: 12,
                ),
              ],
            ),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Row(
                  children: [

                    Icon(
                      Icons.description_rounded,
                      color: primaryColor,
                    ),

                    const SizedBox(width: 10),

                    const Text(
                      'Description',

                      style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                Text(
                  reminder.description,

                  style: TextStyle(
                    fontSize: 16,
                    color:
                        Colors.grey.shade800,

                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          // 🔥 DATE CARD
          Container(
            padding: const EdgeInsets.all(22),

            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius:
                  BorderRadius.circular(25),

              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(
                    0.05,
                  ),

                  blurRadius: 12,
                ),
              ],
            ),

            child: Row(
              children: [

                Container(
                  padding:
                      const EdgeInsets.all(14),

                  decoration: BoxDecoration(
                    color: primaryColor
                        .withOpacity(0.12),

                    borderRadius:
                        BorderRadius.circular(
                      18,
                    ),
                  ),

                  child: Icon(
                    Icons.access_time_rounded,
                    color: primaryColor,
                    size: 30,
                  ),
                ),

                const SizedBox(width: 18),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                    children: [

                      const Text(
                        'Reminder Time',

                        style: TextStyle(
                          fontSize: 15,
                          color:
                              Colors.black54,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        reminder
                            .formattedDateTime,

                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          // 🔥 BUTTONS
          Row(
            children: [

              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // 🔥 Edit logic
                  },

                  icon: const Icon(
                    Icons.edit_rounded,
                  ),

                  label: const Text(
                    'Edit',
                  ),

                  style:
                      ElevatedButton.styleFrom(
                    minimumSize:
                        const Size(0, 58),
                  ),
                ),
              ),

              const SizedBox(width: 18),

              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // 🔥 Delete logic
                  },

                  icon: const Icon(
                    Icons.delete_rounded,
                  ),

                  label: const Text(
                    'Delete',
                  ),

                  style:
                      ElevatedButton.styleFrom(
                    minimumSize:
                        const Size(0, 58),

                    backgroundColor:
                        Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}