import 'dart:convert';
import 'dart:io';
import 'package:dev_updater/update.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DevUpdater {
  Future<void> checkAndUpdate(BuildContext context) async {
    // Accept BuildContext
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final response = await http.get(
      Uri.parse(
        'https://apps.subodh0.com.np/version/${packageInfo.packageName}?appVersion=${packageInfo.version}',
      ), // Replace with your server URL
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['updateAvailable'] == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (_) => UpdateAppPage(
                  newVersionNumber: data['currentVersion'],
                  appName: packageInfo.appName,
                ),
          ),
        );
      }
    }
  }

  Future<void> downloadAndOpenFile(
    String fileUrl, {
    void Function(int received, int? total)? onReceiveProgress,
  }) async {
    try {
      final request = http.Request('GET', Uri.parse(fileUrl));
      final streamedResponse = await http.Client().send(request);
      final totalBytes = streamedResponse.contentLength;
      List<int> bytes = [];
      int receivedBytes = 0;

      if (streamedResponse.statusCode == 200) {
        final tempDir = await getTemporaryDirectory();
        final fileName = fileUrl.split('/').last;
        final filePath = '${tempDir.path}/$fileName';
        final file = File(filePath);
        final sink = file.openWrite();

        await for (final chunk in streamedResponse.stream) {
          bytes.addAll(chunk);
          receivedBytes += chunk.length;
          if (onReceiveProgress != null) {
            onReceiveProgress(receivedBytes, totalBytes);
          }
        }
        await sink.addStream(Stream.fromIterable([bytes]));
        await sink.close();

        final result = await OpenFilex.open(filePath);

        if (result.type == ResultType.done) {
          print('File opened successfully');
        } else {
          print('Error opening file: ${result.message}');
        }
      } else {
        print(
          'Failed to download file. Status code: ${streamedResponse.statusCode}',
        );
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }
}
