// Licensed under the Dartastic Pro Software License Agreement.
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';

import 'otel_gcp_cloud_functions_suppression.dart';

const _tracerName = 'dartastic_otel_libs_gcp_cloud_functions';

Tracer _tracer() => OTel.tracerProvider().getTracer(_tracerName);

class GcpCloudFunctionsResult {
  const GcpCloudFunctionsResult({
    this.project,
    this.region,
    this.generation,
    this.functionName,
    this.runtime,
    this.entryPoint,
    this.triggerKind,
    this.eventArcTriggerEvent,
    this.cpu,
    this.memoryMb,
    this.timeoutSec,
    this.minInstances,
    this.maxInstances,
    this.concurrency,
    this.serviceAccountEmail,
    this.invocationId,
    this.executionId,
    this.coldStart,
    this.durationMs,
    this.functionExecutionResult,
    this.errorCode,
    this.errorMessage,
    this.statusCode,
  });

  final String? project;
  final String? region;

  /// `gen1`, `gen2`.
  final String? generation;

  final String? functionName;

  /// `nodejs20`, `python312`, `go122`, `java21`, `dotnet8`, `ruby32`,
  /// `php82`.
  final String? runtime;
  final String? entryPoint;

  /// `http`, `eventarc`, `pubsub`, `storage`, `firestore`, `auth`,
  /// `analytics`, `crashlytics`, `remoteconfig`, `eventarc.firestore`,
  /// `scheduler`, `tasks`.
  final String? triggerKind;

  /// EventArc event type (`google.cloud.storage.object.v1.finalized`,
  /// `google.cloud.pubsub.topic.v1.messagePublished`, ...).
  final String? eventArcTriggerEvent;

  final String? cpu;
  final int? memoryMb;
  final int? timeoutSec;
  final int? minInstances;
  final int? maxInstances;
  final int? concurrency;

  final String? serviceAccountEmail;

  /// X-Cloud-Trace invocation id.
  final String? invocationId;

  /// Function execution id (`function-execution-id` header).
  final String? executionId;

  final bool? coldStart;
  final int? durationMs;

  /// `system_error`, `crash`, `timeout`, `aborted_execution`,
  /// `out_of_memory`, `connection_error`, `response_error`, `ok`.
  final String? functionExecutionResult;

  /// Cloud Functions error code (`FAILED_PRECONDITION`, `NOT_FOUND`,
  /// `PERMISSION_DENIED`, `UNAVAILABLE`, `INTERNAL`).
  final String? errorCode;
  final String? errorMessage;
  final int? statusCode;
}

class GcpCloudFunctionsCallResult<T> {
  const GcpCloudFunctionsCallResult({required this.value, this.result});
  final T value;
  final GcpCloudFunctionsResult? result;
}

