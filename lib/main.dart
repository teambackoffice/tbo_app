import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tbo_app/api/firebase_api.dart';
import 'package:tbo_app/controller/all_employees._controller.dart';
import 'package:tbo_app/controller/all_lead_list_controller.dart';
import 'package:tbo_app/controller/create_new_lead_controller.dart';
import 'package:tbo_app/controller/create_project_controller.dart';
import 'package:tbo_app/controller/create_project_planning_controller.dart';
import 'package:tbo_app/controller/create_task_controller.dart';
import 'package:tbo_app/controller/create_timesheet_controller.dart';
import 'package:tbo_app/controller/date_request_controller.dart';
import 'package:tbo_app/controller/edit_lead_controller.dart';
import 'package:tbo_app/controller/employee_assignments_controller.dart';
import 'package:tbo_app/controller/employee_get_date_controller.dart';
import 'package:tbo_app/controller/employee_handover_controller.dart';
import 'package:tbo_app/controller/employee_task_date_request.dart';
import 'package:tbo_app/controller/employee_task_list_controller.dart';
import 'package:tbo_app/controller/employee_task_update_contoller.dart';
import 'package:tbo_app/controller/employee_taskdate_sumbit_controller.dart';
import 'package:tbo_app/controller/get_admin_Task_list_controller.dart';
import 'package:tbo_app/controller/get_handover_controller.dart';
import 'package:tbo_app/controller/get_notification_controller.dart';
import 'package:tbo_app/controller/get_task_assignment_controller.dart';
import 'package:tbo_app/controller/get_timesheet_controller.dart';
import 'package:tbo_app/controller/handover_task_post_controller.dart';
import 'package:tbo_app/controller/lead_segment_controller.dart';
import 'package:tbo_app/controller/leads_details_controller.dart';
import 'package:tbo_app/controller/log_out_controller.dart';
import 'package:tbo_app/controller/login_controller.dart';
import 'package:tbo_app/controller/project_list_controller.dart';
import 'package:tbo_app/controller/task_assignment_submit_controller.dart';
import 'package:tbo_app/controller/task_count_controller.dart';
import 'package:tbo_app/controller/task_employee_assign.dart';
import 'package:tbo_app/controller/task_list_controller.dart';
import 'package:tbo_app/controller/update_timesheet_controller.dart';
import 'package:tbo_app/controller/user_details_controller.dart';
import 'package:tbo_app/firebase_options.dart';
import 'package:tbo_app/view/splash/splash_screen.dart';

// ✅ Global navigator key for navigation from anywhere
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final firebaseApi = FirebaseApi();
  await firebaseApi.initNotification();

  // ✅ Initialize OneSignal BEFORE runApp
  initOneSignal();

  runApp(const MyApp());
}

// ✅ Separate OneSignal initialization function
void initOneSignal() {
  // Enable verbose logging for debugging (remove in production)
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

  // Initialize with your OneSignal App ID
  OneSignal.initialize("6a1f3d55-06a2-4260-81fd-95f4f41ab003");

  // Request notification permission
  OneSignal.Notifications.requestPermission(true);

  // ✅ Setup notification handlers
  setupNotificationHandlers();
}

