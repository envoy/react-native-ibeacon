import { NativeModules } from 'react-native';
const { BeaconManager } = NativeModules;
export default class Beacon {
    // FIXME:
    hello() {
        return BeaconManager.hello();
    }
}
