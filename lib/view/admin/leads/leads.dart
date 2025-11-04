import 'package:flutter/material.dart';
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

  // Add ScrollController and scroll state
  final ScrollController _scrollController = ScrollController();
  bool _showPagination = false;

  // Helper method to get status color
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

  // Filter leads based on search query
  List<Leads> _getFilteredLeads(List<Leads> allLeads) {
    if (searchQuery.isEmpty) {
      return allLeads;
    }
    return allLeads.where((lead) {
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

  // Get paginated leads
  List<Leads> _getPaginatedLeads(List<Leads> filteredLeads) {
    int startIndex = (currentPage - 1) * itemsPerPage;
    int endIndex = startIndex + itemsPerPage;

    if (startIndex >= filteredLeads.length) {
      return [];
    }

    endIndex = endIndex > filteredLeads.length
        ? filteredLeads.length
        : endIndex;
    return filteredLeads.sublist(startIndex, endIndex);
  }

  // Calculate pagination values
  int getTotalPages(int totalItems) => (totalItems / itemsPerPage).ceil();

  int getStartItem(int totalItems) {
    if (totalItems == 0) return 0;
    return (currentPage - 1) * itemsPerPage + 1;
  }

  int getEndItem(int totalItems) {
    if (totalItems == 0) return 0;
    int calculatedEnd = currentPage * itemsPerPage;
    return calculatedEnd > totalItems ? totalItems : calculatedEnd;
  }

  @override
  void initState() {
    super.initState();
    // Add scroll listener
    _scrollController.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
    // Check if scrolled to bottom (within 50 pixels of the bottom)
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 50) {
      if (!_showPagination) {
        setState(() {
          _showPagination = true;
        });
      }
    } else {
      if (_showPagination) {
        setState(() {
          _showPagination = false;
        });
      }
    }
  }

  Widget _buildSearchSection() {
    return TextFormField(
      onChanged: (value) {
        setState(() {
          searchQuery = value;
          currentPage = 1; // Reset to first page when search changes
        });
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
          borderRadius: const BorderRadius.all(Radius.circular(25.0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
          borderRadius: const BorderRadius.all(Radius.circular(25.0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade400),
          borderRadius: const BorderRadius.all(Radius.circular(25.0)),
        ),
        hintText: 'Search leads...',
        hintStyle: TextStyle(color: Colors.grey.shade500),
        suffixIcon: Icon(Icons.search, color: Colors.grey.shade500),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
      ),
    );
  }

  Widget _buildLeadCard(Leads lead) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
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
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
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
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Lead Segment',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 2),
                  Text(
                    lead.customLeadSegment ?? lead.marketSegment ?? 'N/A',
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Project Type',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            lead.customProjectType ?? 'N/A',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 40),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Status',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaginationControls(int totalItems) {
    final totalPages = getTotalPages(totalItems);
    final startItem = getStartItem(totalItems);
    final endItem = getEndItem(totalItems);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Pagination text on the left
          Text(
            totalItems > 0
                ? 'Showing $startItem-$endItem of $totalItems'
                : 'No records found',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          // Navigation icons on the right
          if (totalItems > 0)
            Row(
              children: [
                // Previous page button
                GestureDetector(
                  onTap: currentPage > 1
                      ? () {
                          setState(() {
                            currentPage--;
                          });
                        }
                      : null,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: currentPage > 1
                          ? Colors.grey[200]
                          : Colors.grey[100],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.keyboard_arrow_left,
                      color: currentPage > 1 ? Colors.black : Colors.grey[400],
                      size: 20,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                // Page info
                Text(
                  '$currentPage of $totalPages',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                SizedBox(width: 8),
                // Next page button
                GestureDetector(
                  onTap: currentPage < totalPages
                      ? () {
                          setState(() {
                            currentPage++;
                          });
                        }
                      : null,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: currentPage < totalPages
                          ? Colors.grey[200]
                          : Colors.grey[100],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.keyboard_arrow_right,
                      color: currentPage < totalPages
                          ? Colors.black
                          : Colors.grey[400],
                      size: 20,
                    ),
                  ),
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
        title: Text(
          'All Leads',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<AllLeadListController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2E7D8C)),
              ),
            );
          }

          if (controller.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 48),
                  SizedBox(height: 16),
                  Text(
                    'Error loading leads',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    controller.error!,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      controller.fetchAllLeadList();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF2E7D8C),
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final allLeads = controller.allLeads?.data ?? [];
          final filteredLeads = _getFilteredLeads(allLeads);
          final paginatedLeads = _getPaginatedLeads(filteredLeads);

          return RefreshIndicator(
            onRefresh: () async {
              await controller.fetchAllLeadList();
            },
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(16),
              itemCount: 1 + paginatedLeads.length + (_showPagination ? 1 : 0),
              itemBuilder: (context, index) {
                // First item is the search section
                if (index == 0) {
                  return Column(
                    children: [_buildSearchSection(), SizedBox(height: 16)],
                  );
                }

                // Adjust index for leads
                int leadIndex = index - 1;

                // Show pagination controls as the last item when scrolled to bottom
                if (leadIndex == paginatedLeads.length && _showPagination) {
                  return _buildPaginationControls(filteredLeads.length);
                }

                // Return lead card
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
