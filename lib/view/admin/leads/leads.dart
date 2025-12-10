import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:tbo_app/controller/all_lead_list_controller.dart';
import 'package:tbo_app/modal/all_lead_list_modal.dart';
import 'package:tbo_app/view/admin/leads/lead_detail.dart';

class AdminLeadsPage extends StatefulWidget {
  const AdminLeadsPage({super.key});

  @override
  _AdminLeadsPageState createState() => _AdminLeadsPageState();
}

class _AdminLeadsPageState extends State<AdminLeadsPage> {
  String searchQuery = '';
  int currentPage = 1;
  int itemsPerPage = 10;

  final ScrollController _scrollController = ScrollController();
  bool _showPagination = false;

  String selectedStatus = 'All';
  List<String> availableStatuses = ['All'];

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'converted':
        return Colors.green;
      case 'send to approved':
      case 'contacted':
        return Colors.blue;
      case 'lost quotation':
      case 'lost':
        return Colors.red;
      case 'proposal sent':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  void _updateAvailableStatuses(List<Leads> allLeads) {
    final statuses = <String>{'All'};
    for (var lead in allLeads) {
      if (lead.status != null && lead.status!.isNotEmpty) {
        statuses.add(lead.status!);
      }
    }

    if (mounted &&
        (statuses.length != availableStatuses.length ||
            !statuses.every((status) => availableStatuses.contains(status)))) {
      setState(() {
        availableStatuses = statuses.toList()
          ..sort((a, b) {
            if (a == 'All') return -1;
            if (b == 'All') return 1;
            return a.compareTo(b);
          });
      });
    }
  }

  List<Leads> _getFilteredLeads(List<Leads> allLeads) {
    var filtered = allLeads;

    // 🔥 1️⃣ Department-based filtering MUST run first
    // Department-based filtering
    if (department != null && department!.isNotEmpty) {
      final dept = department!.toLowerCase();

      if (dept.contains("erp")) {
        filtered = filtered
            .where(
              (lead) => (lead.customLeadSegment ?? lead.marketSegment ?? '')
                  .toLowerCase()
                  .contains("erp"),
            )
            .toList();
      } else if (dept.contains("digital")) {
        filtered = filtered
            .where(
              (lead) => (lead.customLeadSegment ?? lead.marketSegment ?? '')
                  .toLowerCase()
                  .contains("digital"),
            )
            .toList();
      }
    }

    // 🔥 2️⃣ Status filter
    if (selectedStatus != 'All') {
      filtered = filtered
          .where(
            (lead) =>
                lead.status?.toLowerCase() == selectedStatus.toLowerCase(),
          )
          .toList();
    }

    // 🔥 3️⃣ Search filter
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((lead) {
        final companyName = lead.companyName?.toLowerCase() ?? '';
        final status = lead.status?.toLowerCase() ?? '';
        final leadSegment =
            lead.customLeadSegment?.toLowerCase() ??
            lead.marketSegment?.toLowerCase() ??
            '';
        final projectType = lead.customProjectType?.toLowerCase() ?? '';
        final query = searchQuery.toLowerCase();

        return companyName.contains(query) ||
            status.contains(query) ||
            leadSegment.contains(query) ||
            projectType.contains(query);
      }).toList();
    }

