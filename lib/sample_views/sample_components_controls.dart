part of 'sample_components_view.dart';

mixin _SampleComponentsControls on _SampleComponentsStateBase {
  Widget _buildButtonsSection(AppColors colors) {
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
                  '2. NÚT DẠ QUANG (GLOWING ACTION BUTTON)',
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
                  Text(
                    'Đổi trạng thái:',
                    style: TextStyle(color: colors.textMuted, fontSize: 11.5),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () =>
                        setState(() => _btnDestructive = !_btnDestructive),
                    child: PillBadge(
                      label: _btnDestructive ? 'DESTRUCTIVE' : 'NORMAL',
                      color: _btnDestructive
                          ? colors.accentRose
                          : colors.accentCyan,
                      bg:
                          (_btnDestructive
                                  ? colors.accentRose
                                  : colors.accentCyan)
                              .withValues(alpha: 0.15),
                      border:
                          (_btnDestructive
                                  ? colors.accentRose
                                  : colors.accentCyan)
                              .withValues(alpha: 0.4),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: GlowingActionButton(
                  colors: colors,
                  height: 46,
                  isDestructive: _btnDestructive,
                  icon: _btnDestructive
                      ? Icons.power_settings_new_rounded
                      : Icons.bolt_rounded,
                  label: _btnDestructive
                      ? 'DỪNG TIẾN TRÌNH ($_clickCount)'
                      : 'KÍCH HOẠT DỊCH VỤ ($_clickCount)',
                  onPressed: () {
                    setState(() => _clickCount++);
                    showAppToast(
                      context,
                      colors: colors,
                      message: 'Đã nhấn nút ($_clickCount lần)',
                      icon: Icons.touch_app_rounded,
                      accentColor: _btnDestructive
                          ? colors.accentRose
                          : colors.accentColor,
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: Container(
                  height: 46,
                  decoration: BoxDecoration(
                    color: colors.subCardBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colors.subCardBorder),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Số lần click: $_clickCount',
                    style: TextStyle(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBadgesAndTagsSection(AppColors colors) {
    return BentoCard(
      colors: colors,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '3. HUY HIỆU VIÊN NANG (PILL BADGES) & THẺ PHÍM TẮT (KBD TAGS)',
            style: TextStyle(
              color: colors.textSecondary,
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              PillBadge(
                label: 'ONLINE',
                color: colors.accentEmerald,
                bg: colors.accentEmerald.withValues(alpha: 0.12),
                border: colors.accentEmerald.withValues(alpha: 0.35),
                showDot: true,
              ),
              PillBadge(
                label: 'WARNING',
                color: colors.accentAmber,
                bg: colors.accentAmber.withValues(alpha: 0.12),
                border: colors.accentAmber.withValues(alpha: 0.35),
                icon: Icons.warning_amber_rounded,
              ),
              PillBadge(
                label: 'ERROR',
                color: colors.accentRose,
                bg: colors.accentRose.withValues(alpha: 0.12),
                border: colors.accentRose.withValues(alpha: 0.35),
                icon: Icons.cancel_outlined,
              ),
              PillBadge(
                label: 'CYAN TECH',
                color: colors.accentCyan,
                bg: colors.accentCyan.withValues(alpha: 0.12),
                border: colors.accentCyan.withValues(alpha: 0.35),
                icon: Icons.memory_rounded,
              ),
              PillBadge(
                label: 'PURPLE TAG',
                color: colors.accentPurple,
                bg: colors.accentPurple.withValues(alpha: 0.12),
                border: colors.accentPurple.withValues(alpha: 0.35),
              ),
              PillBadge(
                label: 'DEBUG v$appVersion',
                color: colors.accentAmber,
                bg: colors.accentAmber.withValues(alpha: 0.12),
                border: colors.accentAmber.withValues(alpha: 0.35),
                icon: Icons.bug_report_rounded,
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: Color(0x1FFFFFFF)),
          const SizedBox(height: 14),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            runSpacing: 8,
            children: [
              Text(
                'KbdTags:',
                style: TextStyle(
                  color: colors.textMuted,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 10),
              KbdTag(label: 'Ctrl+K', colors: colors),
              const SizedBox(width: 8),
              KbdTag(label: 'Esc', colors: colors),
              const SizedBox(width: 8),
              KbdTag(label: 'Enter', colors: colors),
              const SizedBox(width: 8),
              KbdTag(label: 'Shift+Tab', colors: colors),
              const SizedBox(width: 12),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'WaveIndicator:',
                    style: TextStyle(
                      color: colors.textMuted,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => setState(() => _waveRunning = !_waveRunning),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: colors.subCardBg,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: colors.subCardBorder),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          WaveIndicator(
                            color: _waveRunning
                                ? colors.accentEmerald
                                : colors.textMuted,
                            height: 14,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _waveRunning ? 'Chạy' : 'Dừng',
                            style: TextStyle(
                              color: colors.textPrimary,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
