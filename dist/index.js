import { NativeEventEmitter, NativeModules } from 'react-native';
const { BeaconManager } = NativeModules;
export const StatusUpdateEvent = 'StatusUpdate';
export default class Beacon {
    static startAdvertising(uuid, major, minor, identifier) {
        return BeaconManager.startAdvertising(uuid, major, minor, identifier);
    }
    static stopAdvertising() {
        BeaconManager.stopAdvertising();
    }
    static currentStatus() {
        return BeaconManager.currentStatus();
    }
}
Beacon.emitter = new NativeEventEmitter(BeaconManager);
