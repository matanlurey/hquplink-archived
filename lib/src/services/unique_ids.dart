import 'package:flake_uuid/flake_base.dart';
import 'package:flake_uuid/flake_uuid.dart';

var _flakeGenerator = flake128;

/// Sets the current [deviceId].
void setDeviceId(String deviceId) {
  _flakeGenerator = Flake128(machineId: deviceId.hashCode);
}

/// Generates and returns a unique ID for the local system.
/// 
/// IDs that are meant to be unique across multiple users (i.e. synced to a
/// remote database) should rely on a server-generated unique ID and not this
/// value.
String generateLocalId() => 'local:${_flakeGenerator.nextUuid()}';
