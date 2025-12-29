# Better Riverpod Observer

A better Riverpod observer with enhanced logging and debugging capabilities for Flutter applications. This package provides a comprehensive observer that integrates with Talker for advanced logging, filtering, and error handling in your Riverpod state management.

## Features

- **Enhanced Logging**: Integrates with Talker for powerful and customizable logging
- **Smart Data Formatting**: Automatically formats collections, maps, and async values for better readability
- **Flexible Filtering**: Filter which providers to observe with custom filters
- **Error Handling**: Comprehensive error logging with stack traces
- **Async Value Support**: Special handling for `AsyncData`, `AsyncLoading`, and `AsyncError`
- **Collection Support**: Smart formatting for `Iterable`, `Map`, and `IMap` types
- **Configurable Output**: Control what gets logged (added, updated, disposed, failed providers)

## Getting started

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  better_riverpod_observer: 
    git:
      url: https://github.com/pckimlong/better_riverpod_observer.git
      ref: main
```

Then import and use it in your Flutter app:

```dart
import 'package:better_riverpod_observer/better_riverpod_observer.dart';
import 'package:riverpod/riverpod.dart';
```

## Usage

### Basic Setup

```dart
// Create the observer
final observer = BetterRiverpodObserver();

// Add it to your ProviderContainer
final container = ProviderContainer(
  observers: [observer],
);

// Or use with Riverpod's ProviderScope
ProviderScope(
  observers: [observer],
  child: MyApp(),
);
```

### Advanced Configuration

```dart
// Custom settings with filtering
final observer = BetterRiverpodObserver(
  settings: BetterRiverpodObserverSettings(
    enabled: true,
    printProviderAdded: true,
    printProviderUpdated: true,
    printProviderDisposed: true,
    printProviderFailed: true,
    providerFilter: (provider) {
      // Only observe specific providers
      return provider.name?.contains('important') ?? false;
    },
    didFailFilter: (error) {
      // Filter out certain errors
      return !(error is NetworkException);
    },
  ),
);

// Use with custom Talker instance
final talker = Talker(
  settings: TalkerSettings(
    // Configure Talker as needed
  ),
);

final observer = BetterRiverpodObserver(
  talker: talker,
  settings: const BetterRiverpodObserverSettings(
    printProviderAdded: true,
    printProviderUpdated: true,
  ),
);
```

### Example with Different Data Types

```dart
// The observer automatically handles different data types:

// Lists and Iterables
final listProvider = Provider<List<String>>((ref) => ['item1', 'item2', 'item3']);

// Maps
final mapProvider = Provider<Map<String, int>>((ref) => {'key1': 1, 'key2': 2});

// Async values
final asyncProvider = FutureProvider<String>((ref) async => 'Hello World');

// Immutable collections (IMap, IList, etc.)
final immutableMapProvider = Provider<IMap<String, int>>((ref) => 
  IMap({'key1': 1, 'key2': 2}).lock
);
```

## Configuration Options

`BetterRiverpodObserverSettings` extends `TalkerRiverpodLoggerSettings` and provides:

- `enabled`: Enable/disable the observer (default: true)
- `printProviderAdded`: Log when providers are added (default: false)
- `printProviderUpdated`: Log when providers are updated (default: false)
- `printProviderDisposed`: Log when providers are disposed (default: true)
- `printProviderFailed`: Log when providers fail (default: true)
- `providerFilter`: Custom function to filter which providers to observe
- `didFailFilter`: Custom function to filter which errors to log

## Output Examples

The observer provides formatted output for different data types:

### Collections
```
Provider added (iterable): myListProvider
Total length: 100
RuntimeType: List<String>
[
    item1,
    item2,
    item3,
    item4,
    item5,
    ...
    +95 more
]
```

### Maps
```
Provider added (map): myMapProvider
Total entries: 50
RuntimeType: _Map<String, dynamic>
{
    key1: value1,
    key2: value2,
    key3: value3,
    key4: value4,
    key5: value5,
    ...
    +45 more
}
```

## Additional information

This package builds upon [talker_riverpod_logger](https://pub.dev/packages/talker_riverpod_logger) and provides enhanced formatting and filtering capabilities for Riverpod state management debugging.

### Dependencies
- `riverpod`: ^3.1.0
- `talker_flutter`: ^5.1.9
- `talker_riverpod_logger`: ^5.1.9
- `fast_immutable_collections`: ^11.1.0
- `stack_trace`: ^1.12.1

### Contributing
Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

### Issues
If you find any bugs or have feature requests, please file an issue on the [GitHub repository](https://github.com/your-username/better_riverpod_observer/issues).

### License
This project is licensed under the MIT License - see the LICENSE file for details.
