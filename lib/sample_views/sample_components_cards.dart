part of 'sample_components_view.dart';

mixin _SampleComponentsCards on _SampleComponentsStateBase {
  Widget _buildHeaderCard(AppColors colors, ThemeProvider theme) {
    return BentoCard(
      colors: colors,
      isFeatured: true,
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [colors.accentColor, colors.accentCyan],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: colors.primaryGlow.withValues(alpha: 0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.widgets_rounded,
              color: Colors.white,
              size: 26,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runSpacing: 6,
                  children: [
                    Text(
                      'Component Showcase & Testbed',
                      style: TextStyle(
                        color: colors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(width: 10),
                    PillBadge(
                      label: 'LIVE SANDBOX',
                      color: colors.accentEmerald,
                      bg: colors.accentEmerald.withValues(alpha: 0.12),
                      border: colors.accentEmerald.withValues(alpha: 0.3),
                      showDot: true,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Không gian tương tác và kiểm thử trực quan toàn diện các linh kiện UI Bento Glassmorphism khi thay đổi mã nguồn.',
                  style: TextStyle(
                    color: colors.textMuted,
                    fontSize: 12.5,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardsSection(AppColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            '1. THẺ BENTO & HIỆU ỨNG PHÁT SÁNG (CARDS & GLOW)',
            style: TextStyle(
              color: colors.textSecondary,
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
        ),
        Row(
          children: [
            // Standard BentoCard
            Expanded(
              child: BentoCard(
                colors: colors,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PillBadge(
                      label: 'STANDARD CARD',
                      color: colors.accentCyan,
                      bg: colors.accentCyan.withValues(alpha: 0.1),
                      border: colors.accentCyan.withValues(alpha: 0.25),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'BentoCard Chuẩn',
                      style: TextStyle(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Bo góc 20px, hiệu ứng kính mờ BackdropFilter và viền Highlight 1px phía trên.',
                      style: TextStyle(color: colors.textMuted, fontSize: 11.5),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Featured BentoCard
            Expanded(
              child: BentoCard(
                colors: colors,
                isFeatured: true,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PillBadge(
                      label: 'FEATURED CARD',
                      color: colors.accentColor,
                      bg: colors.accentColor.withValues(alpha: 0.12),
                      border: colors.accentColor.withValues(alpha: 0.35),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Thẻ Nổi bật (isFeatured)',
                      style: TextStyle(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Viền dạ quang Electric Blue với Shadow Glow nhẹ tạo điểm nhấn trung tâm.',
                      style: TextStyle(color: colors.textMuted, fontSize: 11.5),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            // BorderBeam Card
            Expanded(
              child: BorderBeam(
                colors: [
                  colors.accentCyan,
                  colors.accentColor,
                  colors.accentPurple,
                ],
                borderRadius: 20,
                child: BentoCard(
                  colors: colors,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PillBadge(
                        label: 'BORDER BEAM',
                        color: colors.accentPurple,
                        bg: colors.accentPurple.withValues(alpha: 0.12),
                        border: colors.accentPurple.withValues(alpha: 0.35),
                        icon: Icons.auto_awesome_rounded,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'BorderBeam Animation',
                        style: TextStyle(
                          color: colors.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Viền chuyển động đa sắc Cyan/Purple/Blue chạy liên tục quanh card.',
                        style: TextStyle(
                          color: colors.textMuted,
                          fontSize: 11.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // SpotlightGlow Card
            Expanded(
              child: SpotlightGlow(
                colors: colors,
                child: BentoCard(
                  colors: colors,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PillBadge(
                        label: 'SPOTLIGHT GLOW',
                        color: colors.accentAmber,
                        bg: colors.accentAmber.withValues(alpha: 0.12),
                        border: colors.accentAmber.withValues(alpha: 0.35),
                        icon: Icons.mouse_rounded,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Spotlight Glow Hover',
                        style: TextStyle(
                          color: colors.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Rê chuột qua card này để thấy vệt sáng ánh quang bám theo con trỏ chuột.',
                        style: TextStyle(
                          color: colors.textMuted,
                          fontSize: 11.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // RotatingGlowBorder Showcase Card
        RotatingGlowBorder(
          isActive: true,
          color: colors.accentCyan,
          borderRadius: 20,
          borderWidth: 2.0,
          glowBlur: 6.0,
          child: BentoCard(
            colors: colors,
            showTopHighlight: false,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                PillBadge(
                  label: 'ROTATING GLOW BORDER',
                  color: colors.accentCyan,
                  bg: colors.accentCyan.withValues(alpha: 0.12),
                  border: colors.accentCyan.withValues(alpha: 0.35),
                  icon: Icons.rotate_right_rounded,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Rotating Glow Border Animation (Cyber Comet)',
                        style: TextStyle(
                          color: colors.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Hiệu ứng luồng sáng neon chuyển động xoay tròn quanh chu vi card với tâm sáng trắng specular, vệt quang phổ rực rỡ và hào quang tỏa sáng (bloom). Tự động pause khi ẩn cửa sổ.',
                        style: TextStyle(
                          color: colors.textMuted,
                          fontSize: 11.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
