import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../theme/theme_provider.dart';
import '../modules/constants.dart';
import '../widgets/glass_widgets.dart';
import '../widgets/glass_dialog.dart';
import '../widgets/glass_search_history_field.dart';
import '../widgets/app_toast.dart';
import '../widgets/command_palette.dart';

part 'sample_components_state.dart';
part 'sample_components_cards.dart';
part 'sample_components_controls.dart';
part 'sample_components_motion.dart';
part 'sample_components_dropdowns.dart';
part 'sample_components_overlays.dart';

/// Interactive Component Showcase & Playground for the UI Framework.
/// Allows real-time testing of every widget, badge, button, effect, and token.
class SampleComponentsView extends StatefulWidget {
  const SampleComponentsView({super.key});

  @override
  State<SampleComponentsView> createState() => _SampleComponentsViewState();
}

class _SampleComponentsViewState extends _SampleComponentsStateBase
    with
        _SampleComponentsCards,
        _SampleComponentsControls,
        _SampleComponentsMotion,
        _SampleComponentsDropdowns,
        _SampleComponentsOverlays {
  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();
    final colors = theme.colors;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Hero Card
          _buildHeaderCard(colors, theme),
          const SizedBox(height: 14),

          // Section 1: Glass Cards & Special Glow Effects
          _buildCardsSection(colors),
          const SizedBox(height: 14),

          // Section 2: Buttons & Interactive Controls
          _buildButtonsSection(colors),
          const SizedBox(height: 14),

          // Section 2.5: Smart Search Box with History Overlay
          _buildSmartSearchSection(colors),
          const SizedBox(height: 14),

          // Section 3: Badges, KbdTags & Wave Indicator
          _buildBadgesAndTagsSection(colors),
          const SizedBox(height: 14),

          // Section 4: Bouncing Marquee Sandbox
          _buildMarqueeSandbox(colors),
          const SizedBox(height: 14),

          // Section 5: Hiệu ứng Cuộn Bật Nảy (Elastic Bouncing Scroll & Spring Lab)
          _buildBouncingScrollSection(colors),
          const SizedBox(height: 14),

          // Section 6: Glass Dropdown / Menu chọn danh sách dài
          _buildDropdownSection(colors, theme),
          const SizedBox(height: 14),

          // Section 7: Dialogs, Command Palette & Toast Notifications
          _buildOverlaysAndToastsSection(context, colors, theme),
          const SizedBox(height: 14),

          // Section 8: Glass Tuning Inspector & Presets
          _buildGlassTokensInspector(colors, theme),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
