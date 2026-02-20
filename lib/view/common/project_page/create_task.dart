import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tbo_app/controller/all_employees._controller.dart';
import 'package:tbo_app/controller/create_task_controller.dart';
import 'package:tbo_app/controller/get_admin_Task_list_controller.dart';
import 'package:tbo_app/modal/all_employees.modal.dart';
import 'package:tbo_app/widgets/authenticated_avatar.dart';

class CreateTaskPage extends StatefulWidget {
  final String? initialProject;
  const CreateTaskPage({super.key, this.initialProject});

  @override
  State<CreateTaskPage> createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  // Controllers
  late TextEditingController _projectCtrl;
  final _subjectCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  // Selected employee
  Message? _selectedEmployee;

  String _priority = 'Low';
  String _status = 'Open';
  DateTime? _startDate;
  DateTime? _endDate;

  final List<String> _priorities = ['Low', 'Medium', 'High', 'Urgent'];
  final List<String> _statuses = [
    'Open',
    'Working',
    'Pending Review',
    'Overdue',
    'Template',
    'Completed',
    'Cancelled',
  ];

  // Theme colors — light/white palette
  static const _bg = Color(0xFFF5F6FA);
  static const _surface = Color(0xFFFFFFFF);
  static const _surfaceAlt = Color(0xFFF0F1F8);
  static const _accent = Color(0xFF6C63FF);
  static const _accentLight = Color(0xFF9D97FF);
  static const _textPrimary = Color(0xFF1A1D27);
  static const _textSecondary = Color(0xFF7A7F9A);
  static const _border = Color(0xFFE2E4F0);

