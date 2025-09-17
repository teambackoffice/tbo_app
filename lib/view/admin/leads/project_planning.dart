import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tbo_app/controller/create_project_controller.dart'; // 🔥 ADD THIS IMPORT
import 'package:tbo_app/controller/lead_segment_controller.dart';
import 'package:tbo_app/modal/all_lead_list_modal.dart';
import 'package:tbo_app/view/admin/bottom_navigation/bottom_navigation_admin.dart';

class Resource {
  String type;
  String name;
  int quantity;
  double cost;

  Resource({
    required this.type,
    required this.name,
    required this.quantity,
    required this.cost,
  });
}

class ProjectPlanningScreen extends StatefulWidget {
  final Leads lead;
  final String? planningId; // 🔥 ADD PLANNING_ID PARAMETER
  const ProjectPlanningScreen({super.key, required this.lead, this.planningId});

  @override
  _ProjectPlanningScreenState createState() => _ProjectPlanningScreenState();
}

class _ProjectPlanningScreenState extends State<ProjectPlanningScreen> {
  // Expansion states
  bool isLeadDetailsExpanded = false;
  bool isEstimationDetailsExpanded = false;
  bool isResourcePlanningExpanded = false;

  // Controllers
  late TextEditingController leadController;
  final TextEditingController planningDateController = TextEditingController();
  final TextEditingController estimatedDurationController =
      TextEditingController();
  final TextEditingController plannedStartDateController =
      TextEditingController();
  final TextEditingController plannedEndDateController =
      TextEditingController();
  final TextEditingController estimatedCostController = TextEditingController();

