import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:window_manager/window_manager.dart';
import 'services/app_power_manager.dart';

/// Central reactive service managing desktop window focus and power efficiency state.
///
/// Listens to native OS window events via [WindowListener] and [WidgetsBindingObserver]:
/// - When the window is unfocused (inactive/blurred) or minimized, it transitions to
///   [isEfficiencyMode] = true (Low-Power Sleep Mode).
/// - When the window regains focus, it restores full rendering fidelity ([isEfficiencyMode] = false).
///
/// Dispatches lifecycle and window events to [AppPowerManager] for granular 4-tier power control.
class WindowFocusService extends ChangeNotifier
    with WindowListener, WidgetsBindingObserver {
  bool _isFocused = true;
  bool _isMinimized = false;
  bool _isInitialized = false;

  bool get isFocused => _isFocused;
  bool get isMinimized => _isMinimized;

  /// True when the app is either blurred (unfocused/background) or minimized to taskbar.
  /// When true, transparency effects (blur) and repeating animations should be paused.
  bool get isEfficiencyMode => !_isFocused || _isMinimized;

  /// Initializes window event listening on desktop platforms.
  void init() {
    if (_isInitialized) return;
    WidgetsBinding.instance.addObserver(this);
    if (!kIsWeb &&
        (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
      try {
        windowManager.addListener(this);
      } catch (e) {
        debugPrint(
          '[WindowFocusService] Error adding windowManager listener: $e',
        );
      }
    }
    _isInitialized = true;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint('[WindowFocusService] didChangeAppLifecycleState: $state');
    switch (state) {
      case AppLifecycleState.resumed:
        if (!_isFocused && !_isMinimized) {
          _isFocused = true;
          debugPrint('[WindowFocusService] App resumed -> Active Mode');
          notifyListeners();
        }
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        if (_isFocused) {
          _isFocused = false;
          debugPrint('[WindowFocusService] App $state -> Efficiency Mode');
          notifyListeners();
        }
      case AppLifecycleState.detached:
        break;
    }
    AppPowerManager.instance.onLifecycleStateChanged(state);
  }

  @override
  void onWindowFocus() {
    debugPrint('[WindowFocusService] onWindowFocus -> Active Mode');
    if (!_isFocused) {
      _isFocused = true;
      notifyListeners();
    }
    AppPowerManager.instance.onWindowFocus();
  }

  @override
  void onWindowBlur() {
    debugPrint('[WindowFocusService] onWindowBlur -> Efficiency Mode');
    if (_isFocused) {
      _isFocused = false;
      notifyListeners();
    }
    AppPowerManager.instance.onWindowBlur();
  }

  @override
  void onWindowMinimize() {
    debugPrint('[WindowFocusService] onWindowMinimize -> Deep Sleep Mode');
    bool changed = false;
    if (!_isMinimized) {
      _isMinimized = true;
      changed = true;
    }
    if (_isFocused) {
      _isFocused = false;
      changed = true;
    }
    if (changed) {
      notifyListeners();
    }
    AppPowerManager.instance.onWindowMinimize();
  }

  @override
  void onWindowRestore() {
    debugPrint('[WindowFocusService] onWindowRestore -> Restoring Window');
    bool changed = false;
    if (_isMinimized) {
      _isMinimized = false;
      changed = true;
    }
    if (!_isFocused) {
      _isFocused = true;
      changed = true;
    }
    if (changed) {
      notifyListeners();
    }
    AppPowerManager.instance.onWindowRestore();
  }

  /// Testing helper to simulate window focus changes without native OS events.
  @visibleForTesting
  void setFocusedForTesting(bool value) {
    if (_isFocused != value) {
      _isFocused = value;
      notifyListeners();
    }
    AppPowerManager.instance.setFocusedForTesting(value);
  }

  /// Testing helper to simulate window minimize changes without native OS events.
  @visibleForTesting
  void setMinimizedForTesting(bool value) {
    if (_isMinimized != value) {
      _isMinimized = value;
      if (value) {
        _isFocused = false;
      }
      notifyListeners();
    }
    AppPowerManager.instance.setVisibleForTesting(!value);
  }

  @override
  void dispose() {
    AppPowerManager.instance.resetForTesting();
    if (_isInitialized) {
      WidgetsBinding.instance.removeObserver(this);
      if (!kIsWeb &&
          (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
        try {
          windowManager.removeListener(this);
        } catch (_) {}
      }
    }
    super.dispose();
  }
}