/// Wraps a Cloud Functions call in a CLIENT span. [operation] is one of
/// `functions.create`, `functions.update`, `functions.delete`,
/// `functions.get`, `functions.list`, `functions.generateDownloadUrl`,
/// `functions.generateUploadUrl`, `functions.setIamPolicy`,
/// `functions.getIamPolicy`, `invoke.http`, `invoke.eventarc`,
/// `invoke.pubsub`, `invoke.storage`, `invoke.firestore`,
/// `invoke.scheduler`, `invoke.tasks`.
Future<T> tracedGcpCloudFunctions<T>({
  required String operation,
  required Future<GcpCloudFunctionsCallResult<T>> Function() invoke,
}) async {
  if (gcpCloudFunctionsInstrumentationSuppressed()) {
    final r = await invoke();
    return r.value;
  }
  final m = <String, Object>{
    'rpc.system': 'gcp_cloud_functions',
    'rpc.method': operation,
    'gcp_cloud_functions.operation': operation,
  };

  final span = _tracer().startSpan(
    'gcp_cloud_functions $operation',
    kind: SpanKind.client,
    attributes: OTel.attributesFromMap(m),
  );
  try {
    final r = await invoke();
    if (r.result != null) {
      final res = r.result!;
      final extras = <Attribute<Object>>[];
      if (res.project != null) {
        extras.add(OTel.attributeString(
          'gcp_cloud_functions.project',
          res.project!,
        ));
      }
      if (res.region != null) {
        extras.add(OTel.attributeString(
          'gcp_cloud_functions.region',
          res.region!,
        ));
      }
      if (res.generation != null) {
        extras.add(OTel.attributeString(
          'gcp_cloud_functions.generation',
          res.generation!,
        ));
      }
      if (res.functionName != null) {
        extras.add(OTel.attributeString(
          'gcp_cloud_functions.function.name',
          res.functionName!,
        ));
      }
      if (res.runtime != null) {
        extras.add(OTel.attributeString(
          'gcp_cloud_functions.runtime',
          res.runtime!,
        ));
      }
      if (res.entryPoint != null) {
        extras.add(OTel.attributeString(
          'gcp_cloud_functions.entry_point',
          res.entryPoint!,
        ));
      }
      if (res.triggerKind != null) {
        extras.add(OTel.attributeString(
          'gcp_cloud_functions.trigger.kind',
          res.triggerKind!,
        ));
      }
      if (res.eventArcTriggerEvent != null) {
        extras.add(OTel.attributeString(
          'gcp_cloud_functions.eventarc.event_type',
          res.eventArcTriggerEvent!,
        ));
      }
      if (res.cpu != null) {
        extras.add(OTel.attributeString(
          'gcp_cloud_functions.cpu',
          res.cpu!,
        ));
      }
      if (res.memoryMb != null) {
        extras.add(OTel.attributeInt(
          'gcp_cloud_functions.memory_mb',
          res.memoryMb!,
        ));
      }
      if (res.timeoutSec != null) {
        extras.add(OTel.attributeInt(
          'gcp_cloud_functions.timeout_sec',
          res.timeoutSec!,
        ));
      }
      if (res.minInstances != null) {
        extras.add(OTel.attributeInt(
          'gcp_cloud_functions.min_instances',
          res.minInstances!,
        ));
      }
      if (res.maxInstances != null) {
        extras.add(OTel.attributeInt(
          'gcp_cloud_functions.max_instances',
          res.maxInstances!,
        ));
      }
      if (res.concurrency != null) {
        extras.add(OTel.attributeInt(
          'gcp_cloud_functions.concurrency',
          res.concurrency!,
        ));
      }
      if (res.serviceAccountEmail != null) {
        extras.add(OTel.attributeString(
          'gcp_cloud_functions.service_account.email',
          res.serviceAccountEmail!,
        ));
      }
      if (res.invocationId != null) {
        extras.add(OTel.attributeString(
          'gcp_cloud_functions.invocation.id',
          res.invocationId!,
        ));
      }
      if (res.executionId != null) {
        extras.add(OTel.attributeString(
          'gcp_cloud_functions.execution.id',
          res.executionId!,
        ));
      }
      if (res.coldStart != null) {
        extras.add(OTel.attributeBool(
          'gcp_cloud_functions.cold_start',
          res.coldStart!,
        ));
      }
      if (res.durationMs != null) {
        extras.add(OTel.attributeInt(
          'gcp_cloud_functions.duration_ms',
          res.durationMs!,
        ));
      }
      if (res.functionExecutionResult != null) {
        extras.add(OTel.attributeString(
          'gcp_cloud_functions.execution.result',
          res.functionExecutionResult!,
        ));
        if (res.functionExecutionResult != 'ok') {
          span.setStatus(
            SpanStatusCode.Error,
            'Cloud Function ${res.functionExecutionResult}',
          );
        }
      }
      if (res.errorCode != null) {
        extras.add(OTel.attributeString(
          'gcp_cloud_functions.error.code',
          res.errorCode!,
        ));
        span.setStatus(
          SpanStatusCode.Error,
          'Cloud Functions ${res.errorCode}',
        );
      }
      if (res.errorMessage != null) {
        extras.add(OTel.attributeString(
          'gcp_cloud_functions.error.message',
          res.errorMessage!,
        ));
      }
      if (res.statusCode != null) {
        extras.add(OTel.attributeInt(
          'http.response.status_code',
          res.statusCode!,
        ));
        if (res.statusCode! >= 400) {
          span.setStatus(
            SpanStatusCode.Error,
            'Cloud Functions HTTP ${res.statusCode}',
          );
        }
      }
      if (extras.isNotEmpty) span.addAttributes(OTel.attributes(extras));
    }
    return r.value;
  } catch (e, st) {
    span.addAttributes(OTel.attributes([
      OTel.attributeString(
        ErrorResource.errorType.key,
        e.runtimeType.toString(),
      ),
    ]));
    span.recordException(e, stackTrace: st);
    span.setStatus(SpanStatusCode.Error, e.toString());
    rethrow;
  } finally {
    span.end();
  }
}