  @override
  void initState() {
    super.initState();
    leadController = TextEditingController(text: widget.lead.leadName ?? '');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LeadSegmentController>(
        context,
        listen: false,
      ).fetchleadsegments();
    });
  }

  // Dropdown values
  String? selectedLeadSegment;
  String selectedProjectType = 'Internal';

  // Resources list
  List<Resource> resources = [];

  // 🔥 ADD THIS METHOD TO CALCULATE TOTAL COST
  void _updateEstimatedCost() {
    double totalResourceCost = resources.fold(
      0.0,
      (sum, resource) => sum + resource.cost,
    );

    // Get base cost from lead segment if available
    double baseCost = 0.0;
    final controller = Provider.of<LeadSegmentController>(
      context,
      listen: false,
    );
    if (selectedLeadSegment != null && controller.leadsegments != null) {
      final selectedSegment = controller.leadsegments!.data.firstWhere(
        (seg) => seg.leadSegment == selectedLeadSegment,
        orElse: () => throw Exception("Segment not found"),
      );
      baseCost = selectedSegment.totalEstimatedCost;
    }

    double totalCost = baseCost + totalResourceCost;
    estimatedCostController.text = totalCost.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<LeadSegmentController>(context);
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(
          'Project Planning',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Lead Details Section
            _buildExpandableSection(
              title: 'Lead Details',
              isExpanded: isLeadDetailsExpanded,
              onTap: () {
                setState(() {
                  isLeadDetailsExpanded = !isLeadDetailsExpanded;
                });
              },
              child: Column(
                children: [
                  _buildTextField('Lead', leadController),
                  SizedBox(height: 16),
                  _buildLeadSegmentField(controller),
                  SizedBox(height: 16),
                  _buildTextField(
                    'Planning Date',
                    planningDateController,
                    suffixIcon: Icons.calendar_today,
                  ),
                  SizedBox(height: 16),
                  _buildDropdownField(
                    'Project Type',
                    selectedProjectType,
                    ['Internal', 'External', 'Hybrid'],
                    (value) {
                      setState(() {
                        selectedProjectType = value!;
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),

            // Estimation Details Section
            _buildExpandableSection(
              title: 'Estimation Details',
              isExpanded: isEstimationDetailsExpanded,
              onTap: () {
                setState(() {
                  isEstimationDetailsExpanded = !isEstimationDetailsExpanded;
                });
              },
              child: Column(
                children: [
                  _buildTextField(
                    'Estimated Duration (Days)',
                    estimatedDurationController,
                  ),
                  SizedBox(height: 16),
                  _buildTextField(
                    'Planned Start Date',
                    plannedStartDateController,
                    suffixIcon: Icons.calendar_today,
                  ),
                  SizedBox(height: 16),
                  _buildTextField(
                    'Planned End Date',
                    plannedEndDateController,
                    suffixIcon: Icons.calendar_today,
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),

            // Resource Planning Section
            _buildExpandableSection(
              title: 'Resource Planning',
              isExpanded: isResourcePlanningExpanded,
              onTap: () {
                setState(() {
                  isResourcePlanningExpanded = !isResourcePlanningExpanded;
                });
              },
              child: Column(
                children: [
                  // Add Row button
                  Row(
                    children: [
                      GestureDetector(
                        onTap: _showAddResourceDialog,
                        child: Text(
                          'Add Row +',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Resources list
                  ...resources.map((resource) => _buildResourceItem(resource)),
                ],
              ),
            ),
            SizedBox(height: 16),

            // 🔥 MOVED ESTIMATED COST OUTSIDE RESOURCE PLANNING SECTION
            _buildTextField(
              'Estimated Cost',
              estimatedCostController,
              readOnly: true,
            ),

            SizedBox(height: 32),
            // Save Button with API integration
            Consumer<CreateProjectController>(
              builder: (context, createController, child) {
                return SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: createController.isLoading
                        ? null
                        : _createProject,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF008B8B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: createController.isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                            'Create New Project',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // 🔥 ADD THIS METHOD FOR API CALL
  Future<void> _createProject() async {
    if (_validateForm()) {
      final createController = Provider.of<CreateProjectController>(
        context,
        listen: false,
      );

      // Prepare resource requirements for API
      List<Map<String, dynamic>> resourceRequirements = resources
          .map(
            (resource) => {
              'resource_type': resource.type,
              'resource_name': resource.name,
              'quantity_required': resource.quantity,
              'estimated_cost': resource.cost,
            },
          )
          .toList();

      await createController.updateProject(
        planningId: widget.planningId ?? '', // 🔥 USE THE PASSED PLANNING_ID
        planningName: leadController.text,
        lead: widget.lead.leadId!,
        leadSegment: selectedLeadSegment ?? '',
        projectType: selectedProjectType,
        status: "Approved",
        planningDate: DateFormat(
          'yyyy-MM-dd',
        ).format(DateFormat('dd-MM-yyyy').parse(planningDateController.text)),
        estimatedDuration: int.tryParse(estimatedDurationController.text) ?? 0,
        estimatedCost: double.tryParse(estimatedCostController.text) ?? 0.0,
        plannedStartDate: DateFormat('yyyy-MM-dd').format(
          DateFormat('dd-MM-yyyy').parse(plannedStartDateController.text),
        ),
        plannedEndDate: DateFormat(
          'yyyy-MM-dd',
        ).format(DateFormat('dd-MM-yyyy').parse(plannedEndDateController.text)),

        resourceRequirements: resourceRequirements,
      );

      // Show result message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            createController.responseMessage.contains('Error')
                ? 'Failed to create project'
                : 'Project created successfully!',
          ),
          backgroundColor: createController.responseMessage.contains('Error')
              ? Colors.red
              : Colors.green,
        ),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const AdminBottomNavigation(initialIndex: 2),
        ),
        (route) => false, // remove all previous routes
      );
    }
  }

  // 🔥 ADD VALIDATION METHOD
  bool _validateForm() {
    if (leadController.text.isEmpty) {
      _showErrorSnackBar('Please enter lead name');
      return false;
    }
    if (selectedLeadSegment == null) {
      _showErrorSnackBar('Please select lead segment');
      return false;
    }
    if (planningDateController.text.isEmpty) {
      _showErrorSnackBar('Please enter planning date');
      return false;
    }
    if (estimatedDurationController.text.isEmpty) {
      _showErrorSnackBar('Please enter estimated duration');
      return false;
    }
    if (plannedStartDateController.text.isEmpty) {
      _showErrorSnackBar('Please enter planned start date');
      return false;
    }
    if (plannedEndDateController.text.isEmpty) {
      _showErrorSnackBar('Please enter planned end date');
      return false;
    }
    return true;
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  Widget _buildExpandableSection({
    required String title,
    required bool isExpanded,
    required VoidCallback onTap,
    required Widget child,
  }) {
    return Column(
      children: [
        // Header
        GestureDetector(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.grey[600],
                ),
              ],
            ),
          ),
        ),
        // Content
        if (isExpanded)
          Padding(padding: EdgeInsets.fromLTRB(16, 0, 16, 16), child: child),
      ],
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    IconData? suffixIcon,
    bool readOnly = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4),
        TextField(
          controller: controller,
          readOnly: suffixIcon == Icons.calendar_today
              ? true
              : readOnly, // 🔥 MAKE DATE FIELDS READONLY
          onTap: suffixIcon == Icons.calendar_today
              ? () => _selectDate(controller)
              : null, // 🔥 ADD DATE PICKER
          decoration: InputDecoration(
            filled: true,
            fillColor: Color(0xFFF8F9FA),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xFFE0E0E0), width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xFFE0E0E0), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xFF008B8B), width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            suffixIcon: suffixIcon != null
                ? Icon(suffixIcon, color: Colors.grey[600], size: 20)
                : null,
          ),
          style: TextStyle(fontSize: 14, color: Colors.black87),
        ),
      ],
    );
  }

  // 🔥 ADD THIS DATE PICKER METHOD
  Future<void> _selectDate(TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF008B8B),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Color(0xFF008B8B)),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      controller.text =
          "${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}";
    }
  }

  Widget _buildDropdownField(
    String label,
    String? value,
    List<String> items,
    ValueChanged<String?> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            color: Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Color(0xFFE0E0E0), width: 1),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              hint: Text("Select $label"),
              onChanged: onChanged,
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[600]),
              style: TextStyle(fontSize: 14, color: Colors.black87),
              items: items.map<DropdownMenuItem<String>>((String item) {
                return DropdownMenuItem<String>(value: item, child: Text(item));
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLeadSegmentField(LeadSegmentController controller) {
    if (controller.isLoading) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Lead Segment",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 12),
                Text("Loading lead segments..."),
              ],
            ),
          ),
        ],
      );
    }

    if (controller.error != null) {
      return Text("Error: ${controller.error}");
    }

    return _buildDropdownField(
      "Lead Segment",
      selectedLeadSegment,
      controller.leadsegments?.data.map((seg) => seg.leadSegment).toList() ??
          [],
      (value) {
        setState(() {
          selectedLeadSegment = value;

          // Find selected segment object
          final selectedSegment = controller.leadsegments?.data.firstWhere(
            (seg) => seg.leadSegment == value,
          );

          // Update Estimated Cost field and recalculate total
          if (selectedSegment != null) {
            _updateEstimatedCost(); // 🔥 USE NEW METHOD
          }
        });
      },
    );
  }

  Widget _buildResourceItem(Resource resource) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0xFFE0E0E0), width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Resource Type',
                  style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                ),
                Text(
                  resource.type,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Resource Name',
                  style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                ),
                Text(
                  resource.name,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Quantity Required',
                  style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                ),
                Text(
                  resource.quantity.toString(),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Estimated Cost',
                  style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                ),
                Text(
                  resource.cost.toStringAsFixed(2),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              IconButton(
                onPressed: () => _editResource(resource),
                icon: Icon(Icons.edit, color: Colors.grey[600], size: 16),
                padding: EdgeInsets.all(4),
                constraints: BoxConstraints(),
              ),
              IconButton(
                onPressed: () => _deleteResource(resource),
                icon: Icon(Icons.delete, color: Colors.red, size: 16),
                padding: EdgeInsets.all(4),
                constraints: BoxConstraints(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddResourceDialog() {
    _showResourceDialog();
  }

  void _editResource(Resource resource) {
    _showResourceDialog(resource: resource);
  }

  void _deleteResource(Resource resource) {
    setState(() {
      resources.remove(resource);
      _updateEstimatedCost(); // 🔥 RECALCULATE COST AFTER DELETE
    });
  }

  void _showResourceDialog({Resource? resource}) {
    final TextEditingController typeController = TextEditingController(
      text: resource?.type ?? 'Human Resource',
    );
    final TextEditingController nameController = TextEditingController(
      text: resource?.name ?? '',
    );
    final TextEditingController quantityController = TextEditingController(
      text: resource?.quantity.toString() ?? '1',
    );
    final TextEditingController costController = TextEditingController(
      text: resource?.cost.toString() ?? '0.00',
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: EdgeInsets.all(20),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(''),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(Icons.close, color: Colors.grey[600]),
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
                _buildDialogTextField('Resource Type', typeController),
                SizedBox(height: 16),
                _buildDialogTextField('Resource Name', nameController),
                SizedBox(height: 16),
                _buildDialogTextField(
                  'Quantity Required',
                  quantityController,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16),
                _buildDialogTextField(
                  'Estimated Cost',
                  costController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
                SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton(
                    onPressed: () {
                      final newResource = Resource(
                        type: typeController.text,
                        name: nameController.text,
                        quantity: int.tryParse(quantityController.text) ?? 1,
                        cost: double.tryParse(costController.text) ?? 0.0,
                      );

                      setState(() {
                        if (resource != null) {
                          // Edit existing resource
                          int index = resources.indexOf(resource);
                          resources[index] = newResource;
                        } else {
                          // Add new resource
                          resources.add(newResource);
                        }
                        _updateEstimatedCost(); // 🔥 RECALCULATE COST AFTER ADD/EDIT
                      });
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF008B8B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                    child: Text(
                      'Add',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDialogTextField(
    String label,
    TextEditingController controller, {
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            filled: true,
            fillColor: Color(0xFFF8F9FA),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xFFE0E0E0), width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xFFE0E0E0), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xFF008B8B), width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
          style: TextStyle(fontSize: 14, color: Colors.black87),
        ),
      ],
    );
  }
}
