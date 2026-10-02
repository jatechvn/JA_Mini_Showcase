import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:window_manager/window_manager.dart';

/// Centralized Single Source of Truth for desktop window focus, visibility,
/// and power efficiency state, implementing the 4-Tier Policy Matrix:
///
/// 1. Active + Interacting:
///    - Background MeshOrb: RUNNING
///    - Status Indicators (Wave, Beam): RUNNING
///    - Text Marquee: RUNNING
///    - Background Tasks (API, Token, OTA): RUNNING
///
/// 2. Active + User Idle (>= 12s by default):
///    - Background MeshOrb: PAUSED (frees GPU Gaussian shader passes)
///    - Status Indicators (Wave, Beam): RUNNING (responsive UI)
///    - Text Marquee: RUNNING
///    - Background Tasks: RUNNING
///
/// 3. Inactive / Unfocused:
///    - Background MeshOrb: PAUSED
///    - Status Indicators: PAUSED
///    - Text Marquee: FROZEN AT CURRENT OFFSET
///    - Blur sigma: 0 (disabled BackdropFilter on GPU)
///    - Background Tasks: RUNNING
///
/// 4. Minimized / Deep Sleep:
///    - All continuous render draw calls: FROZEN (0 FPS)
///    - Background Tasks: RUNNING 100%
class AppPowerManager extends ChangeNotifier {
  AppPowerManager._internal() {
    _updatePolicies();
  }

  static final AppPowerManager instance = AppPowerManager._internal();

  factory AppPowerManager() => instance;

  // Window & Interaction state
  bool _isWindowFocused = true;
  bool _isWindowVisible = true;
  bool _isUserIdle = false;
  bool _enableIdleSleep = true;
  int _idleTimeoutSeconds = 12;

  Timer? _idleTimer;
  DateTime Function() nowProvider = DateTime.now;
  late DateTime _lastInteractionTime = nowProvider();

  // 3 Granular ValueNotifiers for targeted UI subscription without rebuild thrashing
  final ValueNotifier<bool> backgroundAnimationNotifier = ValueNotifier<bool>(
    true,
  );
  final ValueNotifier<bool> indicatorsAnimationNotifier = ValueNotifier<bool>(
    true,
  );
  final ValueNotifier<bool> marqueeAnimationNotifier = ValueNotifier<bool>(
    true,
  );

  // Getters
  bool get isWindowFocused => _isWindowFocused;
  bool get isWindowVisible => _isWindowVisible;
  bool get isUserIdle => _isUserIdle;
  bool get enableIdleSleep => _enableIdleSleep;
  int get idleTimeoutSeconds => _idleTimeoutSeconds;

  bool get shouldAnimateBackground => backgroundAnimationNotifier.value;
  bool get shouldAnimateIndicators => indicatorsAnimationNotifier.value;
  bool get shouldAnimateMarquee => marqueeAnimationNotifier.value;

  /// Efficiency mode is active when the app is either blurred or minimized.
  bool get isEfficiencyMode => !_isWindowFocused || !_isWindowVisible;

  /// Records user interaction (pointer move, click, scroll, key press).
  ///
  /// Wakes the app from Idle Sleep immediately without throttle.
  /// When already awake, throttles timer recreation to at most once per 600ms
  /// to eliminate event churn during rapid pointer motion.
  void recordUserInteraction() {
    final now = nowProvider();
    if (_isUserIdle) {
      _isUserIdle = false;
      _lastInteractionTime = now;
      _updatePolicies();
      _restartIdleTimer();
      return;
    }

    if (now.difference(_lastInteractionTime) >=
        const Duration(milliseconds: 600)) {
      _lastInteractionTime = now;
      _restartIdleTimer();
    }
  }

  /// Toggles Idle Sleep Mode. When disabled, background animations run continuously
  /// as long as the window is active and focused.
  void setEnableIdleSleep(bool value) {
    if (_enableIdleSleep != value) {
      _enableIdleSleep = value;
      if (!value) {
        _idleTimer?.cancel();
        _idleTimer = null;
        if (_isUserIdle) {
          _isUserIdle = false;
        }
      } else {
        _restartIdleTimer();
      }
      _updatePolicies();
    }
  }

  /// Sets idle timeout duration in seconds (12s recommended, 30s, 60s).
  void setIdleTimeoutSeconds(int seconds) {
    if (seconds <= 0) return;
    if (_idleTimeoutSeconds != seconds) {
      _idleTimeoutSeconds = seconds;
      _restartIdleTimer();
      notifyListeners();
    }
  }