// ✅ Setup notification event handlers
void setupNotificationHandlers() {
  // Notification received while app is in foreground
  OneSignal.Notifications.addForegroundWillDisplayListener((event) {
    // Display the notification
    event.notification.display();
  });

  // Notification clicked/opened
  OneSignal.Notifications.addClickListener((event) {
    final data = event.notification.additionalData;
    if (data != null && data['taskId'] != null) {
      // TODO: Navigate to task detail screen

      // Example navigation (implement your actual navigation logic)
      // navigatorKey.currentState?.push(
      //   MaterialPageRoute(
      //     builder: (context) => TaskDetailScreen(taskId: data['taskId']),
      //   ),
      // );
    }
  });

  // Push subscription state changes
  OneSignal.User.pushSubscription.addObserver((state) {});

  // Permission state changes
  OneSignal.Notifications.addPermissionObserver((state) {});
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(395, 852),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider<LoginController>(
              create: (_) => LoginController(),
            ),
            ChangeNotifierProvider<LogOutController>(
              create: (_) => LogOutController(),
            ),
            ChangeNotifierProvider<GetProjectListController>(
              create: (_) => GetProjectListController(),
            ),
            ChangeNotifierProvider<TaskListController>(
              create: (_) => TaskListController(),
            ),
            ChangeNotifierProvider<AllLeadListController>(
              create: (_) => AllLeadListController(),
            ),
            ChangeNotifierProvider<AllLeadsDetailsController>(
              create: (_) => AllLeadsDetailsController(),
            ),
            ChangeNotifierProvider<AllEmployeesController>(
              create: (_) => AllEmployeesController(),
            ),
            ChangeNotifierProvider<CreateProjectController>(
              create: (_) => CreateProjectController(),
            ),
            ChangeNotifierProvider<LeadSegmentController>(
              create: (_) => LeadSegmentController(),
            ),
            ChangeNotifierProvider<ProjectPlanningController>(
              create: (_) => ProjectPlanningController(),
            ),
            ChangeNotifierProvider<GetTimesheetController>(
              create: (_) => GetTimesheetController(),
            ),
            ChangeNotifierProvider<EmployeeAssignmentsController>(
              create: (_) => EmployeeAssignmentsController(),
            ),
            ChangeNotifierProvider<TaskEmployeeAssignController>(
              create: (_) => TaskEmployeeAssignController(),
            ),
            ChangeNotifierProvider<CreateTimesheetController>(
              create: (_) => CreateTimesheetController(),
            ),
            ChangeNotifierProvider<TaskByEmployeeController>(
              create: (_) => TaskByEmployeeController(),
            ),
            ChangeNotifierProvider<CreateNewLeadController>(
              create: (_) => CreateNewLeadController(),
            ),
            ChangeNotifierProvider<CreateDateRequestController>(
              create: (_) => CreateDateRequestController(),
            ),
            ChangeNotifierProvider<TaskCountController>(
              create: (_) => TaskCountController(),
            ),
            ChangeNotifierProvider<TaskHandoverController>(
              create: (_) => TaskHandoverController(),
            ),
            ChangeNotifierProvider<EditTaskController>(
              create: (_) => EditTaskController(),
            ),
            ChangeNotifierProvider<EmployeeHandoverController>(
              create: (_) => EmployeeHandoverController(),
            ),
            ChangeNotifierProvider<EmployeeDateRequestController>(
              create: (_) => EmployeeDateRequestController(),
            ),
            ChangeNotifierProvider<UserDetailsController>(
              create: (_) => UserDetailsController(),
            ),
            ChangeNotifierProvider<NotificationProvider>(
              create: (_) => NotificationProvider(),
            ),
            ChangeNotifierProvider<EditLeadController>(
              create: (_) => EditLeadController(),
            ),
            ChangeNotifierProvider<EmployeeTaskDateRequestController>(
              create: (_) => EmployeeTaskDateRequestController(),
            ),
            ChangeNotifierProvider<SubmitDateRequestController>(
              create: (_) => SubmitDateRequestController(),
            ),
            ChangeNotifierProvider<HandoverPostController>(
              create: (_) => HandoverPostController(),
            ),
            ChangeNotifierProvider<GetTaskAssignmentController>(
              create: (_) => GetTaskAssignmentController(),
            ),
            ChangeNotifierProvider<TaskSubmissionController>(
              create: (_) => TaskSubmissionController(),
            ),
            ChangeNotifierProvider<TimesheetStatusController>(
              create: (_) => TimesheetStatusController(),
            ),
            ChangeNotifierProvider<GetAdminTaskListController>(
              create: (_) => GetAdminTaskListController(),
            ),
            ChangeNotifierProvider<CreateTaskController>(
              create: (_) => CreateTaskController(),
            ),
          ],
          child: MaterialApp(
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            title: 'TBO App',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: const SplashScreen(),
          ),
        );
      },
    );
  }
}
