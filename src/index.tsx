import { NativeEventEmitter, NativeModules } from 'react-native'

const { BeaconManager } = NativeModules as any

export const StatusUpdateEvent = 'StatusUpdate'
export type Status =
  | 'unknown'
  | 'resetting'
  | 'unsupported'
  | 'unauthorized'
  | 'poweredOff'
  | 'poweredOn'

export default class Beacon {
  static emitter: NativeEventEmitter = new NativeEventEmitter(BeaconManager)

  static startAdvertising (
    uuid: string,
    major: number,
    minor: number,
    identifier
  ) {
    return BeaconManager.startAdvertising(uuid, major, minor, identifier)
  }

  static stopAdvertising () {
    BeaconManager.stopAdvertising()
  }

  static currentStatus (): Promise<Status> {
    return BeaconManager.currentStatus()
  }
}