    return filtered;
  }

  List<Leads> _getPaginatedLeads(List<Leads> filteredLeads) {
    int startIndex = (currentPage - 1) * itemsPerPage;
    int endIndex = startIndex + itemsPerPage;

    if (startIndex >= filteredLeads.length) return [];

    endIndex = endIndex > filteredLeads.length
        ? filteredLeads.length
        : endIndex;
    return filteredLeads.sublist(startIndex, endIndex);
  }

  int getTotalPages(int totalItems) => (totalItems / itemsPerPage).ceil();
  int getStartItem(int totalItems) =>
      totalItems == 0 ? 0 : (currentPage - 1) * itemsPerPage + 1;
  int getEndItem(int totalItems) {
    if (totalItems == 0) return 0;
    final calculatedEnd = currentPage * itemsPerPage;
    return calculatedEnd > totalItems ? totalItems : calculatedEnd;
  }

  String? department;
  final _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // 🔥 Read department directly from secure storage
      department = await _storage.read(key: "department");
      print("💾 Department Loaded: $department");

      setState(() {});

      Provider.of<AllLeadListController>(
        context,
        listen: false,
      ).fetchAllLeadList();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 50) {
      if (!_showPagination) {
        setState(() => _showPagination = true);
      }
    } else {
      if (_showPagination) {
        setState(() => _showPagination = false);
      }
    }
  }

  Widget _buildSearchSection() {
    return TextFormField(
      onChanged: (value) {
        setState(() {
          searchQuery = value;
          currentPage = 1;
        });
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(25.0),
        ),
        hintText: 'Search leads...',
        suffixIcon: Icon(Icons.search, color: Colors.grey.shade500),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
    );
  }

  Widget _buildStatusFilterDropdown(List<Leads> allLeads) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(Icons.filter_list, color: Colors.grey.shade600, size: 20),
          SizedBox(width: 8),
          Text(
            'Status:',
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedStatus,
                isExpanded: true,
                icon: Icon(Icons.arrow_drop_down, color: Color(0xFF2D7D8C)),
                items: availableStatuses.map((String status) {
                  int count = _getStatusCount(allLeads, status);
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(
                      '$status ($count)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedStatus = newValue!;
                    currentPage = 1;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _getStatusCount(List<Leads> allLeads, String status) {
    if (status == 'All') return allLeads.length;
    return allLeads.where((lead) => lead.status == status).length;
  }

  Widget _buildLeadCard(Leads lead) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Company Name',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          SizedBox(height: 2),
          Text(
            lead.companyName ?? 'N/A',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8),
          Text(
            'Lead Segment',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          SizedBox(height: 2),
          Text(
            lead.customLeadSegment ?? lead.marketSegment ?? 'N/A',
            style: TextStyle(fontSize: 14),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Project Type',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 2),
                  Text(
                    lead.customProjectType ?? 'N/A',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
              SizedBox(width: 40),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Status',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 2),
                  Text(
                    lead.status ?? 'N/A',
                    style: TextStyle(
                      fontSize: 16,
                      color: _getStatusColor(lead.status ?? ''),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Spacer(),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LeadDetailsPage(lead: lead),
                    ),
                  );
                },
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Color(0xFF2E7D8C),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaginationControls(int totalItems) {
    final totalPages = getTotalPages(totalItems);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            totalItems > 0
                ? 'Showing ${getStartItem(totalItems)}-${getEndItem(totalItems)} of $totalItems'
                : 'No records found',
          ),
          if (totalItems > 0)
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.keyboard_arrow_left),
                  onPressed: currentPage > 1
                      ? () => setState(() => currentPage--)
                      : null,
                ),
                Text('$currentPage of $totalPages'),
                IconButton(
                  icon: Icon(Icons.keyboard_arrow_right),
                  onPressed: currentPage < totalPages
                      ? () => setState(() => currentPage++)
                      : null,
                ),
              ],
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('All Leads', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Consumer<AllLeadListController>(
        builder: (context, controller, _) {
          if (controller.isLoading) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Color(0xFF2E7D8C)),
              ),
            );
          }

          final allLeads = controller.allLeads?.data ?? [];

          // 🔥 Important Fix - move setState out of build phase
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _updateAvailableStatuses(allLeads);
          });

          final filteredLeads = _getFilteredLeads(allLeads);
          final paginatedLeads = _getPaginatedLeads(filteredLeads);

          return RefreshIndicator(
            onRefresh: controller.fetchAllLeadList,
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(16),
              itemCount: 1 + paginatedLeads.length + (_showPagination ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Column(
                    children: [
                      _buildSearchSection(),
                      SizedBox(height: 16),
                      _buildStatusFilterDropdown(allLeads),
                      SizedBox(height: 16),
                    ],
                  );
                }

                final leadIndex = index - 1;

                if (leadIndex == paginatedLeads.length && _showPagination) {
                  return _buildPaginationControls(filteredLeads.length);
                }

                if (leadIndex < paginatedLeads.length) {
                  return _buildLeadCard(paginatedLeads[leadIndex]);
                }

                return SizedBox.shrink();
              },
            ),
          );
        },
      ),
    );
  }
}
