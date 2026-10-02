part of 'glass_widgets.dart';

/// Asymmetric Ping-Pong Marquee Text widget:
/// - Only scrolls if text overflows the container constraints.
/// - Hold at start for [pauseStart] (e.g. 1400ms).
/// - Smoothly scrolls forward to the end with [forwardCurve].
/// - Hold at end for [pauseEnd] (e.g. 1400ms).
/// - Smoothly scrolls back to start with [returnCurve].
/// - Zero performance overhead when text fits within bounds.
/// - Uses Session Epoch Guard and offset freezing when paused/blurred to
///   guarantee 0 ghost callback leaks and smooth resume without jumping back to 0.
class AsymmetricMarqueeText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Duration pauseStart;
  final Duration pauseEnd;
  final double velocity; // px/sec
  final Curve forwardCurve;
  final Curve returnCurve;

  const AsymmetricMarqueeText({
    super.key,
    required this.text,
    this.style,
    this.pauseStart = const Duration(milliseconds: 1400),
    this.pauseEnd = const Duration(milliseconds: 1400),
    this.velocity = 35.0,
    this.forwardCurve = Curves.easeInOutCubic,
    this.returnCurve = Curves.easeInOutCubic,
  });

  @override
  State<AsymmetricMarqueeText> createState() => _AsymmetricMarqueeTextState();
}

class _AsymmetricMarqueeTextState extends State<AsymmetricMarqueeText> {
  final ScrollController _scrollController = ScrollController();
  Timer? _timer;
  bool _isDisposed = false;

  // Session Epoch Guard & Offset Freeze state
  int _sessionEpoch = 0;
  bool _isPaused = false;
  bool _isMovingForward = true;
  bool _lastEfficiency = false;

  bool get _shouldAnimate {
    if (_lastEfficiency) return false;
    return AppPowerManager.instance.shouldAnimateMarquee;
  }

