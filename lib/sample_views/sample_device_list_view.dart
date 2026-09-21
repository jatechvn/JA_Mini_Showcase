import 'package:flutter/material.dart';
import '../modules/ui/app_shortcuts.dart';
import '../theme/app_colors.dart';
import '../theme/theme_provider.dart';
import '../widgets/filter_search_dock.dart';
import '../widgets/glass_widgets.dart';

class DeviceInfo {
  final String id;
  final String name;
  final String ip;
  final String data;
  final String type; // 'Mobile', 'Laptop / PC', 'Server / IoT'
  final String vlan; // 'vlan10', 'vlan20', 'vlan30', 'vlan40', 'vlan50'
  final String vlanLabel;
  final IconData icon;

  const DeviceInfo({
    required this.id,
    required this.name,
    required this.ip,
    required this.data,
    required this.type,
    required this.vlan,
    required this.vlanLabel,
    required this.icon,
  });
}

class SampleDeviceListView extends StatefulWidget {
  const SampleDeviceListView({super.key});

  @override
  State<SampleDeviceListView> createState() => _SampleDeviceListViewState();
}

class _SampleDeviceListViewState extends State<SampleDeviceListView> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  String _selectedFilter = 'Tất cả';
  String _selectedVlan = 'all';

  static const List<DeviceInfo> _allDevices = [
    DeviceInfo(
      id: 'd1',
      name: 'iPhone 15 Pro Max (Thiết bị kiểm thử chính)',
      ip: '192.168.10.102',
      data: '450.2 MB',
      type: 'Mobile',
      vlan: 'vlan10',
      vlanLabel: 'VLAN 10 Quản trị',
      icon: Icons.phone_iphone_rounded,
    ),
    DeviceInfo(
      id: 'd2',
      name: 'MacBook Pro M3 Max 64GB',
      ip: '192.168.20.108',
      data: '2.84 GB',
      type: 'Laptop / PC',
      vlan: 'vlan20',
      vlanLabel: 'VLAN 20 Kỹ thuật',
      icon: Icons.laptop_mac_rounded,
    ),
    DeviceInfo(
      id: 'd3',
      name: 'iPad Pro 12.9" M2 Cellular',
      ip: '192.168.10.115',
      data: '320.5 MB',
      type: 'Mobile',
      vlan: 'vlan10',
      vlanLabel: 'VLAN 10 Quản trị',
      icon: Icons.tablet_mac_rounded,
    ),
    DeviceInfo(
      id: 'd4',
      name: 'Dell Precision Workstation Linux Ubuntu 24.04',
      ip: '192.168.20.145',
      data: '14.2 GB',
      type: 'Laptop / PC',
      vlan: 'vlan20',
      vlanLabel: 'VLAN 20 Kỹ thuật',
      icon: Icons.computer_rounded,
    ),
    DeviceInfo(
      id: 'd5',
      name: 'Raspberry Pi 5 Cluster Node #01',
      ip: '192.168.40.12',
      data: '89.1 MB',
      type: 'Server / IoT',
      vlan: 'vlan40',
      vlanLabel: 'VLAN 40 Cảm biến IoT',
      icon: Icons.memory_rounded,
    ),
    DeviceInfo(
      id: 'd6',
      name: 'Samsung Galaxy S24 Ultra Testbed',
      ip: '192.168.50.88',
      data: '120.4 MB',
      type: 'Mobile',
      vlan: 'vlan50',
      vlanLabel: 'VLAN 50 Khách',
      icon: Icons.smartphone_rounded,
    ),
    DeviceInfo(
      id: 'd7',
      name: 'Supermicro Edge AI Rack Server 100G',
      ip: '192.168.30.2',
      data: '85.4 GB',
      type: 'Server / IoT',
      vlan: 'vlan30',
      vlanLabel: 'VLAN 30 Hạ tầng',
      icon: Icons.dns_rounded,
    ),
    DeviceInfo(
      id: 'd8',
      name: 'ThinkPad X1 Carbon Gen 11 Windows 11 Pro',
      ip: '192.168.20.210',
      data: '1.85 GB',
      type: 'Laptop / PC',
      vlan: 'vlan20',
      vlanLabel: 'VLAN 20 Kỹ thuật',
      icon: Icons.laptop_windows_rounded,
    ),
  ];

  static const List<GlassDropdownItem<String>> _vlanDropdownItems = [
    GlassDropdownItem<String>(
      value: 'all',
      label: 'Tất cả phân vùng mạng',
      subtitle: 'Toàn bộ các VLAN kết nối',
      icon: Icons.all_inclusive_rounded,
      badge: 'ALL',
    ),
    GlassDropdownItem<String>(
      value: 'vlan10',
      label: 'VLAN 10 • Ban Quản Trị',
      subtitle: 'Dải IP 192.168.10.0/24',
      icon: Icons.security_rounded,
      badge: 'SECURE',
    ),
    GlassDropdownItem<String>(
      value: 'vlan20',
      label: 'VLAN 20 • Kỹ Thuật Dev',
      subtitle: 'Dải IP 192.168.20.0/24',
      icon: Icons.code_rounded,
      badge: 'DEVNET',
    ),
    GlassDropdownItem<String>(
      value: 'vlan30',
      label: 'VLAN 30 • Trung Tâm Dữ Liệu',
      subtitle: 'Dải IP 192.168.30.0/24',
      icon: Icons.storage_rounded,
      badge: 'DATACENTER',
    ),
    GlassDropdownItem<String>(
      value: 'vlan40',
      label: 'VLAN 40 • Thiết Bị Cảm Biến IoT',
      subtitle: 'Dải IP 192.168.40.0/24',
      icon: Icons.sensors_rounded,
      badge: 'EDGE IOT',
    ),
    GlassDropdownItem<String>(
      value: 'vlan50',
      label: 'VLAN 50 • Khách Vãng Lai',
      subtitle: 'Dải IP 192.168.50.0/24',
      icon: Icons.wifi_protected_setup_rounded,
      badge: 'GUEST',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  List<DeviceInfo> get _filteredDevices {
    final query = _searchController.text.trim().toLowerCase();

    return _allDevices.where((device) {
      // 1. Filter by VLAN droplist
      if (_selectedVlan != 'all' && device.vlan != _selectedVlan) {
        return false;
      }

      // 2. Filter by category pill
      if (_selectedFilter != 'Tất cả' && device.type != _selectedFilter) {
        return false;
      }

      // 3. Filter by search query
      if (query.isNotEmpty) {
        final matchesName = device.name.toLowerCase().contains(query);
        final matchesIp = device.ip.toLowerCase().contains(query);
        if (!matchesName && !matchesIp) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final filtered = _filteredDevices;

    return AppShortcuts(
      commands: {AppCommand.search: _searchFocus.requestFocus},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _DeviceHeader(
            colors: colors,
            totalCount: _allDevices.length,
            matchedCount: filtered.length,
          ),
          const SizedBox(height: 12),
          FilterSearchDock(
            colors: colors,
            searchCategory: 'devices',
            searchController: _searchController,
            searchFocusNode: _searchFocus,
            searchHint: 'Tìm thiết bị theo tên hoặc IP…',
            onSearchChanged: (_) => setState(() {}),
            filters: const ['Tất cả', 'Mobile', 'Laptop / PC', 'Server / IoT'],
            selectedFilter: _selectedFilter,
            onFilterSelected: (val) => setState(() => _selectedFilter = val),
            dropdownItems: _vlanDropdownItems,
            selectedDropdownValue: _selectedVlan,
            onDropdownChanged: (val) => setState(() => _selectedVlan = val),
            dropdownHint: 'Lọc theo phân vùng VLAN…',
          ),
          const SizedBox(height: 14),
          Expanded(
            child: filtered.isEmpty
                ? _DeviceEmptyState(
                    colors: colors,
                    onClear: () {
                      setState(() {
                        _searchController.clear();
                        _selectedFilter = 'Tất cả';
                        _selectedVlan = 'all';
                      });
                    },
                  )
                : ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemCount: filtered.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      return _DeviceCardItem(
                        device: filtered[index],
                        colors: colors,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _DeviceHeader extends StatelessWidget {
  final AppColors colors;
  final int totalCount;
  final int matchedCount;

  const _DeviceHeader({
    required this.colors,
    required this.totalCount,
    required this.matchedCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: colors.accentPurple.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: colors.accentPurple.withValues(alpha: 0.3),
                ),
              ),
              child: Icon(
                Icons.devices_rounded,
                color: colors.accentPurple,
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'Danh sách Thiết bị Kết nối',
              style: TextStyle(
                fontSize: 16,
                color: colors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (matchedCount != totalCount) ...[
              PillBadge(
                label: '$matchedCount KHỚP',
                color: colors.accentCyan,
                bg: colors.accentCyan.withValues(alpha: 0.12),
                border: colors.accentCyan.withValues(alpha: 0.35),
              ),
              const SizedBox(width: 8),
            ],
            PillBadge(
              label: '$totalCount HOẠT ĐỘNG',
              color: colors.accentEmerald,
              bg: colors.accentEmerald.withValues(alpha: 0.12),
              border: colors.accentEmerald.withValues(alpha: 0.35),
              showDot: true,
            ),
          ],
        ),
      ],
    );
  }
}

class _DeviceCardItem extends StatelessWidget {
  final DeviceInfo device;
  final AppColors colors;

  const _DeviceCardItem({required this.device, required this.colors});

  @override
  Widget build(BuildContext context) {
    return BentoCard(
      colors: colors,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: colors.subCardBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colors.subCardBorder),
            ),
            child: Icon(device.icon, color: colors.accentCyan, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        device.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: colors.textPrimary,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: colors.accentPurple.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: colors.accentPurple.withValues(alpha: 0.25),
                        ),
                      ),
                      child: Text(
                        device.vlanLabel,
                        style: TextStyle(
                          color: colors.accentPurple,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  'IP: ${device.ip} • Lưu lượng: ${device.data} • Nhóm: ${device.type}',
                  style: TextStyle(color: colors.textSecondary, fontSize: 11.5),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: colors.accentRose.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: colors.accentRose.withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              'Ngắt kết nối',
              style: TextStyle(
                color: colors.accentRose,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DeviceEmptyState extends StatelessWidget {
  final AppColors colors;
  final VoidCallback onClear;

  const _DeviceEmptyState({required this.colors, required this.onClear});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(28),
        constraints: const BoxConstraints(maxWidth: 380),
        decoration: BoxDecoration(
          color: colors.cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: colors.borderDefault),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off_rounded, size: 48, color: colors.textMuted),
            const SizedBox(height: 12),
            Text(
              'Không tìm thấy thiết bị phù hợp',
              style: TextStyle(
                color: colors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Hãy thử thay đổi từ khóa tìm kiếm hoặc chọn phân vùng mạng khác từ danh sách thả xuống.',
              textAlign: TextAlign.center,
              style: TextStyle(color: colors.textMuted, fontSize: 12),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: onClear,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: colors.accentCyan.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: colors.accentCyan.withValues(alpha: 0.35),
                  ),
                ),
                child: Text(
                  'Đặt lại bộ lọc',
                  style: TextStyle(
                    color: colors.accentCyan,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
