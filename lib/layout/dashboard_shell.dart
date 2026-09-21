import 'dart:io';
import '../modules/ui/app_shortcuts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';
import '../theme/language_provider.dart';
import '../theme/app_colors.dart';
import '../modules/constants.dart' as app_constants;
import '../modules/ota_update_service.dart';
import '../widgets/glass_widgets.dart';
import '../widgets/glass_dialog.dart';
import '../widgets/glass_update_dialog.dart';
import '../widgets/mobile_dock_nav.dart';
import '../widgets/app_toast.dart';
import '../sample_views/sample_bento_overview.dart';
import '../sample_views/sample_components_view.dart';
import '../sample_views/sample_device_list_view.dart';
import '../sample_views/sample_stats_view.dart';

part 'dashboard_shell_settings.dart';

class DashboardShell extends StatefulWidget {
  final String appTitle;
  final String appVersion;
  final bool isDebug;
  final String? buildTimestamp;

  const DashboardShell({
    super.key,
    this.appTitle = 'JA App Dashboard',
    this.appVersion = app_constants.appVersion,
    this.isDebug = false,
    this.buildTimestamp,
  });

  @override
  State<DashboardShell> createState() => _DashboardShellState();
}

class _DashboardShellState extends State<DashboardShell> {
  int _currentIndex = 0;
  bool _isServiceRunning = true;
  UpdatePackageInfo? _availableUpdate;

  @override
  void initState() {
    super.initState();
    _checkOtaUpdatesOnStartup();
  }

  Future<void> _checkOtaUpdatesOnStartup() async {
    try {
      final config = await OtaUpdateService().getConfig();
      final should = OtaUpdateService().shouldCheckForUpdates(
        lastCheckTime: config.lastCheckTime,
        interval: config.checkInterval,
      );
      if (!should) return;

      // Subtle delay so initial UI layout and window rendering settle first
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;

      final result = await OtaUpdateService().checkForUpdates(isManual: false);
      if (mounted && result.hasUpdate && result.packageInfo != null) {
        setState(() {
          _availableUpdate = result.packageInfo;
        });
      }
    } catch (e) {
      debugPrint('[DashboardShell] OTA startup check error: $e');
    }
  }

  // Below this width the top SlidingPillTabBar hides and MobileDockNav
  // takes over, matching tablet/mobile responsive breakpoints.
  static const double _mobileBreakpoint = 880;

