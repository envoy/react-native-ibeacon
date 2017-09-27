import {
  NativeModules
} from 'react-native'

const { BeaconManager } = NativeModules as any

export default class Beacon {
  // FIXME:
  hello () {
    return BeaconManager.hello()
  }
}