  void _restartIdleTimer() {
    _idleTimer?.cancel();
    _idleTimer = null;

    if (!_enableIdleSleep || !_isWindowFocused || !_isWindowVisible) {
      return;
    }

    _idleTimer = Timer(Duration(seconds: _idleTimeoutSeconds), () {
      if (!_isUserIdle) {
        _isUserIdle = true;
        _updatePolicies();
      }
    });
  }

  void _updatePolicies() {
    final bool active = _isWindowFocused && _isWindowVisible;
    final bool backgroundActive = active && (!_enableIdleSleep || !_isUserIdle);
    final bool indicatorsActive = active;
    final bool marqueeActive = active;

    bool changed = false;

    if (backgroundAnimationNotifier.value != backgroundActive) {
      backgroundAnimationNotifier.value = backgroundActive;
      changed = true;
    }
    if (indicatorsAnimationNotifier.value != indicatorsActive) {
      indicatorsAnimationNotifier.value = indicatorsActive;
      changed = true;
    }
    if (marqueeAnimationNotifier.value != marqueeActive) {
      marqueeAnimationNotifier.value = marqueeActive;
      changed = true;
    }

    if (changed) {
      notifyListeners();
    }
  }

  // Window lifecycle handlers
  void onWindowFocus() {
    if (!_isWindowFocused) {
      _isWindowFocused = true;
      _isUserIdle = false;
      _lastInteractionTime = DateTime.now();
      _restartIdleTimer();
      _updatePolicies();
    }
  }

  void onWindowBlur() {
    if (_isWindowFocused) {
      _isWindowFocused = false;
      _idleTimer?.cancel();
      _idleTimer = null;
      _updatePolicies();
    }
  }

  void onWindowMinimize() {
    bool changed = false;
    if (_isWindowVisible) {
      _isWindowVisible = false;
      changed = true;
    }
    if (_isWindowFocused) {
      _isWindowFocused = false;
      changed = true;
    }
    _idleTimer?.cancel();
    _idleTimer = null;
    if (changed) {
      _updatePolicies();
    }
  }

  /// Handles window restoration.
  ///
  /// On Windows Win32, a restored window is visible but might NOT be focused yet
  /// (e.g. restoring by clicking taskbar while another window had focus).
  /// Verifies focus via [windowManager.isFocused()] instead of blindly assuming active.
  void onWindowRestore() {
    if (!_isWindowVisible) {
      _isWindowVisible = true;
    }

    if (!kIsWeb &&
        (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
      windowManager
          .isFocused()
          .then((focused) {
            if (focused == true) {
              onWindowFocus();
            } else {
              _updatePolicies();
            }
          })
          .catchError((_) {
            // Fallback for mock environments
            _updatePolicies();
          });
    } else {
      _updatePolicies();
    }
  }

  void onLifecycleStateChanged(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        if (!_isWindowVisible) {
          _isWindowVisible = true;
        }
        if (!_isWindowFocused) {
          onWindowFocus();
        } else {
          _updatePolicies();
        }
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        onWindowBlur();
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  // Testing helpers
  void resetForTesting({bool startIdleTimer = false}) {
    nowProvider = DateTime.now;
    _idleTimer?.cancel();
    _idleTimer = null;
    _isWindowFocused = true;
    _isWindowVisible = true;
    _isUserIdle = false;
    _enableIdleSleep = true;
    _idleTimeoutSeconds = 12;
    _lastInteractionTime = nowProvider();
    if (startIdleTimer) {
      _restartIdleTimer();
    }
    _updatePolicies();
  }

  void setFocusedForTesting(bool value) {
    _isWindowFocused = value;
    if (value) {
      _isUserIdle = false;
      _lastInteractionTime = nowProvider();
      _restartIdleTimer();
    } else {
      _idleTimer?.cancel();
      _idleTimer = null;
    }
    _updatePolicies();
  }

  void setVisibleForTesting(bool value) {
    if (_isWindowVisible != value) {
      _isWindowVisible = value;
      if (!value) {
        _isWindowFocused = false;
        _idleTimer?.cancel();
        _idleTimer = null;
      }
      _updatePolicies();
    }
  }

  void setIdleForTesting(bool value) {
    if (_isUserIdle != value) {
      _isUserIdle = value;
      _updatePolicies();
    }
  }

  @override
  void dispose() {
    _idleTimer?.cancel();
    _idleTimer = null;
    backgroundAnimationNotifier.dispose();
    indicatorsAnimationNotifier.dispose();
    marqueeAnimationNotifier.dispose();
    super.dispose();
  }
}
