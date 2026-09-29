part of 'glass_widgets.dart';

/// A universal, plug-and-play Glassmorphic Scaffold for Flutter Desktop & Mobile.
///
/// Wraps any custom view with the complete multi-layered Liquid Glass architecture:
/// 1. Translucent ambient gradient tint ([AppColors.bgSecondary]).
/// 2. GPU-composited floating [MeshBackground] with luminous [MeshOrb]s.
/// 3. Fully transparent scaffold background ensuring DWM Aero / Mica desktop backdrop shines through.
///
/// Example usage for any custom app:
/// ```dart
/// GlassScaffold(
///   header: MyTopBar(), // Optional
///   body: Center(
///     child: BentoCard(
///       colors: context.appColors,
///       child: Text('Hello Liquid Glass!'),
///     ),
///   ),
/// )
/// ```
class GlassScaffold extends StatelessWidget {
  final Widget body;
  final Widget? header;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final AppColors? colors;
  final bool enableMeshOrbs;
  final bool enableGradientTint;
  final bool resizeToAvoidBottomInset;
  final EdgeInsetsGeometry? padding;

  const GlassScaffold({
    super.key,
    required this.body,
    this.header,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.colors,
    this.enableMeshOrbs = true,
    this.enableGradientTint = true,
    this.resizeToAvoidBottomInset = true,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedColors = colors ?? _resolveColors(context);
    final isEfficiency = _resolveEfficiency(context);
    final effectiveBg = isEfficiency
        ? _resolveSolidBg(context, resolvedColors)
        : resolvedColors.bgPrimary;

    return Scaffold(
      backgroundColor: effectiveBg,
      appBar: appBar,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: bottomNavigationBar,
      body: Stack(
        children: [
          // 1. Mesh Gradient Base Tint (Translucent) - only active in normal mode
          if (enableGradientTint && !isEfficiency)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      resolvedColors.bgSecondary,
                      resolvedColors.bgSecondary.withValues(alpha: 0.5),
                      resolvedColors.bgSecondary.withValues(alpha: 0.2),
                    ],
                  ),
                ),
              ),
            ),

          // 2. GPU-Composited Floating Mesh Orbs - completely hidden in efficiency mode
          if (enableMeshOrbs && !isEfficiency)
            Positioned.fill(child: MeshBackground(colors: resolvedColors)),

          Positioned.fill(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ?header,
                Expanded(
                  child: padding != null
                      ? Padding(padding: padding!, child: body)
                      : body,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static bool _resolveEfficiency(BuildContext context) {
    try {
      final theme = context.watch<ThemeProvider>();
      return theme.isEfficiencyMode;
    } catch (_) {
      try {
        final focus = context.watch<WindowFocusService>();
        return focus.isEfficiencyMode;
      } catch (_) {
        return false;
      }
    }
  }

  static Color _resolveSolidBg(BuildContext context, AppColors colors) {
    try {
      final theme = context.read<ThemeProvider>();
      return theme.isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    } catch (_) {
      return const Color(0xFF0F172A);
    }
  }

  static AppColors _resolveColors(BuildContext context) {
    try {
      final theme = context.watch<ThemeProvider>();
      return theme.colors;
    } catch (_) {
      try {
        return context.appColors;
      } catch (_) {
        return win10DarkColors;
      }
    }
  }
}
