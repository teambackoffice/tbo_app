import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:tbo_app/controller/all_lead_list_controller.dart';
import 'package:tbo_app/services/login_service.dart';
import 'package:tbo_app/view/crm/dashboard/_create_new_lead/create_new_lead.dart';
import 'package:tbo_app/view/crm/dashboard/deals_closed/deals_closed.dart';
import 'package:tbo_app/view/crm/dashboard/new_leads/new_leads.dart';
import 'package:tbo_app/view/crm/dashboard/original_proposal/leads_contact.dart';

class CRMDashboardPage extends StatefulWidget {
  const CRMDashboardPage({super.key});

  @override
  State<CRMDashboardPage> createState() => _CRMDashboardPageState();

  static Widget _buildStatCard({
    required String title,
    required Widget valueWidget,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 179,
        width: 150,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                color: Colors.white,
                fontWeight: FontWeight.w500,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Center(
                child: FittedBox(fit: BoxFit.scaleDown, child: valueWidget),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CRMDashboardPageState extends State<CRMDashboardPage> {
  final LoginService _loginService = LoginService();
  String? fullName;
  final _storage = const FlutterSecureStorage();
  String? _fullName;
  String? designation;

  Future<void> _userdetails() async {
    final name = await _storage.read(key: 'employee_full_name');
    final designationValue = await _storage.read(key: 'designation');
    setState(() {
      _fullName = name;
      designation = designationValue;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<AllLeadListController>(
        context,
        listen: false,
      ).fetchAllLeadList();
    });
    _loadUserInfo();
    _userdetails();
  }

  Future<void> _loadUserInfo() async {
    final storedFullName = await _loginService.getStoredFullName();
    setState(() {
      fullName = storedFullName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F3),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Section
              Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: const Color(0xFF1C7690),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hello ${_fullName ?? ''}!",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        designation ?? 'BDE',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // Stats Grid
              Consumer<AllLeadListController>(
                builder: (context, controller, child) {
                  return GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 1.0,
                    children: [
                      CRMDashboardPage._buildStatCard(
                        title: "New\nLeads",
                        valueWidget: controller.isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                ),
                              )
                            : Text(
                                controller.getCountByStatus("Open").toString(),
                                style: const TextStyle(
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                        color: const Color(0xFF1ABC9C),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NewLeadsPage(),
                            ),
                          );
                        },
                      ),
                      CRMDashboardPage._buildStatCard(
                        title: "Quotation \nSent",
                        valueWidget: controller.isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                ),
                              )
                            : Text(
                                controller
                                    .getCountByStatus("Quotation")
                                    .toString(),
                                style: const TextStyle(
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                        color: const Color(0xFF3B5998),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProposalSentPage(),
                            ),
                          );
                        },
                      ),
                      CRMDashboardPage._buildStatCard(
                        title: "Deals\nConverted",
                        valueWidget: controller.isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                ),
                              )
                            : Text(
                                controller
                                    .getCountByStatus("Converted")
                                    .toString(),
                                style: const TextStyle(
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                        color: const Color(0xFF27AE60),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LeadsConverted(),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 30),

              // Create New Lead Button
              Center(
                child: SizedBox(
                  width: 330,
                  height: 60,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1C7690),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 2,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreateLeadForm(),
                        ),
                      );
                    },
                    child: const Text(
                      "Create New Lead",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
