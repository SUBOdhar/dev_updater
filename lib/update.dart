import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:dev_updater/dev_updater.dart'; // Ensure this path is correct

class UpdateAppPage extends StatefulWidget {
  final String newVersionNumber;
  final String appName;
  const UpdateAppPage({
    super.key,
    required this.newVersionNumber, // 2. Require it in the constructor
    required this.appName,
  });
  @override
  State<UpdateAppPage> createState() => _UpdateAppPageState();
}

class _UpdateAppPageState extends State<UpdateAppPage> {
  double _downloadProgress = 0.0;
  bool _isDownloading = false;
  String _errorMessage = ''; // To store any error message
  String _currentAppVersion = 'Loading...';

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        _currentAppVersion = packageInfo.version;
      });
    } catch (e) {
      setState(() {
        _currentAppVersion = 'Unknown';
      });
      debugPrint('Error loading package info: $e');
    }
  }

  /// Initiates the app download process.
  /// It fetches package info, then calls the download service.
  /// Updates download progress and handles success/failure messages.
  Future<void> _startDownload(BuildContext context) async {
    setState(() {
      _isDownloading = true;
      _downloadProgress = 0.0;
      _errorMessage = ''; // Clear any previous error
    });

    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      await DevUpdater().downloadAndOpenFile(
        'https://apps.subodh0.com.np/download-update/${packageInfo.packageName}',
        onReceiveProgress: (received, total) {
          if (total != null && total > 0) {
            setState(() {
              _downloadProgress = received / total;
            });
          }
        },
      );
      // Only show success snackbar if download completes and widget is still mounted
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Download completed. Opening installer...'),
            backgroundColor:
                Theme.of(
                  context,
                ).colorScheme.primary, // Use primary color for success
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      // Handle download errors
      String errorString = e.toString();
      debugPrint(
        'Download failed: $errorString',
      ); // Log the error for debugging
      setState(() {
        _errorMessage = errorString; // Store the error message
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Download failed: $errorString'),
            backgroundColor:
                Theme.of(
                  context,
                ).colorScheme.error, // Use error color for failure
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } finally {
      setState(() {
        _isDownloading = false;
        _downloadProgress = 0.0; // Reset progress on completion/failure
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('App Update'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // --- Feature Illustration ---
            Align(
              alignment: Alignment.center,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                width: 120.0,
                height: 120.0,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons
                      .auto_awesome_rounded, // A more engaging icon for updates
                  size: 64.0,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            const SizedBox(height: 32.0),

            // --- Main Heading (Short & Sweet) ---
            Text(
              'Ready for what\'s next?',
              textAlign: TextAlign.center,
              style: textTheme.headlineMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),

            // --- Sub-heading / Description (Short & Sweet) ---
            Text(
              'A new ${widget.appName} update is here! Get the latest features and fixes for a smoother experience.',
              textAlign: TextAlign.center,
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 40.0),

            // --- Version Information Card (Refined) ---
            Card(
              elevation: 2, // Slightly less elevation for a flatter look
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: colorScheme.surfaceContainerLow, // Lighter surface variant
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          'Your Version',
                          style: textTheme.labelMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        Text(
                          _currentAppVersion,
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.arrow_right_alt_rounded,
                      color: colorScheme.outline,
                    ),
                    Column(
                      children: [
                        Text(
                          'New Version',
                          style: textTheme.labelMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        Text(
                          widget.newVersionNumber,
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40.0),

            // --- Download Progress / Error Message (Combined & Smoother) ---
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child:
                  _isDownloading
                      ? Column(
                        key: const ValueKey('downloading'),
                        children: [
                          LinearProgressIndicator(
                            value: _downloadProgress,
                            backgroundColor:
                                colorScheme.surfaceContainerHighest,
                            color: colorScheme.primary,
                            minHeight: 10.0,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          const SizedBox(height: 12.0),
                          Text(
                            'Downloading update... ${(_downloadProgress * 100).toStringAsFixed(0)}%',
                            textAlign: TextAlign.center,
                            style: textTheme.labelLarge?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 24.0),
                        ],
                      )
                      : _errorMessage.isNotEmpty
                      ? Column(
                        key: const ValueKey('error'),
                        children: [
                          Icon(
                            Icons.warning_rounded,
                            color: colorScheme.error,
                            size: 36,
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            'Update failed: $_errorMessage',
                            textAlign: TextAlign.center,
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.error,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 24.0),
                        ],
                      )
                      : const SizedBox.shrink(
                        key: ValueKey('idle'),
                      ), // Empty space when no message
            ),

            // --- Update Button ---
            FilledButton.icon(
              onPressed: _isDownloading ? null : () => _startDownload(context),
              icon:
                  _isDownloading
                      ? SizedBox(
                        width: 20, // Smaller progress indicator for icon slot
                        height: 20,
                        child: CircularProgressIndicator(
                          color: colorScheme.onPrimary,
                          strokeWidth: 2,
                        ),
                      )
                      : const Icon(Icons.download_rounded),
              label: Text(
                _isDownloading
                    ? 'Getting the bits...'
                    : 'Get the Update', // More engaging text
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(vertical: 20),
                elevation: 4.0,
              ),
            ),
            const SizedBox(height: 16.0),

            // --- Optional: Not Now Button (TextButton) ---
          ],
        ),
      ),
    );
  }
}
