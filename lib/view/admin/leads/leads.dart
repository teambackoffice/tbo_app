import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tbo_app/view/admin/leads/lead_detail.dart';

class AdminLeadsPage extends StatefulWidget {
  const AdminLeadsPage({super.key});

  @override
  _AdminLeadsPageState createState() => _AdminLeadsPageState();
}

class _AdminLeadsPageState extends State<AdminLeadsPage> {
  String selectedFilter = 'All';
  String selectedDate = '';
  int currentPage = 1;
  int itemsPerPage = 10;
  int totalItems = 67; // Total number of leads (example)

  // Add ScrollController and scroll state
  final ScrollController _scrollController = ScrollController();
  bool _showPagination = false;

  // Sample lead data
  final List<Map<String, dynamic>> leads = [
    {
      'companyName': 'Onshore',
      'leadSegment': 'Digital Marketing',
      'location': 'Calicut',
      'status': 'Converted',
      'statusColor': Colors.green,
    },
    {
      'companyName': 'Prim',
      'leadSegment': 'Digital Marketing',
      'location': 'Calicut',
      'status': 'Send to Approved',
      'statusColor': Colors.blue,
    },
    {
      'companyName': 'Prim',
      'leadSegment': 'Digital Marketing',
      'location': 'Calicut',
      'status': 'Lost Quotation',
      'statusColor': Colors.red,
    },
    {
      'companyName': 'Prim',
      'leadSegment': 'Digital Marketing',
      'location': 'Calicut',
      'status': 'Send to Approved',
      'statusColor': Colors.blue,
    },
    {
      'companyName': 'Prim',
      'leadSegment': 'Digital Marketing',
      'location': 'Calicut',
      'status': 'Send to Approved',
      'statusColor': Colors.blue,
    },
    {
      'companyName': 'Prim',
      'leadSegment': 'Digital Marketing',
      'location': 'Calicut',
      'status': 'Send to Approved',
      'statusColor': Colors.blue,
    },
    {
      'companyName': 'Prim',
      'leadSegment': 'Digital Marketing',
      'location': 'Calicut',
      'status': 'Send to Approved',
      'statusColor': Colors.blue,
    },
  ];

  // Calculate pagination values
  int get totalPages => (totalItems / itemsPerPage).ceil();
  int get startItem => (currentPage - 1) * itemsPerPage + 1;
  int get endItem {
    int calculatedEnd = currentPage * itemsPerPage;
    return calculatedEnd > totalItems ? totalItems : calculatedEnd;
  }

  @override
  void initState() {
    super.initState();
    selectedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
    // Add scroll listener
    _scrollController.addListener(_scrollListener);
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

  Widget _buildFilterSection() {
    return Row(
      children: [
        // All Filter Dropdown
        Expanded(
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              color: Color(0xFFF0F0F0),
              borderRadius: BorderRadius.circular(20),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedFilter,
                isExpanded: true,
                icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[600]),
                items: ['All', 'Converted', 'Pending', 'Lost'].map((
                  String value,
                ) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        value,
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedFilter = newValue!;
                  });
                },
              ),
            ),
          ),
        ),
        SizedBox(width: 70),
        // Date Filter
        Container(
          height: 40,
          width: 160,
          padding: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            color: Color(0xFFF0F0F0),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                selectedDate,
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
              SizedBox(width: 8),
              Icon(Icons.calendar_today, color: Colors.grey[600], size: 16),
            ],
          ),
        ),
        SizedBox(height: 16),
      ],
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
      body: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.all(16),
        itemCount:
            1 +
            leads.length +
            (_showPagination ? 1 : 0), // +1 for filter section
        itemBuilder: (context, index) {
          // First item is the filter section
          if (index == 0) {
            return Column(
              children: [
                _buildFilterSection(),
                SizedBox(height: 16), // 👈 Add gap between filters and list
              ],
            );
          }

          // Adjust index for leads (subtract 1 because filter section takes index 0)
          int leadIndex = index - 1;

          // Show pagination text with navigation icons as the last item when scrolled to bottom
          if (leadIndex == leads.length && _showPagination) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Pagination text on the left
                  Text(
                    'Showing $startItem-$endItem',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  // Navigation icons on the right
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
                            color: currentPage > 1
                                ? Colors.black
                                : Colors.grey[400],
                            size: 20,
                          ),
                        ),
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

          final lead = leads[leadIndex];
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
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          lead['companyName'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Lead Segment',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          lead['leadSegment'],
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Location',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  lead['location'],
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
                                  lead['status'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: lead['statusColor'],
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
                                    builder: (context) => LeadDetailsPage(),
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
        },
      ),
    );
  }
}
