import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/theme_provider.dart';
import '../widgets/glass_widgets.dart';

class SampleBentoOverview extends StatelessWidget {
  final bool isRunning;
  final VoidCallback onToggleService;

  const SampleBentoOverview({
    super.key,
    required this.isRunning,
    required this.onToggleService,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top Bento Row: Hero Controller Card + Live Console Card
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left: Hero Engine Controller
              Expanded(
                flex: 12,
                child: BentoCard(
                  colors: colors,
                  isFeatured: true,
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          PillBadge(
                            label: 'CORE CONTROLLER',
                            color: colors.accentCyan,
                            bg: colors.accentCyan.withValues(alpha: 0.12),
                            border: colors.accentCyan.withValues(alpha: 0.3),
                            icon: Icons.tune_rounded,
                          ),
                          PillBadge(
                            label: isRunning ? 'ONLINE' : 'OFFLINE',
                            color: isRunning
                                ? colors.accentEmerald
                                : colors.textMuted,
                            bg: isRunning
                                ? colors.accentEmerald.withValues(alpha: 0.12)
                                : colors.subCardBg,
                            border: isRunning
                                ? colors.accentEmerald.withValues(alpha: 0.35)
                                : colors.subCardBorder,
                            showDot: true,
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'Dịch vụ Chuyển tiếp Dữ liệu',
                        style: TextStyle(
                          color: colors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Hệ thống tự động cân bằng tải và giám sát băng thông thời gian thực.',
                        style: TextStyle(
                          color: colors.textMuted,
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: GlowingActionButton(
                          height: 48,
                          colors: colors,
                          isDestructive: isRunning,
                          icon: isRunning
                              ? Icons.stop_circle_rounded
                              : Icons.play_arrow_rounded,
                          label: isRunning
                              ? 'DỪNG TIẾN TRÌNH'
                              : 'BẮT ĐẦU HOẠT ĐỘNG',
                          onPressed: onToggleService,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 14),

              // Right: Telemetry Console Card
              Expanded(
                flex: 11,
                child: BentoCard(
                  colors: colors,
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          PillBadge(
                            label: 'TELEMETRY CONSOLE',
                            color: colors.accentEmerald,
                            bg: colors.accentEmerald.withValues(alpha: 0.12),
                            border: colors.accentEmerald.withValues(alpha: 0.3),
                            icon: Icons.terminal_rounded,
                          ),
                          WaveIndicator(
                            color: colors.accentEmerald,
                            height: 12,
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: colors.subCardBg,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: colors.accentEmerald.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.hub_rounded,
                              size: 16,
                              color: colors.accentEmerald,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '127.0.0.1:8080',
                              style: TextStyle(
                                color: colors.accentEmerald,
                                fontFamily: 'JetBrains Mono',
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        isRunning
                            ? 'Tiến trình đang phản hồi ổn định'
                            : 'Hệ thống đang ở trạng thái chờ',
                        style: TextStyle(
                          color: colors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Bottom Bento Row: Mini Metrics Cards
          Row(
            children: [
              Expanded(
                child: _buildMiniCard(
                  colors: colors,
                  title: 'DOWNLOAD',
                  value: '2.45 MB/s',
                  icon: Icons.arrow_downward_rounded,
                  iconColor: colors.accentEmerald,
                  sub: 'PEAK: 12.0 MB/s',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMiniCard(
                  colors: colors,
                  title: 'UPLOAD',
                  value: '0.85 MB/s',
                  icon: Icons.arrow_upward_rounded,
                  iconColor: colors.accentCyan,
                  sub: 'OUTBOUND OK',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMiniCard(
                  colors: colors,
                  title: 'CONNECTED',
                  value: '4 CLIENTS',
                  icon: Icons.devices_rounded,
                  iconColor: colors.accentPurple,
                  sub: 'LATENCY: 12ms',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniCard({
    required AppColors colors,
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
    required String sub,
  }) {
    return BentoCard(
      colors: colors,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: iconColor.withValues(alpha: 0.3)),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: colors.textMuted,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'JetBrains Mono',
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'JetBrains Mono',
                  ),
                ),
                Text(
                  sub,
                  style: TextStyle(color: colors.textSecondary, fontSize: 9.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
