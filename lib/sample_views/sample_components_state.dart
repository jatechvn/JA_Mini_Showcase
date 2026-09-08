part of 'sample_components_view.dart';

abstract class _SampleComponentsStateBase extends State<SampleComponentsView> {
  int _clickCount = 0;
  bool _btnDestructive = false;
  bool _waveRunning = true;
  bool _useBouncingPhysics = true;
  int _bounceTrigger = 0;
  String _selectedGateway = 'vn-south-1';
  final ScrollController _bounceListController = ScrollController();
  final TextEditingController _marqueeController = TextEditingController(
    text:
        'JA Flutter Bento Glassmorphism & Dynamic Island UI Framework Showcase',
  );

  @override
  void dispose() {
    _bounceListController.dispose();
    _marqueeController.dispose();
    super.dispose();
  }
}
