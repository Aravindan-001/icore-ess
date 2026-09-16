import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/dependency_injection.dart';
import '../../core/theme/app_theme.dart';
import '../../models/leave.dart';

class LeaveScreen extends StatefulWidget {
  const LeaveScreen({super.key});

  @override
  State<LeaveScreen> createState() => _LeaveScreenState();
}

class _LeaveScreenState extends State<LeaveScreen> {
  int _selectedTab = 0; // 0 for Summary, 1 for Balance
  DateTime _startDate = DateTime(2025, 11, 11);
  DateTime _endDate = DateTime(2025, 12, 11);
  bool _isLoading = false;
  List<LeaveBalance> _balances = [];
  List<LeaveRequest> _requests = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final results = await Future.wait([
        DependencyInjection.leaveService.getLeaveBalances(),
        DependencyInjection.leaveService.getLeaveRequests(),
      ]);
      if (mounted) {
        setState(() {
          _balances = results[0] as List<LeaveBalance>;
          _requests = results[1] as List<LeaveRequest>;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error loading leave data')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFCFD),
      appBar: AppBar(
        title: const Text('Leave'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => DependencyInjection.authService.logout(context),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          _buildTabSwitcher(),
          const SizedBox(height: 16),
          Expanded(
            child: _selectedTab == 0 ? _buildSummaryTab() : _buildBalanceTab(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabSwitcher() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 54,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.outline.withValues(alpha: 0.5)),
        ),
        child: Row(
          children: [
            Expanded(child: _buildTabButton(0, 'Leave Summary')),
            Expanded(child: _buildTabButton(1, 'Leave Balance')),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(int index, String label) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryBlue : Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppTheme.primaryBlue,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryTab() {
    return Column(
      children: [
        _buildDateFilter(),
        const SizedBox(height: 40),
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _requests.isEmpty
                  ? const Center(
                      child: Text(
                        'No leave records found.',
                        style: TextStyle(color: AppTheme.textGrey, fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _requests.length,
                      itemBuilder: (context, index) => _buildRequestCard(_requests[index]),
                    ),
        ),
      ],
    );
  }

  Widget _buildDateFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () async {
                final picked = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                  initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: Theme.of(context).colorScheme.copyWith(
                          primary: AppTheme.primaryBlue,
                          onPrimary: Colors.white,
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (picked != null) {
                  setState(() {
                    _startDate = picked.start;
                    _endDate = picked.end;
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.black54),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, color: Color(0xFF3B82F6), size: 24),
                    const SizedBox(width: 12),
                    Text(
                      '${DateFormat('yyyy-MM-dd').format(_startDate)} → ${DateFormat('yyyy-MM-dd').format(_endDate)}',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    const Spacer(),
                    const Icon(Icons.arrow_drop_down, color: Colors.black87),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: _fetchData,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF0D9488),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(Icons.search, color: Colors.white, size: 24),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestCard(LeaveRequest request) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppTheme.outline.withValues(alpha: 0.3)),
      ),
      child: ListTile(
        title: Text(request.type, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          '${DateFormat('yyyy-MM-dd').format(request.startDate)} - ${DateFormat('yyyy-MM-dd').format(request.endDate)}',
        ),
        trailing: _buildStatusChip(request.status),
      ),
    );
  }

  Widget _buildStatusChip(LeaveStatus status) {
    Color color;
    switch (status) {
      case LeaveStatus.approved: color = AppTheme.success; break;
      case LeaveStatus.rejected: color = AppTheme.error; break;
      case LeaveStatus.pending: color = AppTheme.warning; break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status.name.toUpperCase(),
        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 10),
      ),
    );
  }

  Widget _buildBalanceTab() {
    return Stack(
      children: [
        _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 100),
                itemCount: _balances.length,
                itemBuilder: (context, index) => _buildBalanceCard(_balances[index]),
              ),
        Positioned(
          bottom: 24,
          left: 80,
          right: 80,
          child: ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, AppConstants.leaveApplyRoute),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, size: 18),
                SizedBox(width: 8),
                Text('New Leave Request', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBalanceCard(LeaveBalance balance) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.outline.withValues(alpha: 0.3)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(balance.type, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(height: 32),
            _buildBalanceRow('Allocated', balance.total),
            const SizedBox(height: 12),
            _buildBalanceRow('Availed', balance.used),
            const SizedBox(height: 12),
            _buildBalanceRow('Under Approval', balance.pending),
            const SizedBox(height: 12),
            _buildBalanceRow('Balance', balance.available, isBold: true),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceRow(String label, double value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            color: isBold ? Colors.black : Colors.black87,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value.toStringAsFixed(2),
          style: TextStyle(
            fontSize: 15,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
