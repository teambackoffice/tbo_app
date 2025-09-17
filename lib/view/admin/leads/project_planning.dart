import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tbo_app/controller/lead_segment_controller.dart';
import 'package:tbo_app/modal/all_lead_list_modal.dart';

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
  const ProjectPlanningScreen({super.key, required this.lead});

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
  String selectedStatus = 'Draft';

  // Resources list
  List<Resource> resources = [];

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
                  SizedBox(height: 16),
                  _buildDropdownField(
                    'Status',
                    selectedStatus,
                    ['Draft', 'In Progress', 'Completed'],
                    (value) {
                      setState(() {
                        selectedStatus = value!;
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

                  // Estimated Cost field
                ],
              ),
            ),
            SizedBox(height: 32),
            _buildTextField(
              'Estimated Cost',
              estimatedCostController,
              readOnly: true,
            ),

            SizedBox(height: 32),
            // Save Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  // Handle save action
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Project saved successfully!')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF008B8B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
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
          readOnly: readOnly,
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

  Widget _buildDropdownField(
    String label,
    String? value, // allow null
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
              value: value, // can be null
              isExpanded: true,
              hint: Text("Select $label"), // 👈 hint when null
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

          // Update Estimated Cost field
          if (selectedSegment != null) {
            estimatedCostController.text = selectedSegment.totalEstimatedCost
                .toStringAsFixed(2);
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
