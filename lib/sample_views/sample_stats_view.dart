import 'package:flutter/material.dart';
import '../theme/theme_provider.dart';
import '../widgets/glass_widgets.dart';

class SampleStatsView extends StatelessWidget {
  const SampleStatsView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: colors.accentEmerald.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: colors.accentEmerald.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Icon(
                    Icons.speed_rounded,
                    color: colors.accentEmerald,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Giám sát Hiệu năng & Băng thông',
                  style: TextStyle(
                    fontSize: 16,
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            PillBadge(
              label: 'LIVE METRICS',
              color: colors.accentEmerald,
              bg: colors.accentEmerald.withValues(alpha: 0.12),
              border: colors.accentEmerald.withValues(alpha: 0.35),
              showDot: true,
            ),
          ],
        ),

        const SizedBox(height: 14),

        Row(
          children: [
            Expanded(
              child: BentoCard(
                colors: colors,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'TỐC ĐỘ TẢI XUỐNG',
                          style: TextStyle(
                            color: colors.textMuted,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'JetBrains Mono',
                          ),
                        ),
                        WaveIndicator(color: colors.accentEmerald, height: 10),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '14.8 MB/s',
                      style: TextStyle(
                        color: colors.textPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'JetBrains Mono',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: BentoCard(
                colors: colors,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'TỐC ĐỘ TẢI LÊN',
                          style: TextStyle(
                            color: colors.textMuted,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'JetBrains Mono',
                          ),
                        ),
                        WaveIndicator(color: colors.accentCyan, height: 10),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '3.20 MB/s',
                      style: TextStyle(
                        color: colors.textPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'JetBrains Mono',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        Expanded(
          child: BentoCard(
            colors: colors,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Chi tiết hạn mức sử dụng (Quota Table)',
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      ListTile(
                        dense: true,
                        leading: Icon(
                          Icons.data_usage_rounded,
                          color: colors.accentCyan,
                        ),
                        title: Text(
                          '192.168.1.102 (iPhone)',
                          style: TextStyle(
                            color: colors.textPrimary,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'JetBrains Mono',
                          ),
                        ),
                        trailing: Text(
                          '450.2 MB',
                          style: TextStyle(
                            color: colors.textPrimary,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'JetBrains Mono',
                          ),
                        ),
                      ),
                      Divider(color: colors.borderDefault, height: 1),
                      ListTile(
                        dense: true,
                        leading: Icon(
                          Icons.data_usage_rounded,
                          color: colors.accentCyan,
                        ),
                        title: Text(
                          '192.168.1.108 (MacBook)',
                          style: TextStyle(
                            color: colors.textPrimary,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'JetBrains Mono',
                          ),
                        ),
                        trailing: Text(
                          '1.24 GB',
                          style: TextStyle(
                            color: colors.textPrimary,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'JetBrains Mono',
                          ),
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
