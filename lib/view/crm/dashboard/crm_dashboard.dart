import 'package:flutter/material.dart';
import 'package:tbo_app/services/login_service.dart';
import 'package:tbo_app/view/crm/dashboard/_create_new_lead/create_new_lead.dart';
import 'package:tbo_app/view/crm/dashboard/deals_closed/deals_closed.dart';
import 'package:tbo_app/view/crm/dashboard/leads_contacted/leads_contact.dart';
import 'package:tbo_app/view/crm/dashboard/new_leads/new_leads.dart';
import 'package:tbo_app/view/crm/dashboard/prposal_sent/proposal_sent.dart';

class CRMDashboardPage extends StatefulWidget {
  const CRMDashboardPage({super.key});

  @override
  State<CRMDashboardPage> createState() => _CRMDashboardPageState();

  static Widget _buildStatCard({
    required String title,
    required String value,
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
            Text(
              value,
              style: const TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: Colors.white,
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

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
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
                  const CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(
                      "https://cdn.prod.website-files.com/5fbb9b89508062592a9731b1/6448c1ce35d6ffe59e4d6f46_GettyImages-1399565382.jpg", // Replace with actual image
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hello $fullName !",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        "BDE",
                        style: TextStyle(
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
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1.0,
                children: [
                  CRMDashboardPage._buildStatCard(
                    title: "New\nLeads",
                    value: "12",
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
                    title: "Leads\nContacted",
                    value: "24",
                    color: const Color(0xFF3B5998),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LeadsContactedPage(),
                        ),
                      );
                    },
                  ),
                  CRMDashboardPage._buildStatCard(
                    title: "Proposals\nSent",
                    value: "4",
                    color: const Color(0xFFF39C12),
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
                    title: "Deals\nClosed",
                    value: "3",
                    color: const Color(0xFF27AE60),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DealsClosed(),
                        ),
                      );
                    },
                  ),
                ],
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
