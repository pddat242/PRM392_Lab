import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'notification_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const NotificationDemoApp());
}

class NotificationDemoApp extends StatelessWidget {
  const NotificationDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seedColor = Color(0xFF3156C8);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab 10.5 - Notifications',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: seedColor),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F7FC),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF5F7FC),
          foregroundColor: Color(0xFF18233D),
        ),
      ),
      home: const NotificationHomePage(),
    );
  }
}

class NotificationHomePage extends StatefulWidget {
  const NotificationHomePage({super.key});

  @override
  State<NotificationHomePage> createState() => _NotificationHomePageState();
}

class _NotificationHomePageState extends State<NotificationHomePage> {
  late final NotificationService _notificationService;
  bool _isInitializing = true;
  bool _isBusy = false;
  bool _hasPermission = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _notificationService = NotificationService();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    try {
      await _notificationService.initialize();
      final permissionGranted =
          await _notificationService.areNotificationsEnabled();
      if (!mounted) return;

      setState(() {
        _hasPermission = permissionGranted;
        _isInitializing = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Could not initialize notifications: $error';
        _isInitializing = false;
      });
    }
  }

  Future<void> _requestPermission() async {
    setState(() {
      _isBusy = true;
      _errorMessage = null;
    });

    try {
      final permissionGranted =
          await _notificationService.requestPermission();
      if (!mounted) return;

      setState(() => _hasPermission = permissionGranted);
      _showMessage(
        permissionGranted
            ? 'Notification permission granted.'
            : 'Permission was not granted. Check your device or browser settings.',
        isError: !permissionGranted,
      );
    } catch (error) {
      if (!mounted) return;
      setState(() => _errorMessage = 'Permission request failed: $error');
      _showMessage('Could not request notification permission.', isError: true);
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }

  Future<void> _sendDemoNotification() async {
    setState(() {
      _isBusy = true;
      _errorMessage = null;
    });

    try {
      await _notificationService.showDemoNotification();
      if (!mounted) return;
      _showMessage('Test notification sent. Check the notification tray.');
    } catch (error) {
      if (!mounted) return;
      setState(() => _errorMessage = 'Could not show notification: $error');
      _showMessage('Could not show the test notification.', isError: true);
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Theme.of(context).colorScheme.error : null,
        ),
      );
  }

  String get _platformName {
    if (kIsWeb) return 'Chrome / Web';
    if (defaultTargetPlatform == TargetPlatform.android) return 'Android';
    return defaultTargetPlatform.name;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final statusColor = _errorMessage != null
        ? colors.error
        : _hasPermission
            ? const Color(0xFF1D8A56)
            : colors.primary;

    return Scaffold(
      appBar: AppBar(title: const Text('Lab 10.5 - Local Notifications')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    elevation: 0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                      side: const BorderSide(color: Color(0xFFE7EAF2)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(28),
                      child: Column(
                        children: [
                          Container(
                            width: 78,
                            height: 78,
                            decoration: BoxDecoration(
                              color: colors.primaryContainer,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.notifications_active_outlined,
                              size: 40,
                              color: colors.primary,
                            ),
                          ),
                          const SizedBox(height: 22),
                          Text(
                            'Try a local notification',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Request permission, then send a notification '
                            'to verify it appears on $_platformName.',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: colors.onSurfaceVariant,
                                ),
                          ),
                          const SizedBox(height: 24),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: statusColor.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  _isInitializing
                                      ? Icons.hourglass_top_rounded
                                      : _hasPermission
                                          ? Icons.check_circle_outline_rounded
                                          : Icons.info_outline_rounded,
                                  color: statusColor,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    _isInitializing
                                        ? 'Preparing notifications...'
                                        : _errorMessage ??
                                            (_hasPermission
                                                ? 'Notifications are enabled.'
                                                : 'Permission has not been granted yet.'),
                                    style: TextStyle(
                                      color: statusColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: OutlinedButton.icon(
                              onPressed: _isInitializing || _isBusy
                                  ? null
                                  : _requestPermission,
                              icon: _isBusy
                                  ? const SizedBox.square(
                                      dimension: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(Icons.verified_user_outlined),
                              label: const Text('Request notification permission'),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: FilledButton.icon(
                              onPressed: _isInitializing ||
                                      _isBusy ||
                                      !_hasPermission
                                  ? null
                                  : _sendDemoNotification,
                              icon: const Icon(Icons.send_rounded),
                              label: const Text('Send test notification'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Card(
                    elevation: 0,
                    color: const Color(0xFFEAF0FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(18),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.lightbulb_outline_rounded),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Android 13 and later asks for notification '
                              'permission. On Chrome, allow notifications when '
                              'the browser asks. Then tap “Send test notification”.',
                            ),
                          ),
                        ],
                      ),
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