  @override
  void initState() {
    super.initState();
    AppPowerManager.instance.marqueeAnimationNotifier.addListener(
      _onPowerManagerChanged,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isDisposed && mounted && _shouldAnimate) {
        _scheduleStart();
      }
    });
  }

  void _onPowerManagerChanged() {
    if (!mounted || _isDisposed) return;
    final should = _shouldAnimate;
    if (should && _isPaused) {
      _resumeMarquee();
    } else if (!should && !_isPaused) {
      _pauseMarquee();
    }
  }

  @override
  void didUpdateWidget(covariant AsymmetricMarqueeText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _sessionEpoch++;
      _timer?.cancel();
      _timer = null;
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0);
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_isDisposed && mounted && _shouldAnimate) {
          _scheduleStart();
        }
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bool isEfficiency = false;
    try {
      isEfficiency = context.watch<ThemeProvider>().isEfficiencyMode;
    } catch (_) {
      try {
        isEfficiency = context.watch<WindowFocusService>().isEfficiencyMode;
      } catch (_) {}
    }

    if (isEfficiency != _lastEfficiency) {
      _lastEfficiency = isEfficiency;
      final should = _shouldAnimate;
      if (!should && !_isPaused) {
        _pauseMarquee();
      } else if (should && _isPaused) {
        _resumeMarquee();
      }
    }
  }

  void _pauseMarquee() {
    if (_isPaused) return;
    _isPaused = true;
    _sessionEpoch++;
    _timer?.cancel();
    _timer = null;
    if (_scrollController.hasClients) {
      final currentOffset = _scrollController.offset;
      _scrollController.jumpTo(currentOffset);
    }
  }

  void _resumeMarquee() {
    if (!_shouldAnimate || !_isPaused || _isDisposed || !mounted) return;
    _isPaused = false;
    final epoch = ++_sessionEpoch;

    void executeResume() {
      if (epoch != _sessionEpoch || _isPaused || _isDisposed || !mounted) {
        return;
      }
      if (!_scrollController.hasClients) {
        _timer = Timer(const Duration(milliseconds: 150), _resumeMarquee);
        return;
      }
      final maxScroll = _scrollController.position.maxScrollExtent;
      if (maxScroll <= 0) return;

      final currentOffset = _scrollController.offset;

      if (_isMovingForward) {
        final remaining = (maxScroll - currentOffset).clamp(0.0, maxScroll);
        if (remaining <= 2.0) {
          _isMovingForward = false;
          _timer = Timer(widget.pauseEnd, () => _animateReturn(epoch));
        } else {
          final durationMs = ((remaining / widget.velocity) * 1000)
              .round()
              .clamp(200, 6000);
          _scrollController
              .animateTo(
                maxScroll,
                duration: Duration(milliseconds: durationMs),
                curve: widget.forwardCurve,
              )
              .then((_) {
                if (epoch != _sessionEpoch ||
                    _isPaused ||
                    _isDisposed ||
                    !mounted) {
                  return;
                }
                _isMovingForward = false;
                _timer = Timer(widget.pauseEnd, () => _animateReturn(epoch));
              });
        }
      } else {
        final remaining = currentOffset.clamp(0.0, maxScroll);
        if (remaining <= 2.0) {
          _isMovingForward = true;
          _timer = Timer(widget.pauseStart, () => _animateForward(epoch));
        } else {
          final durationMs = ((remaining / (widget.velocity * 1.25)) * 1000)
              .round()
              .clamp(200, 5000);
          _scrollController
              .animateTo(
                0,
                duration: Duration(milliseconds: durationMs),
                curve: widget.returnCurve,
              )
              .then((_) {
                if (epoch != _sessionEpoch ||
                    _isPaused ||
                    _isDisposed ||
                    !mounted) {
                  return;
                }
                _isMovingForward = true;
                _timer = Timer(widget.pauseStart, () => _animateForward(epoch));
              });
        }
      }
    }

    if (_scrollController.hasClients) {
      executeResume();
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) => executeResume());
    }
  }

  void _scheduleStart() {
    _timer?.cancel();
    if (!_shouldAnimate || _isPaused || _isDisposed || !mounted) return;
    final epoch = ++_sessionEpoch;
    if (!_scrollController.hasClients) {
      _timer = Timer(const Duration(milliseconds: 150), _scheduleStart);
      return;
    }

    final maxScroll = _scrollController.position.maxScrollExtent;
    if (maxScroll <= 0) return;

    _isMovingForward = true;
    _timer = Timer(widget.pauseStart, () => _animateForward(epoch));
  }

  void _animateForward(int epoch) {
    _timer?.cancel();
    if (epoch != _sessionEpoch ||
        _isPaused ||
        _isDisposed ||
        !mounted ||
        !_scrollController.hasClients) {
      return;
    }
    final maxScroll = _scrollController.position.maxScrollExtent;
    if (maxScroll <= 0) return;
    _isMovingForward = true;

    final duration = Duration(
      milliseconds: ((maxScroll / widget.velocity) * 1000).round().clamp(
        600,
        6000,
      ),
    );

    _scrollController
        .animateTo(maxScroll, duration: duration, curve: widget.forwardCurve)
        .then((_) {
          if (epoch != _sessionEpoch || _isPaused || _isDisposed || !mounted) {
            return;
          }
          _isMovingForward = false;
          _timer = Timer(widget.pauseEnd, () => _animateReturn(epoch));
        });
  }

  void _animateReturn(int epoch) {
    _timer?.cancel();
    if (epoch != _sessionEpoch ||
        _isPaused ||
        _isDisposed ||
        !mounted ||
        !_scrollController.hasClients) {
      return;
    }
    final maxScroll = _scrollController.position.maxScrollExtent;
    if (maxScroll <= 0) return;
    _isMovingForward = false;

    final duration = Duration(
      milliseconds: ((maxScroll / (widget.velocity * 1.25)) * 1000)
          .round()
          .clamp(500, 5000),
    );

    _scrollController
        .animateTo(0, duration: duration, curve: widget.returnCurve)
        .then((_) {
          if (epoch != _sessionEpoch || _isPaused || _isDisposed || !mounted) {
            return;
          }
          _isMovingForward = true;
          _timer = Timer(widget.pauseStart, () => _animateForward(epoch));
        });
  }

  @override
  void dispose() {
    _isDisposed = true;
    _sessionEpoch++;
    _timer?.cancel();
    _timer = null;
    AppPowerManager.instance.marqueeAnimationNotifier.removeListener(
      _onPowerManagerChanged,
    );
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      child: Text(
        widget.text,
        style: widget.style,
        maxLines: 1,
        softWrap: false,
      ),
    );
  }
}

typedef MarqueeText = AsymmetricMarqueeText;
typedef BounceMarqueeText = AsymmetricMarqueeText;
