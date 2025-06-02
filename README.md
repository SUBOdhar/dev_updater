---
## `dev_updater`

A Flutter package for in-app updates during the development phase, leveraging your app's global network.
---

### 🚀 Features

- **In-App Updates**: Easily prompt users to update your app directly from within the application.
- **Development Focused**: Designed specifically for the development and testing phases, making it easier to distribute new builds to your team.
- **Network-Based**: Utilizes your app's existing network capabilities to fetch update information and download new versions.

---

### 🛠️ Installation

Add `dev_updater` to your `pubspec.yaml` file:

```yaml
dependencies:
  dev_updater: ^0.0.1
```

Then, run `flutter pub get` to fetch the package.

---

### 💻 Usage

A basic example of how to use `dev_updater`:

```dart
import 'package:dev_updater/dev_updater.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Initialize DevUpdater
    DevUpdater().checkAndUpdate(context); // Add this on your main.dart files


  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Dev Updater Example'),
        ),
        body: Center(
          child:Text("Your Usual widget")
        ),
      ),
    );
  }
}
```

---

### Adding App to the global Network

Get the store.py file form [GitHub repository](https://github.com/SUBOdhar/App-Store)

Then run python store.py and fill the required fields

### 🤝 Contributing

Contributions are welcome\! Please feel free to open issues or pull requests on the [GitHub repository](https://github.com/SUBOdhar/dev_updater).

---

### 📄 License

This package is released under the MIT License. See the `LICENSE` file for more details.

---