  @override
  void initState() {
    super.initState();
    _projectCtrl = TextEditingController(text: widget.initialProject);
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _projectCtrl.dispose();
    _subjectCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate(bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (ctx, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(
            primary: _accent,
            onPrimary: Colors.white,
            surface: _surface,
            onSurface: _textPrimary,
          ),
          dialogTheme: const DialogThemeData(backgroundColor: _surface),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  String _formatDateForApi(DateTime? date) {
    if (date == null) return '';
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String _formatDateForUi(DateTime? date) {
    if (date == null) return 'Select date';
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
  }

  // ─── Employee Picker Bottom Sheet ──────────────────────────────────────────

  Future<void> _showEmployeePicker() async {
    final controller = AllEmployeesController();
    await controller.fetchallemployees();

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ChangeNotifierProvider.value(
        value: controller,
        child: _EmployeePickerSheet(
          onSelected: (employee) {
            setState(() => _selectedEmployee = employee);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  // ─── Submit ────────────────────────────────────────────────────────────────

  Future<void> _submit(CreateTaskController controller) async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedEmployee == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(_snackBar('Please select an employee', isError: true));
      return;
    }
    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        _snackBar('Please select both start and end dates', isError: true),
      );
      return;
    }

    await controller.createTask(
      project: _projectCtrl.text.trim(),
      subject: _subjectCtrl.text.trim(),
      assignedEmployee: _selectedEmployee!.name,
      priority: _priority,
      description: _descCtrl.text.trim(),
      expStartDate: _formatDateForApi(_startDate),
      expEndDate: _formatDateForApi(_endDate),
      status: "Open",
    );

    if (!mounted) return;

    if (controller.errorMessage != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(_snackBar(controller.errorMessage!, isError: true));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(_snackBar('Task created successfully!'));
      Navigator.pop(context, controller.responseData);
    }
    context.read<GetAdminTaskListController>().fetchProjectDetails(
      projectId: widget.initialProject!,
    );
  }

  SnackBar _snackBar(String msg, {bool isError = false}) {
    return SnackBar(
      content: Text(
        msg,
        style: const TextStyle(color: Colors.white, fontFamily: 'monospace'),
      ),
      backgroundColor: isError
          ? const Color(0xFFE05C6B)
          : const Color(0xFF3DDC97),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(16),
    );
  }

  Color _priorityColor(String p) {
    switch (p) {
      case 'Low':
        return const Color(0xFF2BBF7A);
      case 'Medium':
        return const Color(0xFFE89B00);
      case 'High':
        return const Color(0xFFE05A20);
      case 'Urgent':
        return const Color(0xFFD63B4E);
      default:
        return _accent;
    }
  }

  // ─── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CreateTaskController(),
      child: Consumer<CreateTaskController>(
        builder: (context, controller, _) {
          return Scaffold(
            backgroundColor: _bg,
            body: FadeTransition(
              opacity: _fadeAnim,
              child: CustomScrollView(
                slivers: [
                  _buildAppBar(),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
                    sliver: SliverToBoxAdapter(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _sectionLabel('TASK DETAILS'),
                            const SizedBox(height: 12),
                            _buildCard(
                              children: [
                                _buildField(
                                  controller: _subjectCtrl,
                                  label: 'Task Subject',
                                  hint: 'What needs to be done?',
                                  icon: Icons.title_rounded,
                                  validator: (v) => (v == null || v.isEmpty)
                                      ? 'Subject is required'
                                      : null,
                                ),
                                _divider(),
                                _buildField(
                                  controller: _projectCtrl,
                                  label: 'Project',
                                  hint: 'Project name or ID',
                                  icon: Icons.folder_outlined,
                                  validator: (v) => (v == null || v.isEmpty)
                                      ? 'Project is required'
                                      : null,
                                ),
                                _divider(),
                                _buildEmployeePicker(),
                              ],
                            ),
                            const SizedBox(height: 24),
                            _sectionLabel('PRIORITY'),
                            const SizedBox(height: 12),
                            _buildCard(
                              children: [
                                _buildDropdownRow(
                                  label: 'Priority',
                                  icon: Icons.flag_outlined,
                                  value: _priority,
                                  items: _priorities,
                                  onChanged: (v) =>
                                      setState(() => _priority = v!),
                                  itemColor: _priorityColor,
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            _sectionLabel('TIMELINE'),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildDateTile(
                                    label: 'Start Date',
                                    date: _startDate,
                                    onTap: () => _pickDate(true),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildDateTile(
                                    label: 'End Date',
                                    date: _endDate,
                                    onTap: () => _pickDate(false),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            _sectionLabel('DESCRIPTION'),
                            const SizedBox(height: 12),
                            _buildCard(children: [_buildDescField()]),
                            const SizedBox(height: 32),
                            _buildSubmitButton(controller),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ─── Employee Picker Tile ──────────────────────────────────────────────────

  Widget _buildEmployeePicker() {
    final hasEmployee = _selectedEmployee != null;
    return InkWell(
      onTap: _showEmployeePicker,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            // Avatar or icon
            if (hasEmployee && _selectedEmployee!.imageUrl.isNotEmpty)
              AuthenticatedAvatar(
                radius: 16,
                imageUrl: _selectedEmployee!.imageUrl,
                name: _selectedEmployee!.employeeName,
                backgroundColor: _surfaceAlt,
                initialsFontSize: 10,
              )
            else
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: hasEmployee ? _accent.withOpacity(0.1) : _surfaceAlt,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person_outline_rounded,
                  color: hasEmployee ? _accent : _textSecondary,
                  size: 18,
                ),
              ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Assigned Employee',
                    style: TextStyle(
                      color: _textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    hasEmployee
                        ? _selectedEmployee!.employeeName
                        : 'Select an employee',
                    style: TextStyle(
                      color: hasEmployee
                          ? _textPrimary
                          : const Color(0xFFBBC0D4),
                      fontSize: 14,
                      fontWeight: hasEmployee
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                  if (hasEmployee) ...[
                    const SizedBox(height: 1),
                    Text(
                      _selectedEmployee!.designation,
                      style: const TextStyle(
                        color: _textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: _textSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  // ─── Shared Widgets ────────────────────────────────────────────────────────

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      pinned: true,
      backgroundColor: _bg,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      shadowColor: _border,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: _surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: _border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(
            Icons.arrow_back_rounded,
            color: _textPrimary,
            size: 20,
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              width: 6,
              height: 28,
              decoration: BoxDecoration(
                color: Color(0xFF129476),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(width: 30),
            const Text(
              'Create Task',
              style: TextStyle(
                color: _textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        background: Container(color: _bg),
      ),
    );
  }

  Widget _sectionLabel(String text) => Text(
    text,
    style: const TextStyle(
      color: _textSecondary,
      fontSize: 11,
      fontWeight: FontWeight.w700,
      letterSpacing: 1.5,
    ),
  );

  Widget _buildCard({required List<Widget> children}) => Container(
    decoration: BoxDecoration(
      color: _surface,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: _border),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(children: children),
  );

  Widget _divider() => Divider(color: _border, height: 1, indent: 56);

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      maxLines: maxLines,
      style: const TextStyle(color: _textPrimary, fontSize: 15),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: _textSecondary, fontSize: 13),
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFFBBC0D4), fontSize: 14),
        filled: true,
        fillColor: _surface,
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Icon(icon, color: _textSecondary, size: 20),
        ),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 54,
          minHeight: 48,
        ),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        errorStyle: const TextStyle(color: Color(0xFFE05C6B), fontSize: 11),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: _accent, width: 1.5),
        ),
        errorBorder: InputBorder.none,
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE05C6B), width: 1.5),
        ),
      ),
    );
  }

  Widget _buildDescField() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.description_outlined, color: _textSecondary, size: 20),
              SizedBox(width: 10),
              Text(
                'Description',
                style: TextStyle(color: _textSecondary, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _descCtrl,
            maxLines: 5,
            style: const TextStyle(
              color: _textPrimary,
              fontSize: 14,
              height: 1.6,
            ),
            decoration: InputDecoration(
              hintText: 'Add task details, acceptance criteria, notes...',
              hintStyle: const TextStyle(
                color: Color(0xFFBBC0D4),
                fontSize: 14,
              ),
              filled: true,
              fillColor: _surfaceAlt,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: _border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: _border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: _accent, width: 1.5),
              ),
              contentPadding: const EdgeInsets.all(14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownRow({
    required String label,
    required IconData icon,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
    Color Function(String)? itemColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: _textSecondary, size: 20),
          const SizedBox(width: 14),
          Text(
            label,
            style: const TextStyle(color: _textSecondary, fontSize: 13),
          ),
          const Spacer(),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              dropdownColor: _surface,
              style: TextStyle(
                color: itemColor != null ? itemColor(value) : _textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: _textSecondary,
                size: 20,
              ),
              items: items
                  .map(
                    (item) => DropdownMenuItem(
                      value: item,
                      child: Text(
                        item,
                        style: TextStyle(
                          color: itemColor != null
                              ? itemColor(item)
                              : _textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateTile({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    final hasDate = date != null;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: hasDate ? _surfaceAlt : _surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: hasDate ? _accent.withOpacity(0.4) : _border,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  color: hasDate ? _accent : _textSecondary,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    color: hasDate ? _accent : _textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _formatDateForUi(date),
              style: TextStyle(
                color: hasDate ? _textPrimary : _textSecondary,
                fontSize: 14,
                fontWeight: hasDate ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton(CreateTaskController controller) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: controller.isLoading
            ? Container(
                decoration: BoxDecoration(
                  color: _surfaceAlt,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _border),
                ),
                child: const Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: _accent,
                      strokeWidth: 2.5,
                    ),
                  ),
                ),
              )
            : GestureDetector(
                onTap: () => _submit(controller),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color(0xFF129476),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: _accent.withOpacity(0.25),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_task_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Create Task',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Employee Picker Bottom Sheet
// ─────────────────────────────────────────────────────────────────────────────

class _EmployeePickerSheet extends StatefulWidget {
  final void Function(Message) onSelected;
  const _EmployeePickerSheet({required this.onSelected});

  @override
  State<_EmployeePickerSheet> createState() => _EmployeePickerSheetState();
}

class _EmployeePickerSheetState extends State<_EmployeePickerSheet> {
  static const _bg = Color(0xFFF5F6FA);
  static const _surface = Color(0xFFFFFFFF);
  static const _accent = Color(0xFF6C63FF);
  static const _textPrimary = Color(0xFF1A1D27);
  static const _textSecondary = Color(0xFF7A7F9A);
  static const _border = Color(0xFFE2E4F0);

  final _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AllEmployeesController>(
      builder: (context, controller, _) {
        final employees = controller.allEmployees?.message ?? [];
        final filtered = _query.isEmpty
            ? employees
            : employees
                  .where(
                    (e) =>
                        e.employeeName.toLowerCase().contains(
                          _query.toLowerCase(),
                        ) ||
                        e.designation.toLowerCase().contains(
                          _query.toLowerCase(),
                        ) ||
                        e.department.toLowerCase().contains(
                          _query.toLowerCase(),
                        ),
                  )
                  .toList();

        return Container(
          decoration: const BoxDecoration(
            color: _bg,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.75,
          ),
          child: Column(
            children: [
              // Drag handle
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: _border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),

              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Container(
                      width: 5,
                      height: 22,
                      decoration: BoxDecoration(
                        color: _accent,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Select Employee',
                      style: TextStyle(
                        color: _textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const Spacer(),
                    if (employees.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _accent.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${filtered.length} found',
                          style: const TextStyle(
                            color: _accent,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Search
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: _surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _border),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchCtrl,
                    onChanged: (v) => setState(() => _query = v),
                    style: const TextStyle(color: _textPrimary, fontSize: 14),
                    decoration: const InputDecoration(
                      hintText: 'Search by name, designation...',
                      hintStyle: TextStyle(
                        color: Color(0xFFBBC0D4),
                        fontSize: 14,
                      ),
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: _textSecondary,
                        size: 20,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Employee list
              Expanded(
                child: controller.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: _accent,
                          strokeWidth: 2.5,
                        ),
                      )
                    : controller.error != null
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.error_outline_rounded,
                                color: Color(0xFFE05C6B),
                                size: 40,
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Failed to load employees',
                                style: TextStyle(
                                  color: _textPrimary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                controller.error!,
                                style: const TextStyle(
                                  color: _textSecondary,
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      )
                    : filtered.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.person_search_rounded,
                              color: _textSecondary.withOpacity(0.4),
                              size: 48,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'No employees found',
                              style: TextStyle(
                                color: _textSecondary,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (_, i) => _EmployeeTile(
                          employee: filtered[i],
                          onTap: () => widget.onSelected(filtered[i]),
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Employee Tile
// ─────────────────────────────────────────────────────────────────────────────

class _EmployeeTile extends StatelessWidget {
  final Message employee;
  final VoidCallback onTap;

  static const _surface = Color(0xFFFFFFFF);
  static const _surfaceAlt = Color(0xFFF0F1F8);
  static const _accent = Color(0xFF6C63FF);
  static const _textPrimary = Color(0xFF1A1D27);
  static const _textSecondary = Color(0xFF7A7F9A);
  static const _border = Color(0xFFE2E4F0);

  const _EmployeeTile({required this.employee, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Avatar
            employee.imageUrl.isNotEmpty
                ? AuthenticatedAvatar(
                    radius: 22,
                    imageUrl: employee.imageUrl,
                    name: employee.employeeName,
                    backgroundColor: _surfaceAlt,
                    initialsColor: _accent,
                    initialsFontSize: 16,
                  )
                : CircleAvatar(
                    radius: 22,
                    backgroundColor: _accent.withOpacity(0.1),
                    child: Text(
                      employee.employeeName.isNotEmpty
                          ? employee.employeeName[0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                        color: _accent,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
            const SizedBox(width: 14),

            // Name + designation
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    employee.employeeName,
                    style: const TextStyle(
                      color: _textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    employee.designation,
                    style: const TextStyle(color: _textSecondary, fontSize: 12),
                  ),
                ],
              ),
            ),

            // Department badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _accent.withOpacity(0.08),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                employee.department,
                style: const TextStyle(
                  color: _accent,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
