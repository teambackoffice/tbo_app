import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tbo_app/controller/employee_get_date_controller.dart';
import 'package:tbo_app/modal/employee_get_date_modal.dart';

// Assuming EmployeeDateRequestController and EmployeeDateRequestModal (with Datum) are defined elsewhere

class EmployeeDateRequestScreen extends StatefulWidget {
  const EmployeeDateRequestScreen({super.key});

  @override
  State<EmployeeDateRequestScreen> createState() =>
      _EmployeeDateRequestScreenState();
}

class _EmployeeDateRequestScreenState extends State<EmployeeDateRequestScreen> {
  // --- Pagination & Search State Variables ---
  // Initial number of items to show
  int _visibleItemCount = 10;
  // Step size for "Load More"
  final int _pageSize = 10;
  // Controller for the search text field
  final TextEditingController _searchController = TextEditingController();
  // Current search query
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Load data as before
    final controller = Provider.of<EmployeeDateRequestController>(
      context,
      listen: false,
    );
    controller.getEmployeeDateRequest();

    // Listener for search input changes
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  // --- Search Helper Method ---
  void _onSearchChanged() {
    // Reset the visible count when search query changes
    // This ensures that the user sees the start of the filtered list
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
      _visibleItemCount = _pageSize;
    });
  }

  // --- Pagination Helper Method ---
  void _loadMore() {
    setState(() {
      _visibleItemCount += _pageSize;
    });
  }

  // --- Filtering Logic ---
  List<Datum> _getFilteredData(List<Datum> allData) {
    if (_searchQuery.isEmpty) {
      return allData;
    }

    return allData.where((datum) {
      final name = datum.employeeName.toLowerCase();
      final task = (datum.taskSubject ?? datum.task).toLowerCase();
      final reason = (datum.reason ?? '').toLowerCase();

      return name.contains(_searchQuery) ||
          task.contains(_searchQuery) ||
          reason.contains(_searchQuery);
    }).toList();
  }

  // --- Build Methods ---

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<EmployeeDateRequestController>(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          "Date Requests",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.grey[800],
        elevation: 0,
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Container(color: Colors.grey[200], height: 1),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          _buildSearchBar(),
          // Main content area
          Expanded(child: _buildContent(controller)),
        ],
      ),
    );
  }

  // New Widget: Search Bar
  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: "Search by name, task, or reason...",
          prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: Colors.grey[500]),
                  onPressed: () {
                    _searchController.clear();
                  },
                )
              : null,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[100],
        ),
        style: TextStyle(fontSize: 16, color: Colors.grey[800]),
      ),
    );
  }

  Widget _buildContent(EmployeeDateRequestController controller) {
    if (controller.isLoading) {
      return _buildLoadingState();
    }

    if (controller.errorMessage != null) {
      return _buildErrorState(controller);
    }

    final allData = controller.requestData?.data ?? [];
    final filteredData = _getFilteredData(allData);

    if (filteredData.isNotEmpty) {
      return _buildRequestsList(filteredData);
    }

    // If we have data but the search query yields no results
    if (allData.isNotEmpty && _searchQuery.isNotEmpty) {
      return _buildNoSearchResultsState();
    }

    // Original empty state (no data fetched)
    return _buildEmptyState();
  }

  // MODIFIED: _buildRequestsList to use the filtered and paginated data
  Widget _buildRequestsList(List<Datum> filteredData) {
    // Only show items up to the current visible count
    final itemsToShow = filteredData.take(_visibleItemCount).toList();

    // Check if there are more items to load
    final hasMore = filteredData.length > _visibleItemCount;

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      // Add 1 for the "Load More" button if needed
      itemCount: itemsToShow.length + (hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < itemsToShow.length) {
          final Datum datum = itemsToShow[index];
          return _buildRequestCard(datum);
        } else {
          // This is the "Load More" button's index
          return _buildLoadMoreButton();
        }
      },
    );
  }

  // New Widget: Load More Button
  Widget _buildLoadMoreButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 20.0),
      child: Center(
        child: OutlinedButton.icon(
          onPressed: _loadMore,
          icon: Icon(Icons.expand_more_rounded, size: 20),
          label: Text("Load More "),
          style: OutlinedButton.styleFrom(
            foregroundColor: Color(0xFF667eea),
            side: BorderSide(color: Color(0xFF667eea).withOpacity(0.5)),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }

  // New Widget: No Search Results State
  Widget _buildNoSearchResultsState() {
    return Center(
      child: Container(
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.search_off_rounded,
                color: Colors.orange[400],
                size: 40,
              ),
            ),
            SizedBox(height: 20),
            Text(
              "No matching results",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Try adjusting your search query.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.4,
              ),
            ),
            SizedBox(height: 16),
            TextButton(
              onPressed: () => _searchController.clear(),
              child: Text("Clear Search"),
              style: TextButton.styleFrom(foregroundColor: Color(0xFF667eea)),
            ),
          ],
        ),
      ),
    );
  }

  // UNMODIFIED helper functions below...

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF667eea)),
            ),
          ),
          SizedBox(height: 24),
          Text(
            "Fetching requests...",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(EmployeeDateRequestController controller) {
    return Center(
      child: Container(
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red[50],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                color: Colors.red[400],
                size: 32,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Something went wrong",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 8),
            Text(
              controller.errorMessage!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.4,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => controller.getEmployeeDateRequest(),
              icon: Icon(Icons.refresh_rounded, size: 18),
              label: Text("Try Again"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF667eea),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Container(
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.event_busy_rounded,
                color: Colors.blue[400],
                size: 40,
              ),
            ),
            SizedBox(height: 20),
            Text(
              "No requests found",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 8),
            Text(
              "There are no employee date requests to display at the moment.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestCard(Datum datum) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // Handle tap - could navigate to detail screen
          },
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with name and status
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Color(0xFF667eea).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.person_outline_rounded,
                        color: Color(0xFF667eea),
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                datum.employeeName,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: datum.status == 'Approved'
                                      ? Colors.green.withOpacity(0.15)
                                      : datum.status == 'Rejected'
                                      ? Colors.red.withOpacity(0.15)
                                      : Colors.orange.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: datum.status == 'Approved'
                                        ? Colors.green
                                        : datum.status == 'Rejected'
                                        ? Colors.red
                                        : Colors.orange,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      datum.status == 'Approved'
                                          ? Icons.check_circle
                                          : datum.status == 'Rejected'
                                          ? Icons.cancel
                                          : Icons.hourglass_top,
                                      size: 14,
                                      color: datum.status == 'Approved'
                                          ? Colors.green
                                          : datum.status == 'Rejected'
                                          ? Colors.red
                                          : Colors.orange,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      datum.status,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: datum.status == 'Approved'
                                            ? Colors.green
                                            : datum.status == 'Rejected'
                                            ? Colors.red
                                            : Colors.orange,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 2),
                          Text(
                            datum.taskSubject ?? datum.task,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16),

                // Date range
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.date_range_rounded,
                        color: Colors.grey[600],
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "${_formatDate(datum.requestedStartDate)} → ${_formatDate(datum.requestedEndDate)}",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 12),

                // Reason
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.orange[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.info_outline_rounded,
                        color: Colors.orange[600],
                        size: 16,
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Reason",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            datum.reason ?? 'No reason provided',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color backgroundColor;
    Color textColor;
    IconData icon;

    switch (status.toLowerCase()) {
      case 'approved':
        backgroundColor = Colors.green[100]!;
        textColor = Colors.green[700]!;
        icon = Icons.check_circle_outline;
        break;
      case 'pending':
        backgroundColor = Colors.orange[100]!;
        textColor = Colors.orange[700]!;
        icon = Icons.schedule;
        break;
      case 'rejected':
        backgroundColor = Colors.red[100]!;
        textColor = Colors.red[700]!;
        icon = Icons.cancel_outlined;
        break;
      default:
        backgroundColor = Colors.grey[100]!;
        textColor = Colors.grey[700]!;
        icon = Icons.help_outline;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          SizedBox(width: 4),
          Text(
            status,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }
}
