// Licensed under the Apache License, Version 2.0
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:otel_gcp_cloud_functions/otel_gcp_cloud_functions.dart';

/// Traces Cloud Functions calls with OpenTelemetry.
///
/// `otel_gcp_cloud_functions` depends on the OpenTelemetry API only, so the application
/// initializes an SDK once at startup. Wrap each Cloud Functions call in
/// [tracedGcpCloudFunctions]; the `invoke` callback makes the real call and reports what
/// came back, which is recorded on the span.
Future<void> main() async {
  await OTel.initialize(serviceName: 'gcp-cloud-functions-example');

  // Wraps a Cloud Functions call in a CLIENT span.
  final gcpCloudFunctionsId = await tracedGcpCloudFunctions<String>(
    operation: 'functions.create',
    invoke: () async {
      // Make the Cloud Functions call here, then report what it returned.
      const id = 'gcp_cloud_functions_8f3a2c';
      return const GcpCloudFunctionsCallResult(
          value: id,
          result: GcpCloudFunctionsResult(
              project: 'example',
              region: 'us-east-1',
              generation: 'gen1',
              functionName: 'example',
              runtime: 'nodejs20',
              entryPoint: 'example',
              triggerKind: 'http',
              eventArcTriggerEvent: 'google.cloud.storage.object.v1.finalized',
              cpu: 'example',
              memoryMb: 1,
              timeoutSec: 1,
              minInstances: 1,
              maxInstances: 1,
              concurrency: 1,
              serviceAccountEmail: 'ada@example.com',
              invocationId: 'invocation_8f3a2c',
              executionId: 'function-execution-id',
              coldStart: true,
              durationMs: 120,
              functionExecutionResult: 'system_error',
              errorCode: 'FAILED_PRECONDITION',
              errorMessage: 'example',
              statusCode: 201));
    },
  );
  OTelLog.info(
      'tracedGcpCloudFunctions functions.create returned $gcpCloudFunctionsId');

  // Calls that should not be traced, such as health checks, run inside
  // runWithoutGcpCloudFunctionsInstrumentationAsync.
  await runWithoutGcpCloudFunctionsInstrumentationAsync(
    () => tracedGcpCloudFunctions<String>(
      operation: 'functions.create',
      invoke: () async {
        const id = 'gcp_cloud_functions_8f3a2c';
        return const GcpCloudFunctionsCallResult(
            value: id,
            result: GcpCloudFunctionsResult(
                project: 'example',
                region: 'us-east-1',
                generation: 'gen1',
                functionName: 'example',
                runtime: 'nodejs20',
                entryPoint: 'example',
                triggerKind: 'http',
                eventArcTriggerEvent:
                    'google.cloud.storage.object.v1.finalized',
                cpu: 'example',
                memoryMb: 1,
                timeoutSec: 1,
                minInstances: 1,
                maxInstances: 1,
                concurrency: 1,
                serviceAccountEmail: 'ada@example.com',
                invocationId: 'invocation_8f3a2c',
                executionId: 'function-execution-id',
                coldStart: true,
                durationMs: 120,
                functionExecutionResult: 'system_error',
                errorCode: 'FAILED_PRECONDITION',
                errorMessage: 'example',
                statusCode: 201));
      },
    ),
  );

  await OTel.shutdown();
}
