import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tbo_app/controller/all_lead_list_controller.dart';
import 'package:tbo_app/view/crm/dashboard/new_leads/new_lead_details.dart';

class NewLeadsPage extends StatefulWidget {
  const NewLeadsPage({super.key});

  @override
  State<NewLeadsPage> createState() => _NewLeadsPageState();
}

class _NewLeadsPageState extends State<NewLeadsPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<AllLeadListController>(
        context,
        listen: false,
      ).fetchAllLeadList(status: "Open");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F3), // background color
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // Top Row with Back Button and Title
              Row(
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
                      onPressed: () {
                        Navigator.pop(context);
                        WidgetsBinding.instance.addPostFrameCallback((_) async {
                          Provider.of<AllLeadListController>(
                            context,
                            listen: false,
                          ).fetchAllLeadList();
                        });
                      },
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    "New Leads",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  const SizedBox(width: 40), // space for symmetry
                ],
              ),
              const SizedBox(height: 20),

              // Leads List
              Consumer<AllLeadListController>(
                builder: (context, controller, child) {
                  final leads = controller.allLeads?.data ?? [];
                  if (controller.isLoading) {
                    return const Expanded(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  return Expanded(
                    child: ListView.separated(
                      itemCount: leads.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final lead = leads[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    LeadDetailPage(lead: lead),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // "New" Badge
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1ABC9C),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    "New",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // Company Name
                                Text(
                                  lead.leadName!,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                // Location
                                Row(
                                  children: [
                                    const SizedBox(width: 4),
                                    Text(
                                      lead.customLeadSegment ?? "N/A",
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
