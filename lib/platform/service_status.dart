/// Mirrors the status strings streamed on `sounddetective/service_status`.
enum ServiceStatus { started, stopped, listenerConnected, listenerDisconnected }

ServiceStatus serviceStatusFromWire(String value) {
  switch (value) {
    case 'STARTED':
      return ServiceStatus.started;
    case 'STOPPED':
      return ServiceStatus.stopped;
    case 'LISTENER_CONNECTED':
      return ServiceStatus.listenerConnected;
    case 'LISTENER_DISCONNECTED':
      return ServiceStatus.listenerDisconnected;
    default:
      throw ArgumentError('Unknown service status: $value');
  }
}
