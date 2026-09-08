part of 'sample_components_view.dart';

mixin _SampleComponentsDropdowns on _SampleComponentsStateBase {
  Widget _buildDropdownSection(AppColors colors, ThemeProvider theme) {
    final gatewayItems = [
      const GlassDropdownItem<String>(
        value: 'vn-south-1',
        label: 'TP. Hồ Chí Minh Fiber 10G',
        subtitle: 'vn-south-1 • Ping: 2ms',
        icon: Icons.flash_on_rounded,
        badge: 'CỰC NHANH',
      ),
      const GlassDropdownItem<String>(
        value: 'vn-north-1',
        label: 'Hà Nội Local Edge 10G',
        subtitle: 'vn-north-1 • Ping: 3ms',
        icon: Icons.electric_bolt_rounded,
        badge: 'CỰC NHANH',
      ),
      const GlassDropdownItem<String>(
        value: 'ap-southeast-1',
        label: 'Singapore Central Hub',
        subtitle: 'ap-southeast-1 • Ping: 14ms',
        icon: Icons.dns_rounded,
        badge: 'ONLINE',
      ),
      const GlassDropdownItem<String>(
        value: 'ap-east-1',
        label: 'Hong Kong Gateway 01',
        subtitle: 'ap-east-1 • Ping: 25ms',
        icon: Icons.router_rounded,
        badge: 'ONLINE',
      ),
      const GlassDropdownItem<String>(
        value: 'ap-northeast-1',
        label: 'Tokyo Core Datacenter',
        subtitle: 'ap-northeast-1 • Ping: 42ms',
        icon: Icons.hub_rounded,
        badge: 'ONLINE',
      ),
      const GlassDropdownItem<String>(
        value: 'ap-northeast-2',
        label: 'Seoul AI Inference Node',
        subtitle: 'ap-northeast-2 • Ping: 48ms',
        icon: Icons.memory_rounded,
        badge: 'TẢI CAO',
      ),
      const GlassDropdownItem<String>(
        value: 'in-west-1',
        label: 'Mumbai High-Speed Hub',
        subtitle: 'in-west-1 • Ping: 82ms',
        icon: Icons.cell_tower_rounded,
        badge: 'ONLINE',
      ),
      const GlassDropdownItem<String>(
        value: 'ap-southeast-2',
        label: 'Sydney Edge Cluster',
        subtitle: 'ap-southeast-2 • Ping: 95ms',
        icon: Icons.dns_rounded,
        badge: 'ONLINE',
      ),
      const GlassDropdownItem<String>(
        value: 'me-central-1',
        label: 'Dubai Fast Gateway',
        subtitle: 'me-central-1 • Ping: 110ms',
        icon: Icons.bolt_rounded,
        badge: 'ONLINE',
      ),
      const GlassDropdownItem<String>(
        value: 'eu-central-1',
        label: 'Frankfurt Primary Node',
        subtitle: 'eu-central-1 • Ping: 155ms',
        icon: Icons.corporate_fare_rounded,
        badge: 'ONLINE',
      ),
      const GlassDropdownItem<String>(
        value: 'eu-west-1',
        label: 'Ireland Media Cache',
        subtitle: 'eu-west-1 • Ping: 162ms',
        icon: Icons.folder_zip_rounded,
        badge: 'ONLINE',
      ),
      const GlassDropdownItem<String>(
        value: 'eu-west-2',
        label: 'London Financial Relay',
        subtitle: 'eu-west-2 • Ping: 168ms',
        icon: Icons.currency_exchange_rounded,
        badge: 'ONLINE',
      ),
      const GlassDropdownItem<String>(
        value: 'eu-north-1',
        label: 'Stockholm Eco Green Node',
        subtitle: 'eu-north-1 • Ping: 175ms',
        icon: Icons.eco_rounded,
        badge: 'ECO MODE',
      ),
      const GlassDropdownItem<String>(
        value: 'us-west-1',
        label: 'Silicon Valley Backbone',
        subtitle: 'us-west-1 • Ping: 145ms',
        icon: Icons.cloud_done_rounded,
        badge: 'ONLINE',
      ),
      const GlassDropdownItem<String>(
        value: 'us-west-2',
        label: 'Oregon Compute Farm',
        subtitle: 'us-west-2 • Ping: 152ms',
        icon: Icons.speed_rounded,
        badge: 'ONLINE',
      ),
      const GlassDropdownItem<String>(
        value: 'us-east-1',
        label: 'N. Virginia Cloud Mesh',
        subtitle: 'us-east-1 • Ping: 180ms',
        icon: Icons.alt_route_rounded,
        badge: 'STANDBY',
      ),
      const GlassDropdownItem<String>(
        value: 'ca-central-1',
        label: 'Montreal Vault Node',
        subtitle: 'ca-central-1 • Ping: 190ms',
        icon: Icons.lock_outline_rounded,
        badge: 'BẢO MẬT',
      ),
      const GlassDropdownItem<String>(
        value: 'sa-east-1',
        label: 'São Paulo South Node',
        subtitle: 'sa-east-1 • Ping: 310ms',
        icon: Icons.public_rounded,
        badge: 'PING CAO',
      ),
      const GlassDropdownItem<String>(
        value: 'af-south-1',
        label: 'Cape Town Satellite Link',
        subtitle: 'af-south-1 • Ping: 290ms',
        icon: Icons.satellite_alt_rounded,
        badge: 'PING CAO',
      ),
    ];

    final activeGateway = gatewayItems.firstWhere(
      (item) => item.value == _selectedGateway,
      orElse: () => gatewayItems.first,
    );

    return BentoCard(
      colors: colors,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '6. MENU CHỌN KÍNH MỜ CHO DANH SÁCH DÀI (GLASS DROPDOWN & DROPLIST)',
                  style: TextStyle(
                    color: colors.textSecondary,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              PillBadge(
                label: '20+ ITEMS & LIVE SEARCH',
                color: colors.accentPurple,
                bg: colors.accentPurple.withValues(alpha: 0.12),
                border: colors.accentPurple.withValues(alpha: 0.35),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Thành phần Dropdown / Droplist chuyên dụng cho danh sách dài theo phong cách Apple Liquid Glass: Tự động kích hoạt thanh tìm kiếm khi danh sách vượt quá 5 mục, cuộn bật nảy BouncingScrollPhysics mượt mà, viền sáng specular phản chiếu, và highlight mục đã chọn bằng pill accent (tuân thủ luật số 6 của dự án).',
            style: TextStyle(
              color: colors.textMuted,
              fontSize: 12,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 650;
              final col1 = _buildDropdownDemoColumn(
                title: 'Cụm Gateway Mạng (Danh sách dài 19 máy chủ):',
                colors: colors,
                child: GlassDropdown<String>(
                  colors: colors,
                  items: gatewayItems,
                  value: _selectedGateway,
                  hintText: 'Chọn cụm Gateway…',
                  onChanged: (val) => setState(() => _selectedGateway = val),
                ),
              );
              final col2 = _buildDropdownDemoColumn(
                title: 'Cấu hình Máy & Đồ họa (Tự động nhận diện từ Topbar):',
                colors: colors,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: colors.subCardBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colors.subCardBorder),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: theme.effectiveTier.color.withValues(
                            alpha: 0.15,
                          ),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: theme.effectiveTier.color.withValues(
                              alpha: 0.35,
                            ),
                          ),
                        ),
                        child: Icon(
                          theme.effectiveTier.icon,
                          color: theme.effectiveTier.color,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              runSpacing: 4,
                              children: [
                                Text(
                                  theme.perfLabel,
                                  style: TextStyle(
                                    color: colors.textPrimary,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                PillBadge(
                                  label: '${theme.cpuCores} CORES',
                                  color: theme.effectiveTier.color,
                                  bg: theme.effectiveTier.color.withValues(
                                    alpha: 0.12,
                                  ),
                                  border: theme.effectiveTier.color.withValues(
                                    alpha: 0.3,
                                  ),
                                  fontSize: 9.5,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 1,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${theme.effectiveTier.desc} • Điểm: ${theme.hardwareScore}/100',
                              style: TextStyle(
                                color: colors.textSecondary,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () => theme.cyclePerfTier(),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: colors.accentColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: colors.accentColor.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            'Đổi Tier ⚡',
                            style: TextStyle(
                              color: colors.accentColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );

              if (isWide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: col1),
                    const SizedBox(width: 16),
                    Expanded(child: col2),
                  ],
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [col1, const SizedBox(height: 14), col2],
              );
            },
          ),
          const SizedBox(height: 16),
          // Active state readout
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: colors.subCardBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colors.subCardBorder),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle_rounded,
                  color: colors.accentEmerald,
                  size: 18,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Đang kích hoạt: ${activeGateway.label} (${activeGateway.value}) • Cấu hình Topbar: ${theme.perfLabel} (${theme.effectiveTier.desc})',
                    style: TextStyle(
                      color: colors.textPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                PillBadge(
                  label: activeGateway.badge ?? 'ONLINE',
                  color: colors.accentCyan,
                  bg: colors.accentCyan.withValues(alpha: 0.12),
                  border: colors.accentCyan.withValues(alpha: 0.3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownDemoColumn({
    required String title,
    required AppColors colors,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: colors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}
