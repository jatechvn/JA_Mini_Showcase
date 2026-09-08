part of 'sample_components_view.dart';

mixin _SampleComponentsOverlays on _SampleComponentsStateBase {
  Widget _buildOverlaysAndToastsSection(
    BuildContext context,
    AppColors colors,
    ThemeProvider theme,
  ) {
    return BentoCard(
      colors: colors,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '7. HỘP THOẠI KÍNH MỜ, SEARCH PALETTE & TOAST NOTIFICATIONS',
            style: TextStyle(
              color: colors.textSecondary,
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _buildTriggerButton(
                label: 'GlassDialog Mẫu',
                icon: Icons.aspect_ratio_rounded,
                color: colors.accentCyan,
                onTap: () => _showSampleGlassDialog(context, colors, theme),
              ),
              _buildTriggerButton(
                label: 'DetailDialog Mẫu',
                icon: Icons.info_outline_rounded,
                color: colors.accentPurple,
                onTap: () => _showSampleDetailDialog(context, colors, theme),
              ),
              _buildTriggerButton(
                label: 'Mở Command Palette',
                icon: Icons.search_rounded,
                color: colors.accentColor,
                onTap: () => _triggerCommandPalette(context, colors, theme),
              ),
              _buildTriggerButton(
                label: 'Toast Thành Công',
                icon: Icons.check_circle_outline_rounded,
                color: colors.accentEmerald,
                onTap: () => showAppToast(
                  context,
                  colors: colors,
                  message: 'Thao tác lưu dữ liệu đã hoàn tất thành công!',
                  icon: Icons.check_circle_rounded,
                  accentColor: colors.accentEmerald,
                ),
              ),
              _buildTriggerButton(
                label: 'Toast Cảnh Báo',
                icon: Icons.warning_amber_rounded,
                color: colors.accentAmber,
                onTap: () => showAppToast(
                  context,
                  colors: colors,
                  message:
                      'Băng thông hệ thống đang đạt mức 85% ngưỡng giới hạn!',
                  icon: Icons.warning_rounded,
                  accentColor: colors.accentAmber,
                ),
              ),
              _buildTriggerButton(
                label: 'Toast Lỗi',
                icon: Icons.error_outline_rounded,
                color: colors.accentRose,
                onTap: () => showAppToast(
                  context,
                  colors: colors,
                  message: 'Không thể thiết lập kết nối tới cổng dịch vụ 8090!',
                  icon: Icons.cancel_rounded,
                  accentColor: colors.accentRose,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTriggerButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final colors = context.read<ThemeProvider>().colors;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: colors.textPrimary,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlassTokensInspector(AppColors colors, ThemeProvider theme) {
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
                  '8. CHỈ SỐ GLASS TUNING HIỆN TẠI (DESIGN TOKEN INSPECTOR)',
                  style: TextStyle(
                    color: colors.textSecondary,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              PillBadge(
                label: theme.isDark ? 'DARK THEME' : 'LIGHT THEME',
                color: theme.isDark ? colors.accentPurple : colors.accentAmber,
                bg: (theme.isDark ? colors.accentPurple : colors.accentAmber)
                    .withValues(alpha: 0.12),
                border:
                    (theme.isDark ? colors.accentPurple : colors.accentAmber)
                        .withValues(alpha: 0.35),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _buildTokenMetric(
                'Card Blur',
                '${theme.cardBlur.toStringAsFixed(0)} px',
                colors,
              ),
              const SizedBox(width: 10),
              _buildTokenMetric(
                'Card Opacity',
                '${(theme.cardOpacity * 100).toInt()}%',
                colors,
              ),
              const SizedBox(width: 10),
              _buildTokenMetric(
                'Dialog Blur',
                '${theme.dialogBlur.toStringAsFixed(0)} px',
                colors,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildTokenMetric(
                'Dialog Opacity',
                '${(theme.dialogOpacity * 100).toInt()}%',
                colors,
              ),
              const SizedBox(width: 10),
              _buildTokenMetric(
                'Dropdown Blur',
                '${theme.dropdownBlur.toStringAsFixed(0)} px',
                colors,
              ),
              const SizedBox(width: 10),
              _buildTokenMetric(
                'Dropdown Opacity',
                '${(theme.dropdownOpacity * 100).toInt()}%',
                colors,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            runSpacing: 8,
            children: [
              Text(
                'Presets nhanh:',
                style: TextStyle(
                  color: colors.textMuted,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 10),
              _buildPresetChip('Aero Chuẩn (20px, 25%)', () {
                theme.setCardBlur(20);
                theme.setCardOpacity(0.25);
              }, colors),
              const SizedBox(width: 8),
              _buildPresetChip('Mờ Sâu (35px, 45%)', () {
                theme.setCardBlur(35);
                theme.setCardOpacity(0.45);
              }, colors),
              const SizedBox(width: 8),
              _buildPresetChip('Trong Suốt Nhẹ (10px, 15%)', () {
                theme.setCardBlur(10);
                theme.setCardOpacity(0.15);
              }, colors),
              const SizedBox(width: 8),
              _buildPresetChip('Mặc định', () {
                theme.resetToDefaults();
              }, colors),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPresetChip(String label, VoidCallback onTap, AppColors colors) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: colors.subCardBg,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: colors.subCardBorder),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: colors.textPrimary,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildTokenMetric(String title, String value, AppColors colors) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colors.subCardBg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: colors.subCardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(color: colors.textMuted, fontSize: 11),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                color: colors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w800,
                fontFamily: 'JetBrains Mono',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSampleGlassDialog(
    BuildContext context,
    AppColors colors,
    ThemeProvider theme,
  ) {
    showDialog(
      context: context,
      builder: (_) => GlassDialog(
        title: 'Thử Nghiệm GlassDialog',
        isDark: theme.isDark,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Đóng', style: TextStyle(color: colors.textMuted)),
          ),
          const SizedBox(width: 8),
          GlowingActionButton(
            colors: colors,
            height: 38,
            label: 'XÁC NHẬN',
            icon: Icons.done_rounded,
            onPressed: () {
              Navigator.pop(context);
              showAppToast(
                context,
                colors: colors,
                message: 'Đã xác nhận thao tác từ GlassDialog!',
                icon: Icons.thumb_up_rounded,
                accentColor: colors.accentEmerald,
              );
            },
          ),
        ],
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Đây là modal kính mờ GlassDialog bo góc 22px với viền highlight tự nhiên. Hỗ trợ cuộn nội dung, nút hành động, và tự thích ứng theo độ mờ trong cài đặt.',
              style: TextStyle(
                color: colors.textPrimary,
                fontSize: 13,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colors.subCardBg,
                borderRadius: BorderRadius.circular(10),
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
                      'Thử nghiệm tương tác trong modal thành công!',
                      style: TextStyle(
                        color: colors.textPrimary,
                        fontSize: 12.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSampleDetailDialog(
    BuildContext context,
    AppColors colors,
    ThemeProvider theme,
  ) {
    showDialog(
      context: context,
      builder: (_) => DetailDialog(
        title: 'JA_Mini_Showcase Framework',
        isDark: theme.isDark,
        badges: [
          PillBadge(
            label: 'PRODUCTION READY',
            color: colors.accentEmerald,
            bg: colors.accentEmerald.withValues(alpha: 0.12),
            border: colors.accentEmerald.withValues(alpha: 0.3),
            showDot: true,
          ),
          PillBadge(
            label: 'BENTO GLASS',
            color: colors.accentCyan,
            bg: colors.accentCyan.withValues(alpha: 0.12),
            border: colors.accentCyan.withValues(alpha: 0.3),
          ),
        ],
        subtitle: 'v$appVersion // FLUTTER DESKTOP & MOBILE ARCHITECTURE',
        description:
            'Bộ khung giao diện hoàn chỉnh kết hợp Apple Liquid Glass, Bento Grid Layout, Dynamic Island Capsule, và hiệu ứng Ambient Mesh Orbs mượt mà trên nền tảng Flutter Desktop & Mobile.',
        tags: const [
          'Flutter 3.44',
          'Liquid Glass',
          'Bento Grid',
          'Responsive Tabs',
          'Windows Acrylic',
        ],
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Đóng', style: TextStyle(color: colors.textMuted)),
          ),
          const SizedBox(width: 8),
          GlowingActionButton(
            colors: colors,
            height: 38,
            label: 'KIỂM THỬ XONG',
            icon: Icons.check_rounded,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void _triggerCommandPalette(
    BuildContext context,
    AppColors colors,
    ThemeProvider theme,
  ) {
    showCommandPalette(
      context,
      items: [
        CommandPaletteItem(
          label: 'Chuyển Theme Sáng / Tối',
          subtitle: 'Đổi chế độ màu giao diện 1-Click',
          icon: Icons.brightness_4_rounded,
          onSelect: () => theme.toggleTheme(),
        ),
        CommandPaletteItem(
          label: 'Đặt lại Glass Tuning',
          subtitle: 'Khôi phục Blur và Opacity về chuẩn mặc định',
          icon: Icons.refresh_rounded,
          onSelect: () {
            theme.resetToDefaults();
            showAppToast(
              context,
              colors: colors,
              message: 'Đã khôi phục Glass Tuning về mặc định!',
              icon: Icons.check_circle_rounded,
              accentColor: colors.accentCyan,
            );
          },
        ),
        CommandPaletteItem(
          label: 'Mở GlassDialog kiểm thử',
          subtitle: 'Bật modal kính mờ tiêu chuẩn',
          icon: Icons.aspect_ratio_rounded,
          onSelect: () => _showSampleGlassDialog(context, colors, theme),
        ),
        CommandPaletteItem(
          label: 'Mở DetailDialog kiểm thử',
          subtitle: 'Bật modal chi tiết thông số mục',
          icon: Icons.info_outline_rounded,
          onSelect: () => _showSampleDetailDialog(context, colors, theme),
        ),
      ],
    );
  }
}
