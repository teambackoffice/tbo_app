import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tbo_app/modal/all_lead_list_modal.dart';
import 'package:tbo_app/services/remainder_notification/notification_service.dart';

// -----------------------------------------------------------------------
// Reusable Reminder card: lets the user pick a note + date/time, confirms
// via a dialog, then schedules a local notification via
// RemainderNotificationService. Persists state in SharedPreferences.
// -----------------------------------------------------------------------
class ReminderCard extends StatefulWidget {
  final Leads lead;
  const ReminderCard({super.key, required this.lead});

  @override
  State<ReminderCard> createState() => _ReminderCardState();
}

class _ReminderCardState extends State<ReminderCard> {
  static const Color _teal = Color(0xFF1ABC9C);
  static const Color _bg = Color(0xFFF9F7F3);

  final TextEditingController _noteController = TextEditingController();
  DateTime? _selectedDateTime;
  bool _isSaving = false;
  bool _hasActiveReminder = false;

  String get _prefsKey =>
      'reminder_${widget.lead.leadId ?? widget.lead.hashCode}';

  @override
  void initState() {
    super.initState();
    _loadSavedReminder();
  }

  Future<void> _loadSavedReminder() async {
    final prefs = await SharedPreferences.getInstance();
    final savedMillis = prefs.getInt('${_prefsKey}_time');
    final savedNote = prefs.getString('${_prefsKey}_note');

    if (savedMillis != null) {
      final savedDateTime =
          DateTime.fromMillisecondsSinceEpoch(savedMillis);

      // If the reminder time has already passed, clear it and keep card clean
      if (savedDateTime.isBefore(DateTime.now())) {
        await _clearPersistedReminder();
        return;
      }

      // Reminder is still in the future — restore it
      if (mounted) {
        setState(() {
          _selectedDateTime = savedDateTime;
          _hasActiveReminder = true;
          if (savedNote != null && savedNote.isNotEmpty) {
            _noteController.text = savedNote;
          }
        });
      }
    }
  }

  Future<void> _persistReminder() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
      '${_prefsKey}_time',
      _selectedDateTime!.millisecondsSinceEpoch,
    );
    await prefs.setString('${_prefsKey}_note', _noteController.text.trim());
  }

  Future<void> _clearPersistedReminder() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('${_prefsKey}_time');
    await prefs.remove('${_prefsKey}_note');
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(primary: _teal),
        ),
        child: child!,
      ),
    );
    if (date == null) return;
    if (!mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: _selectedDateTime != null
          ? TimeOfDay.fromDateTime(_selectedDateTime!)
          : const TimeOfDay(hour: 11, minute: 0),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(primary: _teal),
        ),
        child: child!,
      ),
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

  void _clearDateTime() {
    setState(() {
      _selectedDateTime = null;
      _hasActiveReminder = false;
    });
    _clearPersistedReminder();
    // Also cancel the scheduled notification
    final leadId = widget.lead.leadId ?? widget.lead.hashCode.toString();
    RemainderNotificationService().cancelReminder(leadId.hashCode);
  }

  String get _formattedDate {
    if (_selectedDateTime == null) return "";
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    final now = DateTime.now();
    final d = _selectedDateTime!;
    final isToday =
        d.year == now.year && d.month == now.month && d.day == now.day;
    final tomorrow = now.add(const Duration(days: 1));
    final isTomorrow =
        d.year == tomorrow.year &&
        d.month == tomorrow.month &&
        d.day == tomorrow.day;

    if (isToday) return "Today";
    if (isTomorrow) return "Tomorrow";
    return "${d.day} ${months[d.month - 1]} ${d.year}";
  }

  String get _formattedTime {
    if (_selectedDateTime == null) return "";
    return TimeOfDay.fromDateTime(_selectedDateTime!).format(context);
  }

  Future<void> _onSetReminderPressed() async {
    if (_selectedDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: const Text("Please pick a date and time first"),
        ),
      );
      return;
    }

    if (_selectedDateTime!.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: const Text("Please pick a time in the future"),
        ),
      );
      return;
    }

    final confirmed = await _showConfirmDialog();
    if (confirmed != true) return;

    await _saveReminder();
  }

  Future<bool?> _showConfirmDialog() {
    final note = _noteController.text.trim().isEmpty
        ? "Follow up with ${widget.lead.leadName ?? 'this lead'}"
        : _noteController.text.trim();

    return showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _teal.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.notifications_active_rounded,
                  color: _teal,
                  size: 26,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  "Confirm Reminder",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "You'll be reminded about ${widget.lead.leadName ?? 'this lead'}:",
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _bg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.sticky_note_2_outlined,
                          size: 18,
                          color: _teal,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            note,
                            style: const TextStyle(
                              fontSize: 13.5,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(
                          Icons.event_outlined,
                          size: 18,
                          color: _teal,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "$_formattedDate  •  $_formattedTime",
                          style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: _teal,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveReminder() async {
    setState(() => _isSaving = true);

    final leadId = widget.lead.leadId ?? widget.lead.hashCode.toString();
    final note = _noteController.text.trim().isEmpty
        ? "Follow up with ${widget.lead.leadName ?? 'this lead'}"
        : _noteController.text.trim();

    try {
      await RemainderNotificationService().scheduleLeadReminder(
        id: leadId.hashCode,
        title: "Lead Reminder",
        body: note,
        scheduledDateTime: _selectedDateTime!,
      );

      // Persist the reminder so it shows when returning to this page
      await _persistReminder();
      if (mounted) setState(() => _hasActiveReminder = true);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: _teal,
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Reminder set for $_formattedDate at $_formattedTime",
                ),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: Text("Failed to set reminder: $e"),
        ),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasDateTime = _selectedDateTime != null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEFEBE3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _teal.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  _hasActiveReminder
                      ? Icons.alarm_on_rounded
                      : Icons.alarm_add_rounded,
                  color: _teal,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                _hasActiveReminder ? "Reminder Active" : "Set a Reminder",
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (_hasActiveReminder) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: _teal.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    "✓ Set",
                    style: TextStyle(
                      color: _teal,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 14),

          // Note field
          TextField(
            controller: _noteController,
            maxLines: 2,
            minLines: 1,
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              hintText: "e.g. Call this lead tomorrow",
              hintStyle: const TextStyle(fontSize: 13.5, color: Colors.grey),
              filled: true,
              fillColor: _bg,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Date/time picker chip
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: _pickDateTime,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: hasDateTime ? _teal.withOpacity(0.08) : _bg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: hasDateTime
                      ? _teal.withOpacity(0.4)
                      : Colors.transparent,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_month_rounded,
                    size: 19,
                    color: hasDateTime ? _teal : Colors.grey[600],
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      hasDateTime
                          ? "$_formattedDate  •  $_formattedTime"
                          : "Pick date & time",
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: hasDateTime
                            ? FontWeight.w600
                            : FontWeight.w500,
                        color: hasDateTime ? Colors.black87 : Colors.grey[600],
                      ),
                    ),
                  ),
                  if (hasDateTime)
                    InkWell(
                      onTap: _clearDateTime,
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: Icon(
                          Icons.close_rounded,
                          size: 17,
                          color: Colors.grey[600],
                        ),
                      ),
                    )
                  else
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 19,
                      color: Colors.grey[400],
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Save button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isSaving ? null : _onSetReminderPressed,
              icon: _isSaving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.notifications_active_outlined, size: 18),
              label: Text(_isSaving ? "Setting reminder..." : "Set Reminder"),
              style: ElevatedButton.styleFrom(
                backgroundColor: _teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
