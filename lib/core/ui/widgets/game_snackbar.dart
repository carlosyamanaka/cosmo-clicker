import 'package:flutter/material.dart';

class GameSnackbar {
  static final List<_GameSnackbarEntry> _active = [];
  static const int _maxActive = 3;
  static OverlayState? _overlayState;
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static void initOverlay() {
    final navigator = navigatorKey.currentState;
    if (navigator == null) return;
    _overlayState = navigator.overlay;
  }

  static void show(
    String message, {
    bool success = true,
    IconData? icon,
    ImageProvider? image,
    Widget? customLeading,
    Duration duration = const Duration(milliseconds: 1800),
  }) {
    if (_overlayState == null) {
      initOverlay();
      if (_overlayState == null) return;
    }
    if (_active.length >= _maxActive) {
      _active.first.remove();
      _active.removeAt(0);
    }
    final entry = _GameSnackbarEntry(
      overlayState: _overlayState!,
      message: message,
      success: success,
      icon: icon,
      image: image,
      customLeading: customLeading,
      duration: duration,
      onRemove: (e) => _active.remove(e),
      index: _active.length,
    );
    _active.add(entry);
    entry.show();
  }
}

class _GameSnackbarEntry {
  final OverlayState overlayState;
  final String message;
  final bool success;
  final IconData? icon;
  final ImageProvider? image;
  final Widget? customLeading;
  final Duration duration;
  final void Function(_GameSnackbarEntry) onRemove;
  final int index;
  late final OverlayEntry _entry;

  _GameSnackbarEntry({
    required this.overlayState,
    required this.message,
    required this.success,
    required this.icon,
    required this.image,
    required this.customLeading,
    required this.duration,
    required this.onRemove,
    required this.index,
  }) {
    _entry = OverlayEntry(
      builder: (context) => Positioned(
        left: 24,
        right: 24,
        bottom: MediaQuery.of(context).padding.bottom + 80.0 + (index * 80),
        child: _GameSnackbarWidget(
          message: message,
          success: success,
          icon: icon,
          image: image,
          customLeading: customLeading,
        ),
      ),
    );
  }

  void show() {
    overlayState.insert(_entry);
    Future.delayed(duration, remove);
  }

  void remove() {
    _entry.remove();
    onRemove(this);
  }
}

class _GameSnackbarWidget extends StatelessWidget {
  final String message;
  final bool success;
  final IconData? icon;
  final ImageProvider? image;
  final Widget? customLeading;

  const _GameSnackbarWidget({
    required this.message,
    required this.success,
    this.icon,
    this.image,
    this.customLeading,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        success ? Colors.greenAccent.shade700 : Colors.redAccent.shade200;
    final usedIcon =
        icon ?? (success ? Icons.check_circle : Icons.error_outline);
    Widget leading;
    if (customLeading != null) {
      leading = customLeading!;
    } else if (image != null) {
      leading = Image(
        image: image!,
        width: 28,
        height: 28,
        fit: BoxFit.contain,
      );
    } else {
      leading = Icon(usedIcon, color: color, size: 28);
    }
    return Material(
      color: Colors.transparent,
      child: AnimatedSlide(
        offset: const Offset(0, 0.2),
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: AnimatedOpacity(
          opacity: 1,
          duration: const Duration(milliseconds: 200),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.92),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                leading,
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    message,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
