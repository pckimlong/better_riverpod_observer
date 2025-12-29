import 'package:better_riverpod_observer/better_riverpod_observer.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod/riverpod.dart';
import 'package:stack_trace/stack_trace.dart';
import 'package:talker_flutter/talker_flutter.dart';

base class TalkerRiverpodObserver extends ProviderObserver {
  TalkerRiverpodObserver({Talker? talker, this.settings = const BetterRiverpodObserverSettings()}) {
    _talker = talker ?? Talker();
  }

  final BetterRiverpodObserverSettings settings;

  late Talker _talker;

  @override
  @mustCallSuper
  void didAddProvider(ProviderObserverContext context, Object? value) {
    super.didAddProvider(context, value);
    if (!settings.enabled || !settings.printProviderAdded) {
      return;
    }
    final accepted = settings.providerFilter?.call(context.provider) ?? true;
    if (!accepted) {
      return;
    }

    if (value is Iterable ||
        (value is AsyncData && value.value is Iterable) ||
        (value is AsyncLoading && value.value is Iterable)) {
      final iterableValue = value is Iterable ? value : (value as AsyncValue).value as Iterable;
      _printIterable(context.provider, iterableValue);
      return;
    }

    if (value is Map || value is IMap) {
      _printMap(context.provider, value is IMap ? value.unlock : value as Map);
      return;
    }

    if (value is AsyncData || value is AsyncLoading) {
      final asyncValue = value as AsyncValue;
      if (asyncValue.value is Map) {
        _printMap(context.provider, asyncValue.value as Map);
        return;
      }
      if (asyncValue.value is IMap) {
        _printMap(context.provider, (asyncValue.value as IMap).unlock);
        return;
      }
    }

    _talker.info(
      'Provider added: ${context.provider.name ?? context.provider.runtimeType}',
      value,
      null,
    );
  }

  @override
  @mustCallSuper
  void didDisposeProvider(ProviderObserverContext context) {
    super.didDisposeProvider(context);
    if (!settings.enabled || !settings.printProviderDisposed) {
      return;
    }
    final accepted = settings.providerFilter?.call(context.provider) ?? true;
    if (!accepted) {
      return;
    }
    _talker.info('Provider disposed: ${context.provider.name ?? context.provider.runtimeType}');
  }

  @override
  @mustCallSuper
  void didUpdateProvider(ProviderObserverContext context, Object? previousValue, Object? newValue) {
    super.didUpdateProvider(context, previousValue, newValue);

    if (!settings.enabled || !settings.printProviderUpdated) {
      return;
    }
    final accepted = settings.providerFilter?.call(context.provider) ?? true;
    if (!accepted) {
      return;
    }

    if (newValue is AsyncError) {
      if (settings.didFailFilter?.call(newValue.error) == false) {
        return;
      }
      _talker.error(
        'Provider failed: ${context.provider.name ?? context.provider.runtimeType}',
        newValue.error,
        Trace.from(newValue.stackTrace).terse,
      );
      return;
    }

    if (newValue is Iterable ||
        (newValue is AsyncData && newValue.value is Iterable) ||
        (newValue is AsyncLoading && newValue.value is Iterable)) {
      if (newValue != null) {
        final iterableValue = newValue is Iterable
            ? newValue
            : (newValue as AsyncValue).value as Iterable;
        _printIterable(context.provider, iterableValue);
        return;
      }
    }

    if (newValue is Map || newValue is IMap) {
      _printMap(context.provider, newValue is IMap ? newValue.unlock : newValue as Map);
      return;
    }

    if (newValue is AsyncData || newValue is AsyncLoading) {
      final asyncValue = newValue as AsyncValue;
      if (asyncValue.value is Map) {
        _printMap(context.provider, asyncValue.value as Map);
        return;
      }
      if (asyncValue.value is IMap) {
        _printMap(context.provider, (asyncValue.value as IMap).unlock);
        return;
      }
    }

    _talker.info('Provider updated: ${context.provider.name ?? context.provider.runtimeType}', {
      'previous': previousValue,
      'new': newValue,
    }, null);
  }

  @override
  @mustCallSuper
  void providerDidFail(ProviderObserverContext context, Object error, StackTrace stackTrace) {
    super.providerDidFail(context, error, stackTrace);
    if (!settings.enabled || !settings.printProviderFailed) {
      return;
    }
    final accepted = settings.providerFilter?.call(context.provider) ?? true;
    if (!accepted) {
      return;
    }
    if (settings.didFailFilter?.call(error) == false) {
      return;
    }
    _talker.error(
      'Provider failed: ${context.provider.name ?? context.provider.runtimeType}',
      error,
      Trace.from(stackTrace).terse,
    );
  }

  void _printIterable(dynamic provider, Iterable value) {
    var limit = 5;

    // If the value is less than 3 times the limit, set the limit to the value length
    if (value.length < (limit * 2)) {
      limit = value.length;
    }
    final listString = value.take(limit).map((e) => e.toString()).join(',\n\t');
    final moreItems = value.length - limit;

    final valueString = value.isEmpty
        ? '[]'
        : '''Total length: ${value.length}\nRuntimeType: ${value.runtimeType}\n[
\t$listString,${moreItems > 0 ? '\n\t... \n\t+$moreItems more' : ''}
]''';
    _talker.info(
      'Provider added (iterable): ${provider.name ?? provider.runtimeType}',
      valueString,
      null,
    );
  }

  void _printMap(dynamic provider, Map value) {
    var limit = 5;

    // If the value is less than 3 times the limit, set the limit to the value length
    if (value.length < (limit * 2)) {
      limit = value.length;
    }

    final entries = value.entries.take(limit);
    final mapString = entries.map((e) => '${e.key}: ${e.value}').join(',\n\t');
    final moreItems = value.length - limit;

    final valueString = value.isEmpty
        ? '{}'
        : '''Total entries: ${value.length}\nRuntimeType: ${value.runtimeType}\n{
\t$mapString,${moreItems > 0 ? '\n\t... \n\t+$moreItems more' : ''}
}''';
    _talker.info(
      'Provider added (map): ${provider.name ?? provider.runtimeType}',
      valueString,
      null,
    );
  }
}

base class BetterRiverpodObserver extends TalkerRiverpodObserver {
  BetterRiverpodObserver({super.talker, BetterRiverpodObserverSettings? settings})
    : super(settings: settings ?? BetterRiverpodObserverSettings());
}
