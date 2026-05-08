import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../models/reminder.dart';
import '../providers/reminder_provider.dart';

class FormScreen extends StatefulWidget {
  final Reminder? reminder;

  const FormScreen({super.key, this.reminder});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  DateTime? _selectedDateTime;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(
      text: widget.reminder?.title ?? '',
    );

    _descriptionController = TextEditingController(
      text: widget.reminder?.description ?? '',
    );

    _selectedDateTime = widget.reminder?.dateTime;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();

    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final now = DateTime.now();

    final initialDate = _selectedDateTime ?? now;

    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: now,
      lastDate: DateTime(2100),
    );

    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDate),
    );

    if (time == null) return;

    setState(() {
      _selectedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  void _saveReminder() {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select date and time'),
        ),
      );

      return;
    }

    final reminder = Reminder(
      id: widget.reminder?.id,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      dateTime: _selectedDateTime!,
      isCompleted: widget.reminder?.isCompleted ?? false,
    );

    final provider = Provider.of<ReminderProvider>(
      context,
      listen: false,
    );

    if (widget.reminder == null) {
      provider.addReminder(reminder);
    } else {
      provider.updateReminder(reminder);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.reminder != null;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      appBar: AppBar(
        elevation: 0,

        title: Text(
          isEditing
              ? 'Edit Reminder'
              : 'Add Reminder',
        ),
      ),

      body: Form(
        key: _formKey,

        child: ListView(
          padding: const EdgeInsets.all(20),

          children: [

            // 🔥 TITLE
            const Text(
              'Reminder Title',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            TextFormField(
              controller: _titleController,

              decoration: InputDecoration(
                hintText: 'Enter reminder title',

                prefixIcon: const Icon(
                  Icons.title_rounded,
                ),

                filled: true,
                fillColor: Colors.white,

                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(18),

                  borderSide: BorderSide.none,
                ),
              ),

              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty) {
                  return 'Title cannot be empty';
                }

                return null;
              },
            ),

            const SizedBox(height: 25),

            // 🔥 DESCRIPTION
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            TextFormField(
              controller: _descriptionController,
              maxLines: 5,

              decoration: InputDecoration(
                hintText: 'Enter reminder description',

                prefixIcon: const Padding(
                  padding: EdgeInsets.only(
                    bottom: 80,
                  ),

                  child: Icon(
                    Icons.description_rounded,
                  ),
                ),

                filled: true,
                fillColor: Colors.white,

                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(18),

                  borderSide: BorderSide.none,
                ),
              ),

              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty) {
                  return 'Description cannot be empty';
                }

                return null;
              },
            ),

            const SizedBox(height: 25),

            // 🔥 DATE TIME CARD
            const Text(
              'Schedule',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            InkWell(
              borderRadius: BorderRadius.circular(20),

              onTap: _pickDateTime,

              child: Container(
                padding: const EdgeInsets.all(18),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius:
                      BorderRadius.circular(20),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(
                        0.05,
                      ),

                      blurRadius: 10,
                    ),
                  ],
                ),

                child: Row(
                  children: [

                    Container(
                      padding: const EdgeInsets.all(12),

                      decoration: BoxDecoration(
                        color: Colors.blue
                            .withOpacity(0.12),

                        borderRadius:
                            BorderRadius.circular(15),
                      ),

                      child: const Icon(
                        Icons.calendar_month_rounded,
                        color: Colors.blue,
                      ),
                    ),

                    const SizedBox(width: 15),

                    Expanded(
                      child: Text(
                        _selectedDateTime != null
                            ? DateFormat.yMMMEd()
                                .add_jm()
                                .format(
                                  _selectedDateTime!,
                                )
                            : 'Select date & time',

                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),

            // 🔥 BUTTON
            SizedBox(
              height: 58,

              child: ElevatedButton.icon(
                onPressed: _saveReminder,

                icon: Icon(
                  isEditing
                      ? Icons.save_rounded
                      : Icons.add_rounded,
                ),

                label: Text(
                  isEditing
                      ? 'Save Changes'
                      : 'Add Reminder',

                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFF5B67F1),

                  foregroundColor: Colors.white,

                  elevation: 8,

                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}