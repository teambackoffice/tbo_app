import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tbo_app/controller/all_lead_list_controller.dart';
import 'package:tbo_app/controller/edit_lead_controller.dart';
import 'package:tbo_app/modal/all_lead_list_modal.dart';
import 'package:tbo_app/services/remainder_notification/notification_service.dart';

class LeadDetailPage extends StatelessWidget {
  final Leads lead;

  const LeadDetailPage({super.key, required this.lead});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F3),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 16,
                        color: Colors.black,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    "Lead Details",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  const SizedBox(width: 40),
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(lead.status),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        lead.status ?? "Unknown",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Lead Name
                    Text(
                      lead.leadName ?? "N/A",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Contact Information Section
                    _buildSectionTitle("Contact Information"),
                    const SizedBox(height: 12),
                    _buildInfoCard([
                      _buildInfoRow(
                        Icons.business,
                        "Company",
                        lead.companyName ?? "N/A",
                      ),
                      _buildInfoRow(
                        Icons.email_outlined,
                        "Email",
                        lead.emailId ?? "N/A",
                      ),
                      _buildInfoRow(
                        Icons.phone_outlined,
                        "Mobile",
                        lead.mobileNo ?? "N/A",
                      ),
                    ]),
                    const SizedBox(height: 24),

                    // Lead Information Section
                    _buildSectionTitle("Lead Information"),
                    const SizedBox(height: 12),
                    _buildInfoCard([
                      _buildInfoRow(
                        Icons.person_outline,
                        "Lead Owner",
                        lead.leadOwner ?? "N/A",
                      ),
                      _buildInfoRow(
                        Icons.source_outlined,
                        "Lead Id",
                        lead.leadId ?? "N/A",
                      ),
                      _buildInfoRow(
                        Icons.campaign_outlined,
                        "Campaign",
                        lead.campaignName?.toString() ?? "N/A",
                      ),
                    ]),
                    const SizedBox(height: 24),

                    // Business Details Section
                    _buildSectionTitle("Business Details"),
                    const SizedBox(height: 12),
                    _buildInfoCard([
                      _buildInfoRow(
                        Icons.location_on_outlined,
                        "Territory",
                        lead.territory ?? "N/A",
                      ),
                      _buildInfoRow(
                        Icons.category_outlined,
                        "Market Segment",
                        lead.marketSegment ?? "N/A",
                      ),
                      _buildInfoRow(
                        Icons.interests_outlined,
                        "Lead Segment",
                        lead.customLeadSegment ?? "N/A",
                      ),
                      _buildInfoRow(
                        Icons.work_outline,
                        "Project Type",
                        lead.customProjectType ?? "N/A",
                      ),
                    ]),
                    const SizedBox(height: 24),

                    // Reminder Section
                    _buildSectionTitle("Reminder"),
                    const SizedBox(height: 12),
                    _ReminderCard(lead: lead),
                    const SizedBox(height: 24),

                    // Action Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _showQuotationDialog(context);
                        },
                        icon: const Icon(Icons.description_outlined, size: 20),
                        label: const Text("Send Quotation"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1ABC9C),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: const Color(0xFF1ABC9C)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'open':
      case 'new':
        return const Color(0xFF1ABC9C);
      case 'working':
      case 'contacted':
        return const Color(0xFF3498DB);
      case 'qualified':
        return const Color(0xFF9B59B6);
      case 'converted':
        return const Color(0xFF27AE60);
      case 'lost':
      case 'closed':
        return const Color(0xFFE74C3C);
      default:
        return const Color(0xFF95A5A6);
    }
  }

  void _showQuotationDialog(BuildContext context) {
    final controller = Provider.of<EditLeadController>(context, listen: false);

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Consumer<EditLeadController>(
          builder: (context, controller, child) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1ABC9C).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.check_circle_outline,
                      color: Color(0xFF1ABC9C),
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Send Quotation",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Are you sure you want to send a quotation to ${lead.leadName ?? 'this lead'}?",
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9F7F3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDialogInfoRow(
                          "Company",
                          lead.companyName ?? "N/A",
                        ),
                        const SizedBox(height: 8),
                        _buildDialogInfoRow("Email", lead.emailId ?? "N/A"),
                      ],
                    ),
                  ),
                  if (controller.isLoading) ...[
                    const SizedBox(height: 16),
                    const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF1ABC9C),
                      ),
                    ),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: controller.isLoading
                      ? null
                      : () => Navigator.pop(dialogContext),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                ElevatedButton(
                  onPressed: controller.isLoading
                      ? null
                      : () async {
                          // Update lead status to "Quoted" or "Converted"
                          await controller.updateLeadStatus(
                            lead.leadId ?? "",
                            "Quotation", // Change this to your desired status
                          );

                          if (dialogContext.mounted) {
                            Navigator.pop(dialogContext);
                          }

                          if (controller.message != null) {
                            // _showSnackbar(
                            //   context,
                            //   controller.message!.contains("✅")
                            //       ? "Quotation sent successfully!"
                            //       : "Failed to send quotation",
                            //   controller.message!.contains("✅"),
                            // );
                          }

                          // Update local lead status if successful
                          if (controller.message!.contains("✅")) {
                            lead.status = "Qualified";
                          }
                          Navigator.pop(context); // Close the dialog
                          Provider.of<AllLeadListController>(
                            context,
                            listen: false,
                          ).fetchAllLeadList(status: "Open");
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1ABC9C),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: controller.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text("Send"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildDialogInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label: ",
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
        ),
      ],
    );
  }

  void _showSuccessSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 12),
            Text("Quotation sent successfully!"),
          ],
        ),
        backgroundColor: const Color(0xFF1ABC9C),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

// -----------------------------------------------------------------------
// Reminder card: lets the user pick a note + date/time, then schedules
// a local notification via NotificationService.
// -----------------------------------------------------------------------

// -----------------------------------------------------------------------
// Reminder card: lets the user pick a note + date/time, confirms via a
// dialog, then schedules a local notification via RemainderNotificationService.
// -----------------------------------------------------------------------
class _ReminderCard extends StatefulWidget {
  final Leads lead;
  const _ReminderCard({required this.lead});

  @override
  State<_ReminderCard> createState() => _ReminderCardState();
}

class _ReminderCardState extends State<_ReminderCard> {
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
