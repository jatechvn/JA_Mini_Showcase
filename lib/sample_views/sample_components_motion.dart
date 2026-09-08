part of 'sample_components_view.dart';

mixin _SampleComponentsMotion on _SampleComponentsStateBase {
  Widget _buildTriggerButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  });

  Widget _buildMarqueeSandbox(AppColors colors) {
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
                  '4. CHỮ LƯỚT BẬT NẢY (BOUNCING MARQUEETEXT / _MARQUEETEXT)',
                  style: TextStyle(
                    color: colors.textSecondary,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              PillBadge(
                label: 'BOUNCE ANIMATION',
                color: colors.accentEmerald,
                bg: colors.accentEmerald.withValues(alpha: 0.12),
                border: colors.accentEmerald.withValues(alpha: 0.35),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Cơ chế _MarqueeText bật nảy: Tốc độ tuyến tính Curves.linear (60ms/ký tự) lướt đều tới cuối chuỗi -> dừng 1500ms -> búng giật nảy về đầu cực nhanh (800ms, Curves.easeOut) -> dừng 1500ms và lặp lại tuần hoàn. Tự động tắt hoàn toàn animation khi chuỗi ngắn vừa vặn.',
            style: TextStyle(
              color: colors.textMuted,
              fontSize: 12,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _marqueeController,
            style: TextStyle(color: colors.textPrimary, fontSize: 13),
            decoration: InputDecoration(
              hintText: 'Nhập nội dung thử nghiệm...',
              hintStyle: TextStyle(color: colors.textMuted),
              filled: true,
              fillColor: colors.subCardBg,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 10,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: colors.subCardBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: colors.subCardBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: colors.accentCyan),
              ),
            ),
            onChanged: (v) => setState(() {}),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildMarqueePresetChip(
                label: 'Chuỗi ngắn (Vừa khung)',
                text: 'JA Bento Glass',
                colors: colors,
              ),
              _buildMarqueePresetChip(
                label: 'Chuỗi dài vừa',
                text: 'JA Flutter Bento Glassmorphism UI Framework',
                colors: colors,
              ),
              _buildMarqueePresetChip(
                label: 'Chuỗi cực dài (Bật nảy mạnh)',
                text:
                    'Chữ lướt bật nảy _MarqueeText: Lướt đều 60ms/ký tự, dừng 1500ms, búng giật nảy về đầu cực nhanh 800ms Curves.easeOut!',
                colors: colors,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Text(
                'Live Preview Khung 280px:',
                style: TextStyle(
                  color: colors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 280,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: colors.bgSecondary,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: colors.accentCyan.withValues(alpha: 0.3),
                  ),
                ),
                child: AsymmetricMarqueeText(
                  text: _marqueeController.text.isEmpty
                      ? '(Trống)'
                      : _marqueeController.text,
                  style: TextStyle(
                    color: colors.accentCyan,
                    fontFamily: 'JetBrains Mono',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMarqueePresetChip({
    required String label,
    required String text,
    required AppColors colors,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _marqueeController.text = text;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: colors.subCardBg,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: colors.subCardBorder),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: colors.textSecondary,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildBouncingScrollSection(AppColors colors) {
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
                  '5. HIỆU ỨNG CUỘN BẬT NẢY (ELASTIC BOUNCING SCROLL & SPRING)',
                  style: TextStyle(
                    color: colors.textSecondary,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () =>
                    setState(() => _useBouncingPhysics = !_useBouncingPhysics),
                child: PillBadge(
                  label: _useBouncingPhysics
                      ? 'BOUNCING PHYSICS (BẬT NẢY)'
                      : 'CLAMPING (CHẶN CỨNG)',
                  color: _useBouncingPhysics
                      ? colors.accentEmerald
                      : colors.textMuted,
                  bg:
                      (_useBouncingPhysics
                              ? colors.accentEmerald
                              : colors.subCardBg)
                          .withValues(alpha: 0.15),
                  border:
                      (_useBouncingPhysics
                              ? colors.accentEmerald
                              : colors.subCardBorder)
                          .withValues(alpha: 0.35),
                  showDot: _useBouncingPhysics,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Thử nghiệm cơ chế cuộn bật nảy đàn hồi (Overscroll Elastic Bounce) chuẩn Apple Liquid Glass. Bạn có thể cuộn danh sách bằng chuột/cảm ứng hoặc bấm các nút kích hoạt lực đẩy lò xo bên dưới:',
            style: TextStyle(
              color: colors.textMuted,
              fontSize: 12,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),

          // Action buttons: Bounce Top, Bounce Bottom, Spring Impulse
          Wrap(
            spacing: 10,
            runSpacing: 8,
            children: [
              _buildTriggerButton(
                label: 'Bật Nảy Lên Đầu (Bounce Top)',
                icon: Icons.vertical_align_top_rounded,
                color: colors.accentCyan,
                onTap: _triggerBounceTop,
              ),
              _buildTriggerButton(
                label: 'Bật Nảy Xuống Cuối (Bounce Bottom)',
                icon: Icons.vertical_align_bottom_rounded,
                color: colors.accentPurple,
                onTap: _triggerBounceBottom,
              ),
              _buildTriggerButton(
                label: 'Kích Hoạt Lực Lò Xo Đàn Hồi',
                icon: Icons.offline_bolt_rounded,
                color: colors.accentAmber,
                onTap: () => setState(() => _bounceTrigger++),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Horizontal scrollable cards with BouncingScrollPhysics
          SizedBox(
            height: 110,
            child: ListView.separated(
              controller: _bounceListController,
              scrollDirection: Axis.horizontal,
              physics: _useBouncingPhysics
                  ? const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    )
                  : const ClampingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
              itemCount: 8,
              separatorBuilder: (_, _) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final cardTitles = [
                  'Thẻ #1 Core Engine',
                  'Thẻ #2 Băng thông',
                  'Thẻ #3 Telemetry',
                  'Thẻ #4 Cổng 8090',
                  'Thẻ #5 Proxy Mesh',
                  'Thẻ #6 Dữ liệu Quota',
                  'Thẻ #7 Live Pulse',
                  'Thẻ #8 Điểm cuối End',
                ];
                return TweenAnimationBuilder<double>(
                  key: ValueKey('bounce_card_${index}_$_bounceTrigger'),
                  duration: Duration(milliseconds: 600 + (index * 60)),
                  curve: Curves.elasticOut,
                  tween: Tween<double>(
                    begin: _bounceTrigger > 0 ? -12.0 : 0.0,
                    end: 0.0,
                  ),
                  builder: (context, offsetY, child) {
                    return Transform.translate(
                      offset: Offset(0, offsetY),
                      child: child,
                    );
                  },
                  child: Container(
                    width: 160,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colors.subCardBg,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: index == 0
                            ? colors.accentCyan.withValues(alpha: 0.4)
                            : index == 7
                            ? colors.accentPurple.withValues(alpha: 0.4)
                            : colors.subCardBorder,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '0${index + 1}',
                              style: TextStyle(
                                color: colors.textMuted,
                                fontSize: 11,
                                fontFamily: 'JetBrains Mono',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Icon(
                              index == 0
                                  ? Icons.star_rounded
                                  : index == 7
                                  ? Icons.flag_rounded
                                  : Icons.auto_awesome_mosaic_rounded,
                              color: index == 0
                                  ? colors.accentCyan
                                  : colors.textMuted,
                              size: 16,
                            ),
                          ],
                        ),
                        Text(
                          cardTitles[index],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: colors.textPrimary,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          _useBouncingPhysics
                              ? 'Bật nảy tự nhiên'
                              : 'Chặn cứng viền',
                          style: TextStyle(
                            color: _useBouncingPhysics
                                ? colors.accentEmerald
                                : colors.textMuted,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _triggerBounceTop() {
    if (!_bounceListController.hasClients) return;
    _bounceListController
        .animateTo(
          -35.0,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
        )
        .then((_) {
          if (_bounceListController.hasClients) {
            _bounceListController.animateTo(
              0.0,
              duration: const Duration(milliseconds: 450),
              curve: Curves.elasticOut,
            );
          }
        });
  }

  void _triggerBounceBottom() {
    if (!_bounceListController.hasClients) return;
    final max = _bounceListController.position.maxScrollExtent;
    _bounceListController
        .animateTo(
          max + 35.0,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
        )
        .then((_) {
          if (_bounceListController.hasClients) {
            _bounceListController.animateTo(
              max,
              duration: const Duration(milliseconds: 450),
              curve: Curves.elasticOut,
            );
          }
        });
  }
}
