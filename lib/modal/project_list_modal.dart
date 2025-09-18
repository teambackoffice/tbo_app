import 'dart:convert';

ProjectList projectListFromJson(String str) =>
    ProjectList.fromJson(json.decode(str));

String projectListToJson(ProjectList data) => json.encode(data.toJson());

class ProjectList {
  String? message;
  List<ProjectDetails>? data;
  bool? success;

  ProjectList({this.message, this.data, this.success});

  factory ProjectList.fromJson(Map<String, dynamic> json) => ProjectList(
    message: json["message"],
    data: json["data"] == null
        ? []
        : List<ProjectDetails>.from(
            json["data"].map((x) => ProjectDetails.fromJson(x)),
          ),
    success: json["success"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
    "success": success,
  };
}

class ProjectDetails {
  String? name;
  String? projectName;
  String? projectType;
  String? status;
  String? priority;
  String? department;
  DateTime? expectedStartDate;
  DateTime? expectedEndDate;
  String? isActive;
  String? customLeadSegment;
  String? customProjectPlanning;
  String? notes;
  double? estimatedCosting;
  List<TaskTemplate>? taskTemplates;
  List<ResourceRequirement>? resourceRequirements;

  ProjectDetails({
    this.name,
    this.projectName,
    this.projectType,
    this.status,
    this.priority,
    this.department,
    this.expectedStartDate,
    this.expectedEndDate,
    this.isActive,
    this.customLeadSegment,
    this.customProjectPlanning,
    this.notes,
    this.estimatedCosting,
    this.taskTemplates,
    this.resourceRequirements,
  });

  factory ProjectDetails.fromJson(Map<String, dynamic> json) => ProjectDetails(
    name: json["name"],
    projectName: json["project_name"],
    projectType: json["project_type"],
    status: json["status"],
    priority: json["priority"],
    department: json["department"],
    expectedStartDate: json["expected_start_date"] != null
        ? DateTime.tryParse(json["expected_start_date"])
        : null,
    expectedEndDate: json["expected_end_date"] != null
        ? DateTime.tryParse(json["expected_end_date"])
        : null,
    isActive: json["is_active"],
    customLeadSegment: json["custom_lead_segment"],
    customProjectPlanning: json["custom_project_planning"],
    notes: json["notes"],
    estimatedCosting: (json["estimated_costing"] != null)
        ? json["estimated_costing"].toDouble()
        : null,
    taskTemplates: json["task_templates"] == null
        ? []
        : List<TaskTemplate>.from(
            json["task_templates"].map((x) => TaskTemplate.fromJson(x)),
          ),
    resourceRequirements: json["resource_requirements"] == null
        ? []
        : List<ResourceRequirement>.from(
            json["resource_requirements"].map(
              (x) => ResourceRequirement.fromJson(x),
            ),
          ),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "project_name": projectName,
    "project_type": projectType,
    "status": status,
    "priority": priority,
    "department": department,
    "expected_start_date": expectedStartDate != null
        ? "${expectedStartDate!.year.toString().padLeft(4, '0')}-${expectedStartDate!.month.toString().padLeft(2, '0')}-${expectedStartDate!.day.toString().padLeft(2, '0')}"
        : null,
    "expected_end_date": expectedEndDate != null
        ? "${expectedEndDate!.year.toString().padLeft(4, '0')}-${expectedEndDate!.month.toString().padLeft(2, '0')}-${expectedEndDate!.day.toString().padLeft(2, '0')}"
        : null,
    "is_active": isActive,
    "custom_lead_segment": customLeadSegment,
    "custom_project_planning": customProjectPlanning,
    "notes": notes,
    "estimated_costing": estimatedCosting,
    "task_templates": taskTemplates == null
        ? []
        : List<dynamic>.from(taskTemplates!.map((x) => x.toJson())),
    "resource_requirements": resourceRequirements == null
        ? []
        : List<dynamic>.from(resourceRequirements!.map((x) => x.toJson())),
  };
}

class TaskTemplate {
  String? templateName;
  double? estimatedHours;
  double? estimatedCost;
  String? priority;
  int? sequence;

  TaskTemplate({
    this.templateName,
    this.estimatedHours,
    this.estimatedCost,
    this.priority,
    this.sequence,
  });

  factory TaskTemplate.fromJson(Map<String, dynamic> json) => TaskTemplate(
    templateName: json["template_name"],
    estimatedHours: json["estimated_hours"]?.toDouble(),
    estimatedCost: json["estimated_cost"]?.toDouble(),
    priority: json["priority"],
    sequence: json["sequence"],
  );

  Map<String, dynamic> toJson() => {
    "template_name": templateName,
    "estimated_hours": estimatedHours,
    "estimated_cost": estimatedCost,
    "priority": priority,
    "sequence": sequence,
  };
}

class ResourceRequirement {
  String? resourceType;
  String? resourceName;
  double? quantityRequired;
  double? estimatedCost;

  ResourceRequirement({
    this.resourceType,
    this.resourceName,
    this.quantityRequired,
    this.estimatedCost,
  });

  factory ResourceRequirement.fromJson(Map<String, dynamic> json) =>
      ResourceRequirement(
        resourceType: json["resource_type"],
        resourceName: json["resource_name"],
        quantityRequired: json["quantity_required"]?.toDouble(),
        estimatedCost: json["estimated_cost"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
    "resource_type": resourceType,
    "resource_name": resourceName,
    "quantity_required": quantityRequired,
    "estimated_cost": estimatedCost,
  };
}
