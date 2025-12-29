import 'package:talker_flutter/talker_flutter.dart';
import 'package:talker_riverpod_logger/talker_riverpod_logger_settings.dart';

class BetterRiverpodObserverSettings extends TalkerRiverpodLoggerSettings {
  const BetterRiverpodObserverSettings({
    super.enabled = true,
    super.printProviderAdded = false,
    super.printProviderUpdated = false,
    super.printProviderDisposed = false,
    super.printProviderFailed = true,
    super.printStateFullData = false,
    super.printFailFullData = true,
    super.printMutationFailed = true,
    super.printMutationReset = false,
    super.printMutationStart = true,
    super.printMutationSuccess = true,
    super.didFailFilter,
    super.didFailMutationFilter,
    super.providerFilter,
    super.providerAddedLevel = LogLevel.debug,
    super.providerUpdatedLevel = LogLevel.debug,
    super.providerDisposedLevel = LogLevel.debug,
    super.providerFailedLevel = LogLevel.error,
    super.mutationStartLevel = LogLevel.debug,
    super.mutationSuccessLevel = LogLevel.debug,
    super.mutationFailedLevel = LogLevel.error,
    super.mutationResetLevel = LogLevel.debug,
  });
}
