import 'package:flutter/material.dart';

enum AppAlertType {
  success,
  error,
  warning,
  info,
}

class AppAlert {
  static void show(
    BuildContext context, {
    required String title,
    required String message,
    AppAlertType type = AppAlertType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    final overlay = Overlay.of(context);

    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) {
        return _AppAlertWidget(
          title: title,
          message: message,
          type: type,
          duration: duration,
          onClose: () {
            overlayEntry.remove();
          },
        );
      },
    );

    overlay.insert(overlayEntry);
  }
}

class _AppAlertWidget extends StatefulWidget {
  final String title;
  final String message;
  final AppAlertType type;
  final Duration duration;
  final VoidCallback onClose;

  const _AppAlertWidget({
    required this.title,
    required this.message,
    required this.type,
    required this.duration,
    required this.onClose,
  });

  @override
  State<_AppAlertWidget> createState() => _AppAlertWidgetState();
}

class _AppAlertWidgetState extends State<_AppAlertWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _controller.forward();

    Future.delayed(widget.duration, () {
      if (mounted) {
        _close();
      }
    });
  }

  Future<void> _close() async {
    await _controller.reverse();
    widget.onClose();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color get _color {
    switch (widget.type) {
      case AppAlertType.success:
        return Colors.greenAccent;

      case AppAlertType.error:
        return Colors.redAccent;

      case AppAlertType.warning:
        return Colors.orangeAccent;

      case AppAlertType.info:
        return Colors.lightBlueAccent;
    }
  }

  IconData get _icon {
    switch (widget.type) {
      case AppAlertType.success:
        return Icons.check_circle_rounded;

      case AppAlertType.error:
        return Icons.error_rounded;

      case AppAlertType.warning:
        return Icons.warning_rounded;

      case AppAlertType.info:
        return Icons.info_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 15,
      left: 20,
      right: 20,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF151515).withOpacity(0.96),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: _color.withOpacity(0.35),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.35),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: _color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _icon,
                      color: _color,
                      size: 24,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          widget.message,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  GestureDetector(
                    onTap: _close,
                    child: const Icon(
                      Icons.close_rounded,
                      color: Colors.white54,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}