import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tbo_app/controller/get_handover_controller.dart';
import 'package:tbo_app/view/common/project_page/handover_details.dart';

// Assuming the HandoverItem class (dynamically referred to as 'item' in the original code)
// has fields like: task, status, fromEmployeeName, toEmployeeName, requestDate (DateTime), and handoverNotes.
// For demonstration, we'll assume a placeholder type for the handover data structure.
// class HandoverItem {
//   final String task;
//   final String status;
//   final String fromEmployeeName;
//   final String toEmployeeName;
//   final DateTime requestDate;
//   final String handoverNotes;
//   HandoverItem({required this.task, required this.status, required this.fromEmployeeName, required this.toEmployeeName, required this.requestDate, required this.handoverNotes});
// }

// The main widget must be StatefulWidget to manage search and pagination state
class EmployeeHandoverPage extends StatefulWidget {
  const EmployeeHandoverPage({super.key});

  @override
  State<EmployeeHandoverPage> createState() => _EmployeeHandoverPageState();
}

class _EmployeeHandoverPageState extends State<EmployeeHandoverPage> {
  // --- Pagination & Search State Variables ---
  int _visibleItemCount = 10;
  final int _pageSize = 10;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Initialize controller and fetch data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Provider.of<EmployeeHandoverController>(
        context,
        listen: false,
      );
      controller.getEmployeeHandover();
    });

    // Listener for search input changes
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  // --- Search & Pagination Helper Methods ---
  void _onSearchChanged() {
    // Reset the visible count when search query changes to show the first page of results
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
      _visibleItemCount = _pageSize;
    });
  }

  void _loadMore() {
    setState(() {
      _visibleItemCount += _pageSize;
    });
  }

  // --- Filtering Logic (MODIFIED) ---
  // Search is now by BOTH fromEmployeeName and toEmployeeName
  List<dynamic> _getFilteredData(List<dynamic> allData) {
    if (_searchQuery.isEmpty) {
      return allData;
    }

    return allData.where((item) {
      // Assuming item.toEmployeeName and item.fromEmployeeName are available
      final toName = item.toEmployeeName.toLowerCase();
      final fromName = item.fromEmployeeName.toLowerCase();

      // Check if the query matches EITHER the "To" employee OR the "From" employee
      return toName.contains(_searchQuery) || fromName.contains(_searchQuery);
    }).toList();
  }

  // --- Widget Builders ---

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EmployeeHandoverController()..getEmployeeHandover(),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text(
            'Handover Requests',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.grey[800],
          elevation: 0,
          shadowColor: Colors.grey.withOpacity(0.1),
          surfaceTintColor: Colors.transparent,
        ),
        body: Consumer<EmployeeHandoverController>(
          builder: (context, controller, _) {
            // Include Search Bar here, outside the main content switcher
            return Column(
              children: [
                _buildSearchBar(),
                Expanded(child: _buildContent(context, controller)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      child: TextField(
        controller: _searchController,
        // UPDATED hintText to reflect the dual search functionality
        decoration: InputDecoration(
          hintText: "Search here",
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

  Widget _buildContent(
    BuildContext context,
    EmployeeHandoverController controller,
  ) {
    if (controller.isLoading) {
      return _buildLoadingState();
    }

    if (controller.errorMessage != null) {
      return _buildErrorState(context, controller);
    }

    final allHandoverList = controller.handoverData?.data ?? [];
    final filteredList = _getFilteredData(allHandoverList);

    if (filteredList.isEmpty && allHandoverList.isNotEmpty) {
      // Case: Data loaded, but search query yields no results
      return _buildNoSearchResultsState();
    }

    if (filteredList.isEmpty) {
      // Case: No data loaded at all
      return _buildEmptyState();
    }

    return _buildHandoverList(context, controller, filteredList);
  }

  Widget _buildNoSearchResultsState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.search_off_rounded,
                size: 48,
                color: Colors.orange[400],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No matching results',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "No handovers found matching the name '${_searchController.text}'.",
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () => _searchController.clear(),
              child: const Text("Clear Search"),
              style: TextButton.styleFrom(foregroundColor: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }

  // MODIFIED: _buildHandoverList to handle "Load More" logic
  Widget _buildHandoverList(
    BuildContext context,
    EmployeeHandoverController controller,
    List<dynamic> filteredList,
  ) {
    // Determine which items to show based on the current visible count
    final itemsToShow = filteredList.take(_visibleItemCount).toList();
    final hasMore = filteredList.length > _visibleItemCount;

    return RefreshIndicator(
      onRefresh: () async {
        // Reset view count on refresh to start from the top
        setState(() {
          _visibleItemCount = _pageSize;
        });
        await controller.getEmployeeHandover();
      },
      color: Colors.blue,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        // Add 1 for the "Load More" button if available
        itemCount: itemsToShow.length + (hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < itemsToShow.length) {
            final item = itemsToShow[index];
            return _buildHandoverCard(context, item);
          } else {
            // Show Load More button at the end
            return _buildLoadMoreButton();
          }
        },
      ),
    );
  }

  // NEW Widget: Load More Button (UPDATED to remove redundant page size text)
  Widget _buildLoadMoreButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 20.0),
      child: Center(
        child: OutlinedButton.icon(
          onPressed: _loadMore,
          icon: const Icon(Icons.expand_more_rounded, size: 20),
          label: const Text("Load More"),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.blue,
            side: BorderSide(color: Colors.blue.withOpacity(0.5)),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }

  // MODIFIED: _buildHandoverCard signature updated (logic remains the same)
  Widget _buildHandoverCard(BuildContext context, dynamic item) {
    // The rest of the card content logic remains the same.
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HandoverDetailPage(handoverItem: item),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with task title and status
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            item.task,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                              height: 1.3,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: item.status == 'Approved'
                                ? Colors.green.withOpacity(0.15)
                                : item.status == 'Rejected'
                                ? Colors.red.withOpacity(0.15)
                                : Colors.orange.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: item.status == 'Approved'
                                  ? Colors.green
                                  : item.status == 'Rejected'
                                  ? Colors.red
                                  : Colors.orange,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                item.status == 'Approved'
                                    ? Icons.check_circle
                                    : item.status == 'Rejected'
                                    ? Icons.cancel
                                    : Icons.hourglass_top,
                                size: 14,
                                color: item.status == 'Approved'
                                    ? Colors.green
                                    : item.status == 'Rejected'
                                    ? Colors.red
                                    : Colors.orange,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                item.status,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: item.status == 'Approved'
                                      ? Colors.green
                                      : item.status == 'Rejected'
                                      ? Colors.red
                                      : Colors.orange,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Employee transfer info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    // From employee
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'FROM',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[600],
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.fromEmployeeName,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Arrow
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.arrow_forward,
                        size: 16,
                        color: Colors.blue[600],
                      ),
                    ),

                    // To employee
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'TO',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[600],
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.toEmployeeName,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Request date
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Requested on ${item.requestDate.toLocal().toString().split(' ')[0]}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              // Notes section
              if (item.handoverNotes.isNotEmpty) ...[
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.amber[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.amber.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.note_outlined,
                            size: 16,
                            color: Colors.amber[700],
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Notes',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.amber[700],
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.handoverNotes,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[800],
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // The rest of the support functions (e.g., _buildLoadingState, _buildErrorState, _buildEmptyState, _getStatusColor, _getStatusIcon)
  // are defined below, maintaining the original logic and design.

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Loading handover requests...',
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

  Widget _buildErrorState(
    BuildContext context,
    EmployeeHandoverController controller,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.error_outline,
                size: 48,
                color: Colors.red[400],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              controller.errorMessage!,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => controller.getEmployeeHandover(),
              icon: const Icon(Icons.refresh, size: 20),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.assignment_outlined,
                size: 64,
                color: Colors.blue[300],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No handover requests',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'There are currently no handover requests to display',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'completed':
      case 'accepted':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Icons.access_time;
      case 'completed':
      case 'accepted':
        return Icons.check_circle_outline;
      case 'rejected':
        return Icons.cancel_outlined;
      default:
        return Icons.info_outline;
    }
  }
}