  static const _tabIcons = [
    Icons.dashboard_rounded,
    Icons.widgets_rounded,
    Icons.terminal_rounded,
    Icons.devices_rounded,
    Icons.speed_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();
    final language = context.watch<LanguageProvider>();
    final colors = theme.colors;
    final isMobile = MediaQuery.of(context).size.width < _mobileBreakpoint;

    return AppShortcuts(
      commands: {
        for (var i = 0; i < 5; i++)
          AppCommand.values[i]: () => setState(() => _currentIndex = i),
        AppCommand.settings: () =>
            _showGlassSettingsDialog(context, theme, language),
        AppCommand.theme: theme.toggleTheme,
      },
      child: GlassScaffold(
        colors: colors,
        header: _buildTopHeader(context, theme, language, colors, isMobile),
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(18, 0, 18, isMobile ? 84 : 16),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                child: _buildCurrentView(),
              ),
            ),
            if (isMobile)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: MobileDockNav(
                  colors: colors,
                  currentIndex: _currentIndex,
                  tabs: language.tabLabels,
                  icons: _tabIcons,
                  onTabSelected: (index) =>
                      setState(() => _currentIndex = index),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentView() {
    switch (_currentIndex) {
      case 0:
        return SampleBentoOverview(
          key: const ValueKey('Overview'),
          isRunning: _isServiceRunning,
          onToggleService: () =>
              setState(() => _isServiceRunning = !_isServiceRunning),
        );
      case 1:
        return const SampleComponentsView(key: ValueKey('Components'));
      case 2:
        return const GlassTerminalPanel(key: ValueKey('Terminal'));
      case 3:
        return const SampleDeviceListView(key: ValueKey('Devices'));
      case 4:
        return const SampleStatsView(key: ValueKey('Stats'));
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildTopHeader(
    BuildContext context,
    ThemeProvider theme,
    LanguageProvider language,
    AppColors colors,
    bool isMobile,
  ) {
    final timestamp = widget.buildTimestamp ?? _getFallbackBuildTimestamp();
    final screenWidth = MediaQuery.of(context).size.width;
    final isCompact = screenWidth < 1220;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: colors.headerBg,
        border: Border(
          bottom: BorderSide(color: colors.headerBorder, width: 1),
        ),
      ),
      child: Row(
        children: [
          // Brand Logo + Title + Version Tag
          InkWell(
            onTap: () => setState(() => _currentIndex = 0),
            borderRadius: BorderRadius.circular(10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [colors.accentColor, colors.accentCyan],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: colors.primaryGlow.withValues(alpha: 0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'JA',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 13.5,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.appTitle,
                          style: TextStyle(
                            color: colors.textPrimary,
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                            letterSpacing: 0.3,
                          ),
                        ),
                        if (widget.isDebug) ...[
                          const SizedBox(width: 6),
                          PillBadge(
                            label: 'DEBUG',
                            color: colors.accentAmber,
                            bg: colors.accentAmber.withValues(alpha: 0.15),
                            border: colors.accentAmber.withValues(alpha: 0.4),
                            icon: Icons.bug_report_rounded,
                            fontSize: 9.5,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(
                      width: 130,
                      child: AsymmetricMarqueeText(
                        text: widget.isDebug
                            ? 'v${widget.appVersion} ($timestamp)'
                            : 'v${widget.appVersion}',
                        style: TextStyle(
                          color: colors.textMuted,
                          fontFamily: 'JetBrains Mono',
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(width: isMobile ? 8 : 20),

          // Sliding Pill Tab Bar (Centered) — hidden on narrow/mobile-width
          // windows in favor of the floating MobileDockNav at the bottom.
          Expanded(
            child: isMobile
                ? const SizedBox.shrink()
                : Center(
                    child: SlidingPillTabBar(
                      colors: colors,
                      currentIndex: _currentIndex,
                      tabs: language.tabLabels,
                      icons: _tabIcons,
                      onTabSelected: (index) =>
                          setState(() => _currentIndex = index),
                    ),
                  ),
          ),

          SizedBox(width: isMobile ? 8 : 12),

          // Dynamic Island Status Capsule
          DynamicIslandCapsule(
            colors: colors,
            isRunning: _isServiceRunning,
            statusText: _isServiceRunning
                ? language.t('status_live')
                : language.t('status_standby'),
            subText: (!isMobile && screenWidth > 960 && _isServiceRunning)
                ? language.t('status_devices')
                : null,
            onTap: () => setState(() => _currentIndex = 0),
          ),

          const SizedBox(width: 8),

          // 1. Quick Performance Tier Switcher (⚡ Auto / Ultra / Balanced / Lite)
          TopBarExpandingButton(
            icon: Icon(
              theme.effectiveTier.icon,
              color: theme.effectiveTier.color,
              size: 14,
            ),
            collapsedLabel: isCompact ? null : theme.perfLabel,
            expandedLabel: '⚡ ${theme.perfLabel}',
            textColor: theme.effectiveTier.color,
            isCompact: isCompact,
            tooltip: language.t('perf_tooltip'),
            colors: colors,
            onTap: () {
              theme.cyclePerfTier();
              final langCode = language.currentLanguage.code;
              String msg;
              if (langCode == 'EN') {
                msg =
                    '⚡ Graphic Tier: ${theme.perfLabel} (Optimized for ${theme.cpuCores} CPU Cores)';
              } else if (langCode == 'CN') {
                msg =
                    '⚡ 硬件档位: ${theme.perfLabel} (针对 ${theme.cpuCores} 核处理器优化)';
              } else {
                msg =
                    '⚡ Cấu hình máy: ${theme.perfLabel} (Tự động nhận diện CPU ${theme.cpuCores} Cores)';
              }
              showAppToast(
                context,
                message: msg,
                colors: colors,
                icon: Icons.bolt_rounded,
              );
            },
          ),

          const SizedBox(width: 6),

          // 2. Quick Language Switcher (🌐 VI / EN / CN)
          TopBarExpandingButton(
            icon: Text(
              language.currentLanguage.flag,
              style: const TextStyle(fontSize: 12),
            ),
            collapsedLabel: isCompact ? null : language.currentLanguage.code,
            expandedLabel:
                '${language.currentLanguage.flag} ${language.currentLanguage.label}',
            textColor: colors.accentCyan,
            isCompact: isCompact,
            tooltip: language.t('lang_tooltip'),
            colors: colors,
            onTap: () {
              language.cycleLanguage();
              showAppToast(
                context,
                message: language.t('lang_changed_msg'),
                colors: colors,
                icon: Icons.language_rounded,
              );
            },
          ),

          const SizedBox(width: 6),

          // 3. 1-Click Theme Toggle Button with Hover Zoom & Full Text
          TopBarExpandingButton(
            icon: Icon(
              theme.isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              color: theme.isDark ? colors.accentAmber : colors.accentPurple,
              size: 14,
            ),
            collapsedLabel: null,
            expandedLabel: language.t(
              theme.isDark ? 'theme_light' : 'theme_dark',
            ),
            textColor: theme.isDark ? colors.accentAmber : colors.accentPurple,
            isCompact: isCompact,
            tooltip:
                '${language.t('theme_tooltip')} (${AppShortcuts.label('Shift+L')})',
            colors: colors,
            onTap: () => theme.toggleTheme(),
          ),

          const SizedBox(width: 6),

          // 4. OTA Update Available Pill (If detected)
          if (_availableUpdate != null) ...[
            TopBarExpandingButton(
              icon: Icon(
                Icons.system_update_alt_rounded,
                color: colors.accentEmerald,
                size: 14,
              ),
              collapsedLabel: isCompact
                  ? null
                  : _availableUpdate!.version.displayVersion,
              expandedLabel: '🚀 ${_availableUpdate!.version.displayVersion}',
              textColor: colors.accentEmerald,
              isCompact: isCompact,
              tooltip: language.t('ota_update_tooltip', [
                _availableUpdate!.version.displayVersion,
              ]),
              colors: colors,
              onTap: () {
                showGlassUpdateDialog(
                  context: context,
                  packageInfo: _availableUpdate!,
                );
              },
            ),
            const SizedBox(width: 6),
          ],

          // 5. Glassmorphism Settings Button with Hover Zoom & Full Text
          TopBarExpandingButton(
            icon: Icon(
              Icons.settings_rounded,
              color: colors.textSecondary,
              size: 14,
            ),
            collapsedLabel: null,
            expandedLabel: language.t('settings_btn_label'),
            textColor: colors.accentCyan,
            isCompact: isCompact,
            tooltip:
                '${language.t('settings_tooltip')} (${AppShortcuts.label(',')})',
            colors: colors,
            onTap: () => _showGlassSettingsDialog(context, theme, language),
          ),
        ],
      ),
    );
  }

  void _showGlassSettingsDialog(
    BuildContext context,
    ThemeProvider theme,
    LanguageProvider language,
  ) {
    final colors = theme.colors;
    final origCardBlur = theme.cardBlur;
    final origCardOpacity = theme.cardOpacity;
    final origDialogBlur = theme.dialogBlur;
    final origDialogOpacity = theme.dialogOpacity;
    final origDropdownBlur = theme.dropdownBlur;
    final origDropdownOpacity = theme.dropdownOpacity;

    double localCardBlur = origCardBlur;
    double localCardOpacity = origCardOpacity;
    double localDialogBlur = origDialogBlur;
    double localDialogOpacity = origDialogOpacity;
    double localDropdownBlur = origDropdownBlur;
    double localDropdownOpacity = origDropdownOpacity;

    int activeTab = 0;

    showDialog<bool>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return GlassDialog(
              title: language.t('settings_dialog_title'),
              icon: Icons.tune_rounded,
              isDark: theme.isDark,
              width: 620,
              height: 580,
              contentPadding: EdgeInsets.zero,
              blurSigma: localDialogBlur,
              bgOpacity: localDialogOpacity,
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                  },
                  child: Text(
                    language.t('action_cancel'),
                    style: TextStyle(color: colors.textSecondary),
                  ),
                ),
                const SizedBox(width: 8),
                GlowingActionButton(
                  height: 36,
                  colors: colors,
                  icon: Icons.save_rounded,
                  label: language.t('action_save'),
                  onPressed: () => Navigator.pop(ctx, true),
                ),
              ],
              child: Column(
                children: [
                  _SettingsTabSelector(
                    activeTab: activeTab,
                    colors: colors,
                    language: language,
                    onTabSelected: (index) {
                      setDialogState(() => activeTab = index);
                    },
                  ),
                  Divider(color: colors.subCardBorder, height: 1),
                  Expanded(
                    child: activeTab == 0
                        ? _SettingsGlassTuningTab(
                            colors: colors,
                            theme: theme,
                            language: language,
                            localCardBlur: localCardBlur,
                            localCardOpacity: localCardOpacity,
                            localDialogBlur: localDialogBlur,
                            localDialogOpacity: localDialogOpacity,
                            localDropdownBlur: localDropdownBlur,
                            localDropdownOpacity: localDropdownOpacity,
                            onCardBlurChanged: (v) {
                              setDialogState(() => localCardBlur = v);
                              theme.setLiveGlassmorphism(cardBlur: v);
                            },
                            onCardOpacityChanged: (v) {
                              setDialogState(() => localCardOpacity = v);
                              theme.setLiveGlassmorphism(cardOpacity: v);
                            },
                            onDialogBlurChanged: (v) {
                              setDialogState(() => localDialogBlur = v);
                              theme.setLiveGlassmorphism(dialogBlur: v);
                            },
                            onDialogOpacityChanged: (v) {
                              setDialogState(() => localDialogOpacity = v);
                              theme.setLiveGlassmorphism(dialogOpacity: v);
                            },
                            onDropdownBlurChanged: (v) {
                              setDialogState(() => localDropdownBlur = v);
                              theme.setLiveGlassmorphism(dropdownBlur: v);
                            },
                            onDropdownOpacityChanged: (v) {
                              setDialogState(() => localDropdownOpacity = v);
                              theme.setLiveGlassmorphism(dropdownOpacity: v);
                            },
                            onResetDefaults: () {
                              setDialogState(() {
                                localCardBlur = 20.0;
                                localCardOpacity = 0.25;
                                localDialogBlur = 20.0;
                                localDialogOpacity = 0.85;
                                localDropdownBlur = 20.0;
                                localDropdownOpacity = 0.86;
                              });
                              theme.setLiveGlassmorphism(
                                cardBlur: 20.0,
                                cardOpacity: 0.25,
                                dialogBlur: 20.0,
                                dialogOpacity: 0.85,
                                dropdownBlur: 20.0,
                                dropdownOpacity: 0.86,
                              );
                            },
                          )
                        : (activeTab == 1
                              ? _SettingsOtaUpdateTab(
                                  colors: colors,
                                  theme: theme,
                                  language: language,
                                  appVersion: widget.appVersion,
                                  onUpdateFound: (pkg) {
                                    setDialogState(() {
                                      _availableUpdate = pkg;
                                    });
                                    setState(() {
                                      _availableUpdate = pkg;
                                    });
                                  },
                                )
                              : (activeTab == 2
                                    ? _SettingsUserGuideTab(
                                        colors: colors,
                                        language: language,
                                      )
                                    : _SettingsAboutTab(
                                        colors: colors,
                                        theme: theme,
                                        language: language,
                                        appVersion: widget.appVersion,
                                        isDebug: widget.isDebug,
                                      ))),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).then((saved) {
      if (!mounted || saved == true) return;
      theme.setLiveGlassmorphism(
        cardBlur: origCardBlur,
        cardOpacity: origCardOpacity,
        dialogBlur: origDialogBlur,
        dialogOpacity: origDialogOpacity,
        dropdownBlur: origDropdownBlur,
        dropdownOpacity: origDropdownOpacity,
      );
    });
  }

  String _getFallbackBuildTimestamp() {
    try {
      final exe = File(Platform.resolvedExecutable);
      final so = File(
        '${exe.parent.path}${Platform.pathSeparator}data${Platform.pathSeparator}app.so',
      );
      final f = so.existsSync() ? so : (exe.existsSync() ? exe : null);
      if (f != null) {
        final dt = f.lastModifiedSync();
        return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} '
            '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}:${dt.second.toString().padLeft(2, '0')}';
      }
    } catch (_) {}
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} '
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
  }
}

/// A modern Apple Liquid Glass Pill Button for the Topbar with smooth hover zoom & label expansion
