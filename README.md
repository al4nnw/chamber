# Chamber - A easy log viewing tool

## Introduction

Welcome to **Chamber**, a intuitive logging package for Flutter apps. Designed to help track issues on devices outside of the emulator world.

## Features

- **Easy Logging**: Log messages with optional categorization.
- **Flexible Retrieval**: Retrieve logs based on categories.
- **Clear Logs with Ease**: Clear all logs or specific categories.
- **In-App Log Display**: View logs in a user-friendly dialog.

## Getting Started

To get started with Chamber, follow these simple steps:

### Installation

Add Chamber to your Flutter project by including it in your `pubspec.yaml` file:

```yaml
dependencies:
  chamber: ^1.0.0
```

### Usage

Here's a quick guide to using Chamber in your app:

#### Logging Messages

```dart
Chamber.log("User logged in successfully", "auth");
Chamber.log("This is a general log message"); // Defaults to "general" key.
```

#### Retrieving Logs

```dart
List<String> authLogs = Chamber.get("auth");
List<String> generalLogs = Chamber.get();
```

#### Clearing Logs

```dart
Chamber.clear("auth"); // Clears only 'auth' logs.
Chamber.clear(); // Clears all logs.
```

#### Displaying Logs

```dart
Chamber.display(context); // Displays logs in a dialog.
Chamber.display(context, "auth"); // Displays logs of a specific key in a dialog.
```

### Contributing

Contributions to Chamber are welcome!

### License

Chamber is released under the MIT License.

### Support

If you encounter any issues or have suggestions, please open an issue on our GitHub repository.
